{ config, pkgs, ... }:

# This contains the user-specific configuration for the user "simon"
{
  home.packages = with pkgs; [
		nodejs
		claude-code
		codex
  ];

	home.username = "simon";
	home.homeDirectory = "/home/simon";
	home.stateVersion = "25.11";

	programs.git = {
		enable = true;
		userEmail = "simon.martens@mailbox.org";
		userName = "Simon Martens";
		extraConfig = {
			pull.rebase = true;
		};
	};

	let
		adwaita-cursors = pkgs.fetchurl {
			url = "https://github.com/manu-mannattil/adwaita-cursors/releases/download/v1.2/adwaita-cursors.tar.gz";
			sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=";
		};
		
		extracted = pkgs.runCommand "adwaita-cursors-extracted" {} ''
			mkdir -p $out
			tar xzf ${adwaita-cursors} -C $out
		'';
	in {
		home.file.".icons/default/cursors" = {
			source = "${extracted}/adwaita-cursors/Adwaita/cursors";
			recursive = true;
		};
}
