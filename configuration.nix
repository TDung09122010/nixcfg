{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
        path = "${pkgs.bibata-cursors}/share/icons";
      };
    };
  };

  programs.umbriel.enable = true;

  services.dbus.enable = true;

  fonts.packages = with pkgs; [
  # Nhóm font lập trình phổ biến (Nerd Fonts bản mới)
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
  
  # Font mặc định của Google (Hỗ trợ tiếng Việt rất tốt)
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  
  # Các font mã nguồn mở quen thuộc khác
    fira-code-symbols
    mplus-outline-fonts.githubRelease
  ];

  time.hardwareClockInLocalTime = false; 
  environment.variables.TZDIR = lib.mkForce "/etc/zoneinfo";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-lotus ];
  };

  users.users.uinput_proxy = {
    isSystemUser = true;
    group = "uinput_proxy";
  };
  users.groups.uinput_proxy = { };

  systemd.packages = [ pkgs.fcitx5-lotus ];
  systemd.services."fcitx5-lotus-server@tdung0912" = {
    wantedBy = [ "multi-user.target" ];
    overrideStrategy = "asDropin";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  hardware.graphics.enable = true;



  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "vi_VN";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  security.polkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  users.mutableUsers = false;
  users.users.root.initialPassword = "dung0912";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tdung0912 = {
    initialPassword = "dung0912";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults lecture = never
    '';
  };

  programs.firefox.enable = true;

  programs.direnv.enable = true;

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"                        # Gương chính thức toàn cầu
      "https://mirrors.ustc.edu.cn/nix-channels/store" # Gương USTC (Trung Quốc/châu Á)
      "https://mirror.sjtu.edu.cn/nix-channels/store"  # Gương SJTU (Trung Quốc/châu Á)
      "https://nix-community.cachix.org"               # Gương cộng đồng Nix Community
      "https://attic.xuyh0120.win/lantian"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # <- Thiếu khóa này
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    xwayland-satellite
    nixd # Hoặc nil (nixd hiện tại được cộng đồng NixOS ưa chuộng hơn vì đọc được file cấu hình hệ thống)

    # 2. Formatter (Tự động căn lề, sửa dấu cách khi ấn Ctrl + S)
    nixfmt-rfc-style # Trình định dạng chuẩn hóa mới nhất của NixOS
    git
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.custom-packages.packages.${pkgs.stdenv.hostPlatform.system}.thorium-avx2
    wl-clipboard
    # Công cụ nén/giải nén hệ thống
    lzip

  # Python và các công cụ quản lý gói đi kèm
    python3
    python3Packages.pip
    python3Packages.virtualenv # Rất cần thiết trên NixOS

  # Các công cụ bổ trợ thường dùng cho wayland-script (nếu cần)
    wtype
    ydotool
  ];

  # Đảm bảo bật Wayland và cổng đồ họa cần thiết
  services.xserver.enable = false; # Tùy chọn nếu bạn muốn dùng thuần Wayland

# Biến môi trường hệ thống bắt buộc giúp các app nền Chromium nhận diện tốt Wayland trên NixOS:
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";             # Bật Wayland cho các app Chromium/Electron chuẩn của Nixpkgs
  };

  nixpkgs.config.allowUnfree = true;

  virtualisation.waydroid.enable = true;
  # Newer kernel versions may need
  virtualisation.waydroid.package = pkgs.waydroid-nftables;

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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}