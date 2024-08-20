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

    pkgs = import nixpkgs { inherit system;config.allowUnfree = true;config.permittedInsecurePackages = ["python-2.7.18.8"]; };
  in
  {

    devShell.${system} = pkgs.mkShell {
    
      packages = with pkgs; [
        python
        pre-commit
        libxcrypt
        acl
        curl
        gawk
        libgcc
        git
        cdrkit
        isomd5sum
        openssl
        bzip2
        readline
        sqlite
        ncurses5
        libxml2
        xmlsec
        libffi
        lzma
        gnumake
        plantuml
        skopeo
        tk
        xz
        zlib
      ] ++ [
        (py36_pkgs.python36.withPackages (python36-pkgs: [
          python36-pkgs.virtualenv
          python36-pkgs.pip
        ]))
        (pkgs.python312.withPackages (python312-pkgs: [
          python312-pkgs.tox
          python312-pkgs.pre-commit-hooks
          python312-pkgs.pip
          python312-pkgs.virtualenv
        ]))
      ];

      shellHook = ''
        export _PYTHON_SYSCONFIGDATA_NAME="_sysconfigdata__linux_x86_64-linux-gnu"
      '';

    };

  };
}
