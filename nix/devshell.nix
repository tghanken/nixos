{perSystem, ...}:
perSystem.devshell.mkShell {
  imports = [(perSystem.devshell.importTOML ./devshells/base.toml)];
}
