{
  inputs,
  flake,
  pkgs,
  ...
}: {
  imports = [
    # Standard nixos-anywhere modules
    inputs.disko.nixosModules.disko
    inputs.nixos-facter-modules.nixosModules.facter
    {
      config.facter.reportPath =
        if builtins.pathExists ./facter.json
        then ./facter.json
        else throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
    }

    # Nixos hardware additions
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series

    # Additional NixOs modules from this flake
    flake.nixosModules.host-shared
  ];

  # Required for nixos-anywhere
  disko.devices = import ./disk-config.nix;
  networking.hostName = "pegasus";
  networking.hostId = "8561a55b"; # Generate using `head -c 8 /etc/machine-id`

  # Fixes broken zfs package. See https://github.com/NixOS/nixos-hardware/issues/1675
  boot.kernelPackages = pkgs.linuxPackages_6_17;

  # Setup users
  users.users.tghanken = {
    isNormalUser = true;
    description = "Taylor Hanken";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    # Create with mkpasswd -m sha-512
    hashedPassword = "$6$aVX13r8lw5yvxWJZ$TrXrqKub2dJArKGyZ75l5AQC.yIh8ysgigZniYT.ZkvQRvjgb45oFNUnFIUd5xTfE0JXzFzPHwMWdJcdth9Tj1";
  };

  system.stateVersion = "25.11"; # initial nixos state
}
