{ config, pkgs, ... }: {

  imports = [
      inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    settings = { # This may also be a string or path to a .toml file.
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
      };
    };
  };

  # Phiên bản Home Manager tương thích
  home.stateVersion = "26.05"; # Thay bằng phiên bản NixOS bạn đang dùng
  
  # Tự động cập nhật Home Manager cùng hệ thống
  programs.home-manager.enable = true;
}