{
  description = "My NixOS Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs@{ self, nixpkgs, ...}: {
    nixosConfigurations.holodeck = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./nix/configuration.nix ];
    };
  };
}
