{
  lib,
  config,
  builderSpecs,
  ...
}:
let
  modCfg = config.features.nix;
  cfg = modCfg.builders;
  hostName = config.networking.hostName;

  # Build machines = all builderSpecs entries except ourselves
  remoteBuilders = lib.filterAttrs (name: _: name != hostName) builderSpecs;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    nix = {
      distributedBuilds = true;
      buildMachines = mapAttrsToList (hostName: spec: {
        protocol = "ssh-ng";
        sshUser = "colmena";
        inherit hostName;
        inherit (cfg) sshKey;
        inherit (spec)
          system
          maxJobs
          speedFactor
          supportedFeatures
          ;
      }) remoteBuilders;

      # Let remote builders pull from caches directly
      settings.builders-use-substitutes = true;
    };

    # Trust builder hosts on first connection (safe on Tailscale)
    programs.ssh.extraConfig = concatStringsSep "\n" (
      mapAttrsToList (name: _: ''
        Host ${name}
          StrictHostKeyChecking accept-new
      '') remoteBuilders
    );
  };
}
