{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    htop
    neovim
    ripgrep
    tmux
    wget
  ];
}
