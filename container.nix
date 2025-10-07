{pkgs,...}:{
  containers.abc={
    config = {pkgs,...}:{
      services.openssh.enable=true;
      systemd.services.abcdef = {
        enable =true;
      };
    };
  };
}
