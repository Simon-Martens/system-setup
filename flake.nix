{
  description = "My NixOS Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs@{ self, nixpkgs, ...}: {
    nixosConfigurations.home = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./nix/home.nix ];
    };
    nixosConfigurations.mobile = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./nix/mobile.nix ];
    };
  };
}
