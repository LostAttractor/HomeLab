{
  description = "ChaosAttractor's HomeLab Infra Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    router.url = "github:lostattractor/router";
    metrics.url = "github:lostattractor/metrics";
    nas.url = "github:lostattractor/nas";
    kubernetes.url = "github:lostattractor/kubernetes";
    hydra.url = "github:lostattractor/hydra";
  };

  outputs =
    {
      self,
      nixpkgs,
      deploy-rs,
      ...
    }@inputs:
    rec {
      nixosConfigurations = nixpkgs.lib.mergeAttrsList (
        map (flake: flake.nixosConfigurations) (
          with inputs;
          [
            router
            metrics
            nas
            kubernetes
            hydra
          ]
        )
      );

      # Deploy-RS Configuration
      deploy = {
        sshUser = "root";
        magicRollback = false;

        nodes = nixpkgs.lib.mergeAttrsList (
          map (flake: flake.deploy.nodes) (
            with inputs;
            [
              router
              metrics
              nas
              kubernetes
              hydra
            ]
          )
        );
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (_system: deployLib: deployLib.deployChecks deploy) deploy-rs.lib;

      hydraJobs =
        with nixpkgs.lib;
        let
          recursiveMerge =
            attrList:
            let
              f =
                attrPath:
                zipAttrsWith (
                  n: values:
                  if tail values == [ ] then
                    head values
                  else if all isList values then
                    unique (concatLists values)
                  else if all isAttrs values && !isDerivation values then
                    f (attrPath ++ [ n ]) values
                  else
                    last values
                );
            in
            f [ ] attrList;
        in
        recursiveMerge (
          map (flake: flake.hydraJobs) (
            with inputs;
            [
              router
              metrics
              nas
              kubernetes
              hydra
            ]
          )
        );
    };
}
