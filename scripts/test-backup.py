#!/usr/bin/env python3
"""Exercise the wrapper and exclusion rules against an isolated real repository."""
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile


SCRIPT = Path(__file__).resolve().with_name("backup.sh")


def main():
    # Never use the user's repository or credentials in this test.
    env = {k: v for k, v in os.environ.items() if not k.startswith("RESTIC_")}
    env.update(RESTIC_PASSWORD="local-integration-test-only", NO_COLOR="1")
    with tempfile.TemporaryDirectory(prefix="restic-home-test-") as temporary:
        root = Path(temporary)
        source = root / "home with spaces"
        repo = root / "repository"
        source.mkdir()
        kept = [
            "Documents/keep.txt", "Downloads/paper.pdf", ".ssh/key",
            ".fonts/personal.otf", ".config/application/settings.json",
            ".config/net.imput.helium/Default/Bookmarks",
            ".config/net.imput.helium/Default/Cookies",
            ".config/net.imput.helium/Default/IndexedDB/personal.data",
            ".config/net.imput.helium/Default/Local Storage/state",
            ".config/net.imput.helium/Default/WebStorage/8/IndexedDB/data",
            ".config/net.imput.helium/Default/Sessions/session",
            "Documents/cache/keep.txt",
        ]
        excluded = [f"{name}/discard.txt" for name in (
            "source", ".local", ".rustup", ".cargo", ".npm", ".codex",
            ".cache", ".fontconfig",
        )] + [
            "Documents/system.iso", "Downloads/system.ISO", "Downloads/app.rpm",
            "Downloads/app.AppImage", "Downloads/Armbian_test.img.xz",
            ".config/Cache/data", ".config/application/cache/data",
            ".config/net.imput.helium/component_crx_cache/data",
            ".config/net.imput.helium/Default/GPUCache/data",
            ".config/net.imput.helium/Default/Code Cache/data",
            ".config/net.imput.helium/Default/Shared Dictionary/cache/data",
            ".config/net.imput.helium/Default/Service Worker/CacheStorage/data",
            ".config/net.imput.helium/Default/Service Worker/ScriptCache/data",
            ".config/net.imput.helium/Default/WebStorage/8/CacheStorage/data",
        ]
        for relative in kept + excluded:
            path = source / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(f"fixture: {relative}\n")
        # Standard setup symlinks must survive, but their excluded targets must not.
        for relative in [".fonts/linked.otf", ".config/application/linked.conf"]:
            link = source / relative
            link.symlink_to(os.path.relpath(source / "source/discard.txt", link.parent))
            kept.append(relative)

        def run(*args, code=0, password=None):
            child_env = dict(env)
            if password is not None:
                child_env["RESTIC_PASSWORD"] = password
            result = subprocess.run(
                [str(SCRIPT), "--repo", str(repo), "--source", str(source), *args],
                env=child_env, text=True, stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT, timeout=60,
            )
            assert result.returncode == code, result.stdout
            return result.stdout

        def restic_json(*args):
            return subprocess.check_output(
                ["restic", "--repo", str(repo), "--no-cache", "--json", *args],
                env=env, text=True,
            )

        def repository_contents():
            return {
                str(path.relative_to(repo)): hashlib.sha256(path.read_bytes()).hexdigest()
                for path in repo.rglob("*") if path.is_file()
            }

        run("--dry-run", code=10)
        assert not repo.exists(), "Dry run created a repository"
        run("--dry-run", "--init", code=2)
        run("--init", "--dry-run", code=2)
        run("--unknown", code=2)
        run("--init")
        assert json.loads(restic_json("snapshots")) == [], "Init made a snapshot"
        before = repository_contents()
        preview = run("--dry-run", "--verbose")
        assert "DRY RUN COMPLETE" in preview
        assert repository_contents() == before, "Dry run changed repository data"
        assert json.loads(restic_json("snapshots")) == [], "Dry run made a snapshot"
        run("--dry-run", password="incorrect-test-password", code=12)

        # Actual backups here contain only disposable fixture files.
        assert "BACKUP COMPLETE" in run()
        nodes = {
            item["path"]: item for line in restic_json("ls", "latest").splitlines()
            if (item := json.loads(line)).get("struct_type") == "node"
            or item.get("message_type") == "node"
        }
        for relative in kept:
            assert str(source / relative) in nodes, f"Missing included file: {relative}"
        for relative in excluded:
            assert str(source / relative) not in nodes, f"Backed up exclusion: {relative}"
        for relative in [".fonts/linked.otf", ".config/application/linked.conf"]:
            assert nodes[str(source / relative)]["type"] == "symlink"

        # Regression: plain/piped output must also contain actual live counters.
        # Incompressible fixture data gives restic time to emit a status update.
        for number in range(32):
            (source / f"Documents/progress-{number}.bin").write_bytes(os.urandom(8 * 1024 * 1024))
        progress_output = run("--dry-run")
        assert re.search(r"\[\d+:\d{2}\].*\d+ files", progress_output), progress_output
        for fixture in source.glob("Documents/progress-*.bin"):
            fixture.unlink()

        if os.geteuid() != 0:
            unreadable = source / "Documents/unreadable.txt"
            unreadable.write_text("must report incomplete backup")
            unreadable.chmod(0)
            try:
                assert "INCOMPLETE" in run(code=3)
            finally:
                unreadable.chmod(0o600)
        print("PASS: dry run makes no repository/snapshot/data changes; init is separate")
        print("PASS: fonts, profiles, settings and symlinks kept; caches/tools/ISOs excluded")
        print("PASS: argument validation and real restic error codes preserved")
        print("PASS: live file counters appear in non-interactive output")


if __name__ == "__main__":
    main()
