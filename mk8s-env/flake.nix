{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let

    system = "x86_64-linux"; 

    py36_pkgs = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/407f8825b321617a38b86a4d9be11fd76d513da2.tar.gz";
      sha256 = "1lpdc7lhrb5dynkmwsn77cw2bxj7ar7ph2lxmy7bnp52rxdz5yz2";
    }) { inherit system; };
    
    go_pkgs = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/7a339d87931bba829f68e94621536cad9132971a.tar.gz";
      sha256 = "1w4zyrdq7zjrq2g3m7bhnf80ma988g87m7912n956md8fn3ybhr4";
    }) { inherit system; };

    pkgs = import nixpkgs { inherit system; config.allowUnfree = true;config.permittedInsecurePackages = ["python-2.7.18.8"];};
  in
  {

    devShell.${system} = pkgs.mkShell {
    
      packages = [
        (py36_pkgs.python36.withPackages (python36-pkgs: [
          python36-pkgs.virtualenv
          python36-pkgs.pip
        ]))
        (pkgs.python312Full.withPackages (python312-pkgs: [
          python312-pkgs.tox
          python312-pkgs.virtualenv
          python312-pkgs.pip
        ]))
        pkgs.python
        pkgs.crane
        pkgs.gcrane
        pkgs.skopeo
        pkgs.kubernetes-helm
        pkgs.vagrant
        pkgs.jq
        pkgs.isomd5sum
        pkgs.cdrkit
        go_pkgs.go_1_19
      ];

    };

  };
}

