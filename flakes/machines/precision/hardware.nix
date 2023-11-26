{ config, lib, pkgs, modulesPath, ... }:

let
  make_mounts = import ./../../functions/make_mounts.nix;
  root = "";
  boot = "";
  swap = "";
  mounts = make_mounts {inherit root boot swap;};
in

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  config = {

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    # from Hoverbear-consulting/flake
    boot.kernel.sysctl = {
      # TCP Fast Open (TFO)
      "net.ipv4.tcp_fastopen" = 3;
    };
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.loader.timeout = 30;
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.editor = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.binfmt.emulatedSystems = (if pkgs.stdenv.isx86_64 then [
      "aarch64-linux"
    ] else if pkgs.stdenv.isAarch64 then [
      "x86_64-linux"
    ] else [ ]);
    boot.initrd.systemd.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.loader.efi.efiSysMountPoint = "/boot";

    fileSystems = mounts.fileSystems;

    swapDevices = mounts.swapDevices;


    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.cpuFreqGovernor = "ondemand";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    networking.networkmanager.enable = true;
    networking.wireless.enable = false; # For Network Manager
    networking.useDHCP = lib.mkDefault true;

    security.rtkit.enable = true;
    sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    hardware.pulseaudio.enable = false;

    hardware.bluetooth.enable = true;
  };
}
