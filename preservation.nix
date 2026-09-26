{
  preservation = {
    enable = true;

    preserveAt."/persistent" = {
      directories = [
        "/etc/nixos"
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
        "/var/lib/power-profiles-daemon"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/rfkill"
        "/var/lib/systemd/timers"

        {
          directory = "/var/log";
          configureParent = true;
        }

        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
        { file = "/var/lib/systemd/random-seed"; how = "symlink"; inInitrd = true; configureParent = true; }
      ];

      users.tdung0912 = {
        directories = [
          ".config/mozilla"
          ".config/thorium"
        ];

        files = [
          ".bash_history"
        ];
      };
    };
  };

  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
  systemd.tmpfiles.settings.preservation = {
    "/home/tdung0912/.config".d = { user = "tdung0912"; group = "users"; mode = "0755"; };
    "/home/tdung0912/.local".d = { user = "tdung0912"; group = "users"; mode = "0755"; };
    "/home/tdung0912/.local/share".d = { user = "tdung0912"; group = "users"; mode = "0755"; };
    "/home/tdung0912/.local/state".d = { user = "tdung0912"; group = "users"; mode = "0755"; };
  };
}