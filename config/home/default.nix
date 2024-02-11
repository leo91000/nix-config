{ pkgs, config, ... }:

{
  imports = [
    # Enable &/ Configure Programs
    ./alacritty.nix
    ./bash.nix
    ./gh.nix
    ./gtk-qt.nix
    ./hyprland.nix
    ./kdenlive.nix
    ./kitty.nix
    ./neofetch.nix
    ./neovim.nix
    ./packages.nix
    ./rofi.nix
    ./waybar.nix
    ./wlogout.nix
    ./swappy.nix
    ./swaylock.nix
    ./swaync.nix
    ./tmux.nix
    ./wezterm.nix
    ./zsh.nix

    # Place Home Files Like Pictures
    ./files.nix
  ];
}
