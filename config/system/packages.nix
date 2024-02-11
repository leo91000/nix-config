{ pkgs, config, inputs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # For obsidianmd installation
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # List System Programs
  environment.systemPackages = with pkgs; [
    wget 
    curl 
    git 
    cmatrix 
    lolcat 
    neofetch 
    htop 
    btop 
    libvirt
    polkit_gnome 
    lm_sensors 
    unzip 
    unrar 
    libnotify 
    eza
    v4l-utils 
    ydotool 
    wl-clipboard 
    socat 
    cowsay 
    lsd 
    lshw
    pkg-config 
    openssl
    meson 
    hugo 
    gnumake 
    ninja 
    go 
    nodejs 
    symbola
    noto-fonts-color-emoji 
    material-icons 
    brightnessctl
    toybox 
    virt-viewer 
    swappy 
    ripgrep 
    appimage-run 
    networkmanagerapplet 
    yad
    playerctl
    nh
    wlr-randr
    nwg-displays
    obsidian
    gnome.gnome-keyring
    protonvpn-gui
    ffmpeg-full
  ];

  programs = {
    steam.gamescopeSession.enable = true;
    dconf.enable = true;
    seahorse.enable=true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
