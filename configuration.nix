# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix 
  ];

  # Bootloader configuration (Using systemd-boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking settings
  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true; # Enables wireless/wired network management

  # Set your time zone
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties
  i18n.defaultLocale = "vi_VN";

  # Enable the X11 windowing system
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };

  # Enable sound with pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tdung0912 = {
    isNormalUser = true;
    initialPassword = "dung0912";
    extraGroups = [ "networkmanager" "wheel" ]; # 'wheel' enables sudo
    packages = with pkgs; [
      tree
    ];
  };

  # Allow unfree packages (like Google Chrome, Nvidia drivers, VS Code)
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim 
    wget
    curl
    git
    htop
    fastfetch
  ];

  programs.firefox.enable = true;

  # Enable the OpenSSH daemon for remote access
  # services.openssh.enable = true;

  # Open ports in the firewall if necessary
  # networking.firewall.allowedTCPPorts = [ 22 80 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org).
  system.stateVersion = "26.05"; # Did you read the comment?
}