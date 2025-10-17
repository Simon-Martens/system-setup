{ config, lib, pkgs, ... }:

{
  imports =
    [ 
			./hardware/mobile-hardware.nix
			./common/configuration.nix
    ];
		
  	networking.hostName = "mobilenix";
	}
