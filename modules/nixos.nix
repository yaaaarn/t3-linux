{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) getExe;

  username = "user";
in
{
  #
  # meta
  #

  environment.etc."os-release".text = ''
    NAME="T^3 Linux"
    ID=t3
    PRETTY_NAME="Tung Tung Tung Linux"
    VERSION_CODENAME="sahur"
    HOME_URL="https://github.com/yaaaarn/t3-linux"
    SUPPORT_URL="https://github.com/yaaaarn/t3-linux/issues"
    BUG_REPORT_URL="https://github.com/yaaaarn/t3-linux/issues"
  '';

  networking.hostName = "computer";

  users.users.user = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
    ];
    initialHashedPassword = "";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  #
  # display manager
  #

  programs.mango.enable = true;
  services.displayManager = {
    defaultSession = "mango";
    autoLogin = {
      enable = true;
      user = username;
    };
    gdm = {
      enable = true;
    };
  };

  #
  # fonts
  #

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      comic-mono
      comic-relief
      times-newer-roman
      twitter-color-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Comic Mono" ];
        sansSerif = [ "Comic Relief" ];
        serif = [ "Times Newer Roman" ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };

  #
  # home manager
  #

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} =
    { pkgs, ... }:
    {
      #
      # meta
      #

      home.stateVersion = "26.05";

      imports = [
        inputs.mangowc.hmModules.mango
      ];

      #
      # goodies
      #

      home.packages = with pkgs; [
        cmatrix
        lolcat
        cowsay

        pcmanfm
        lxmenu-data
        shared-mime-info

        epiphany
      ];

      #
      # desktop
      #

      wayland.windowManager.mango = {
        enable = true;
        systemd.enable = true;
        systemd.xdgAutostart = true;
        autostart_sh = ''
          ${getExe pkgs.sfwbar} &
          ${getExe pkgs.swaybg} -i ${../assets/wallpaper.jpg} &
        '';
        settings = {
          focused_opacity = 0.9;
          unfocused_opacity = 0.95;

          bind = [
            "SUPER,R,reload_config"
            "SUPER,Q,killclient"
            "SUPER,Space,spawn,rofi -show drun"
            "SUPER,T,spawn,foot"
            "SUPER,V,togglefloating"
            "SUPER,O,toggleoverview"
            "ALT,R,setkeymode,resize"
          ];
        };
      };

      #
      # program suite
      #

      programs.fastfetch.enable = true;
      programs.foot = {
        enable = true;
        settings = { };
      };

      #
      # desktop entries 
      #

      xdg.desktopEntries = {
        install-roblox = {
          name = "Install Roblox";
          genericName = "Online multiplayer game";
          comment = "david bazooka we hate you";
          exec = "flatpak install flathub org.vinegarhq.Sober";
          icon = "applications-games";
          terminal = true;
          categories = [ "Game" ];
        };

        tung-tung-sahur = {
          name = "Tung Tung Sahur Obby Challenge";
          genericName = "Web Game";
          comment = "Play Tung Tung Sahur Obby Challenge on CrazyGames";
          exec = "xdg-open https://www.crazygames.com/game/tung-tung-sahur-obby-challenge";
          icon = "applications-games";
          terminal = false;
          categories = [
            "Game" 
          ];
        };
      };
    };

  #
  # misc
  #

  xdg.autostart.enable = true;

  services.flatpak.enable = true;

  # qemu vm tweaks
  virtualisation.vmVariant = {
    virtualisation.cores = 4;

    virtualisation.qemu.options = [
      "-enable-kvm"
      "-cpu host"
      "-vga virtio"
      "-display gtk,gl=on"
      "-device virtio-tablet-pci"
      "-smp 4"
      "-net nic -net user"
      "-m 4096"
    ];
  };
}
