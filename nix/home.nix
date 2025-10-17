{ config, lib, pkgs, ... }:

{
  imports =
    [ 
			./hardware/home-hardware.nix
			./common/configuration.nix
    ];
		
  	networking.hostName = "holodeck"; # Define your hostname.
	}
