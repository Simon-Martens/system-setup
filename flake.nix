{
  description = "My NixOS Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ...}: {
    nixosConfigurations.home = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
				./nix/home.nix 
				home-manager.nixosModules.home-manager 
				{
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
						home-manager.backupFileExtension = "backup";
            home-manager.users.simon = import ./nix/user/user.nix;
        }
			];
    };
    nixosConfigurations.mobile = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
				./nix/mobile.nix
				home-manager.nixosModules.home-manager 
				{
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
						home-manager.backupFileExtension = "backup";
            home-manager.users.simon = import ./nix/user/user.nix;
        }
			];
    };
  };
}
