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

home.file.".icons/default/cursors" = let
    adwaita-cursors = pkgs.fetchurl {
      url = "https://github.com/manu-mannattil/adwaita-cursors/releases/download/v1.2/adwaita-cursors.tar.gz";
      sha256 = "sha256-zDahuX7l0aGb+UKH1glnWBLVZHkMRTWQ1XlmxR8A/r8=";
    };
    
    extracted = pkgs.runCommand "adwaita-cursors-extracted" {} ''
      mkdir -p $out
      tar xzf ${adwaita-cursors} -C $out
    '';
  in {
    source = "${extracted}/adwaita-cursors/Adwaita/cursors";
    recursive = true;
  };

	# DARK THEME EVERYWHERE
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    font = {
      name = "Sans Serif";
      size = 11;
    };
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Qt configuration
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # dconf settings for GNOME/GTK applications
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita";
      cursor-theme = "Adwaita";
      enable-animations = true;
    };
  };

  # Set environment variables
  home.sessionVariables = {
    GTK_THEME = "Adwaita-dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };
}
