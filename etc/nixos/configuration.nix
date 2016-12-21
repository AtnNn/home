{ config, pkgs, ... }:

let secrets = import ./secrets.nix; in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    extraEntries = ''
      menuentry "Windows 10" {
        chainloader (hd0,msdos1)+1
      }
    '';
    device = "/dev/sda";
  };

  networking = {
    hostName = "queen";
    wireless.enable = true;
    wireless.networks = secrets.wifi // { };
    wireless.userControlled.enable = true;
    nameservers = [
      "8.8.8.8" "8.8.4.4"
    ];
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "ibus";
    inputMethod.ibus.engines = [ pkgs.ibus-engines.m17n ];
  };

  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    wget
    firefox
    bind
    docker
    emacs
    file
    git
    htop
    lsof
    mplayer
    ncdu
    sudo
    wget
    which
    ghc
    python3
    php70
    coreutils
    ffmpeg
    vim
    gimp
    libreoffice
    skype
    utillinux
    zathura
    p7zip
    imagemagickBig
    acpi
    # chromium
    zip unzip
    irssi
    nmap
    # texLive
    gcc
    llvm
    screen
    pavucontrol
    gnupg
    w3m
    nixops
    powertop
    gdb
    gnumake
    graphviz
    man
    rtorrent
    ruby
    vlc
    glxinfo
    xorg.xkill
    wine
    man-pages
    stdmanpages
    clang
    curl
    nox
  ];

  environment.variables = {
    EDITOR = "vim";
  };

  services = {
    openssh.enable = true;
    printing.enable = true;
    locate = {
      enable = true;
      includeStore = true;
    };
    redshift = {
      enable = true;
      latitude = "35";
      longitude = "-80";
    };
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";
    desktopManager.xterm.enable = true;
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    windowManager.openbox.enable = true;

    # displayManager.sessionCommands = ''
    #   $(pkgs.ibus)/bin/ibus-daemon &;
    # '';

    synaptics.enable = true;
    synaptics.twoFingerScroll = true;
    synaptics.horizontalScroll = true;
  };

  users.users.root.hashedPassword = secrets.passwordHashes.root;
  users.users.atnnn = {
    isNormalUser = true;
    uid = 1000;
    group = "atnnn";
    extraGroups = [ "wheel" "docker" "audio" "vboxusers" ];
    createHome = true;
    hashedPassword = secrets.passwordHashes.atnnn;
  };
  users.groups.atnnn.gid = 1000;
  users.mutableUsers = false;

  system.stateVersion = "@nixosRelease@";

  programs.bash.enableCompletion = true;
  
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  security.rtkit.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    firefox.enableAdobeFlash = true;
    chromium.enablePepperFlash = true;
    chromium.enableWideVine = true;
  };

  nix = {
    useSandbox = true;
    trustedBinaryCaches = [ "http://hydra.nixos.org/" ];
  };

  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
    fonts = with pkgs; [ dejavu_fonts freefont_ttf unifont unifont_upper ];
  };
}
