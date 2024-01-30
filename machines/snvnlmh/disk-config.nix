{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              priority = 1;
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            # luks = {
            #   size = "100%";
            #   content = {
            #     type = "luks";
            #     name = "crypted";
            #     # disable settings.keyFile if you want to use interactive password entry
            #     # passwordFile = "/tmp/luks.key"; # Interactive
            #     settings = {
            #       allowDiscards = true;
            #       #keyFile = "/tmp/secret.key";
            #     };
            #     # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
