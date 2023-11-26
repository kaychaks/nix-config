{ root, boot, swap }: 

{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/{root}";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/{boot}";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/{swap}"; }
  ]; 
}
