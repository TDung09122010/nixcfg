{
  config,
  pkgs,
  inputs,
  ...
}:
{

  imports = [
    inputs.noctalia.homeModules.default
    inputs.umbriel.homeModules.default
  ];

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
  };

  programs.umbriel = {
    enable = true;
    settings = {
      general.autostart = [ "noctalia" ];

      layout.gap = 5;

      input.keyboard.layout = "us";

      keybinds = {
        "Mod+Return" = "spawn:kitty";
        "Mod+Q" = "window-close";
        "Mod+R" = "spawn:noctalia msg panel-toggle launcher";
        "Mod+F" = "window-toggle-fullscreen";
      };
    };
  };

  programs.noctalia = {
    enable = true;

    settings = { # This may also be a string or path to a .toml file.
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
    };
  };

  home.packages = with pkgs; [
    ];

  # Phiên bản Home Manager tương thích
  home.stateVersion = "26.05"; # Thay bằng phiên bản NixOS bạn đang dùng

  # Tự động cập nhật Home Manager cùng hệ thống
  programs.home-manager.enable = true;
}