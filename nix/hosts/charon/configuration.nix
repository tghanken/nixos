{
  inputs,
  flake,
  modulesPath,
  ...
}: {
  imports = [
    # QEMU Guest for virtualized host
    (modulesPath + "/profiles/qemu-guest.nix")

    # Standard nixos-anywhere modules
    inputs.disko.nixosModules.disko
    inputs.nixos-facter-modules.nixosModules.facter
    {
      config.facter.reportPath =
        if builtins.pathExists ./facter.json
        then ./facter.json
        else throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
    }

    # Additional NixOs modules from this flake
    flake.nixosModules.host-shared
  ];

  # Required for nixos-anywhere
  disko.devices = import ./disk-config.nix;
  networking.hostId = "a39c3d72"; # Generate using `head -c 8 /etc/machine-id`

  # Setup users
  users.users.me.isNormalUser = true;

  system.stateVersion = "25.05"; # initial nixos state
}
