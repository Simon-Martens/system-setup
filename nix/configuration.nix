# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "holodeck"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
      enable = true;
      pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simon = {
      initialPassword = "init";
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" "networkmanager" "docker" "input" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
         tree
      ];
  };

  programs.firefox.enable = true;

  security.polkit.enable = true;
	hardware.bluetooth.enable = true;
	hardware.bluetooth.settings = {
		General = {
			Enable = "Source,Audio,Video,Peripheral,Media,Socket";
		};
	};

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
		  hyprcursor
		  bluetui
		  wiremix
		  fzf
		  gtk4
		  adwaita-fonts
      adwaita-icon-theme
      adwaita-qt
      neovim 
      git
      hypridle
      hyprpolkitagent
      uwsm
      hyprshot
      gum
      mesa
      nwg-displays
      nwg-look
      waypaper
      hyprland-qt-support
      brightnessctl
      cargo
      cmake
      eza
      zoxide
      clang
      cava
      curl
      ffmpeg
      fd
      nautilus
      jq
      gcc
      glib
      imagemagick
      openssl
      libnotify
      libappindicator
      killall
      swaynotificationcenter
      unzip
      wdisplays
      wl-clipboard
      wlr-randr
      yad
      yazi
      wget
      caligula
      atop
      btop
      gdu
      glances
      gping
      lsd
      ipfetch
      htop 
      ripgrep
      socat
      unrar
      lm_sensors
      smartmontools
      mission-center
      light
      vlc
      ghostty
      alacritty
			waybar
      kitty
		  nodejs
		  go
		  python3
		  swaybg
		  air
      gnome-themes-extra
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  system.stateVersion = "25.05"; # Did you read the comment?


  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs = {
		nix-index.enable = true;
    dconf.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  fonts = {
    packages = with pkgs; [ 
      fira-code
      fira-code-symbols
      noto-fonts
      roboto
      inter
   ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };
}

