{ pkgs ? import <nixpkgs> {}
}:

let
  drv = pkgs.callPackage ./create_ap.nix {};

  srv = {
    Unit = {
      Description = "Create AP Service";
      After = "network.target";
    };
    Service = {
      Type = "simple";
      ExecStart = "${drv}/bin/create_ap --config ${drv}/etc/create_ap.conf";
      KillSignal = "SIGINT";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = "multi-user.targetin";
    };
  };

in

{
  package = drv;
  service = srv;
}
