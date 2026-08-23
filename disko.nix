{
  filesystems."/nix".neededForBoot = true;
  filesystems."/persistent".neededForBoot = true;

  disko.devices.disk.main = {
    device = "/dev/sda";
    type = "disk";

    content.type = "gpt";


    content.partitions = {
      esp = {
        name = "ESP";
        size = "1G";
        type = "EF00";

        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
        };
      };

      swap = {
        size = "8G";

        content = {
          type = "swap";
          resumeDevice = true;
        };
      };

      root = {
        size = "100%";

        content = {
          type = "btrfs";
          extraArgs = [ "-f" "-L" "nixos" ];

          subvolumes = {
            "/root" = {
              mountOptions = [ "subvol=root" "noatime" "compress=zstd" "ssd" "discard" "space_cache=v2" ];
               
              mountpoint = "/";
            };

            "/nix" = {
              mountOptions = [ "subvol=nix" "noatime" "compress=zstd" "ssd" "discard" "space_cache=v2" "nodatacow" "nodatasum" ];
              mountpoint = "/nix";
            };

            "/persistent" = {
              mountOptions = [ "subvol=persistent" "noatime" "compress=zstd" "ssd" "discard" "space_cache=v2" ];
              mountpoint = "/persistent";
            };
          };
        };
      };
    };
  };
}