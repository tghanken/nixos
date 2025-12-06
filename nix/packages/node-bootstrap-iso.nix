{
  inputs,
  flake,
  ...
}:
inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  format = "iso";
  modules = [
    flake.nixosModules.bootstrap
    flake.nixosModules.kernel
    flake.modules.users.tghanken
    {
      networking.hostId = "12345678";
      networking.networkmanager.wifi.backend = "iwd";
      networking.wireless.iwd.enable = true;
      boot.supportedFilesystems = ["zfs"];
    }
  ];
}
