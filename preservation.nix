{
  preservation = {
    enable = true;

    preserveAt."/persistent" = {
      directories = [
        "/etc/nixos"
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"

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
          how = "symlink";
          configureParent = true;
        } 
      ];

      users.tdung0912 = {
        directories = [
          ".mozilla"
        ];

        files = [

        ];
      }
    };
  };
}