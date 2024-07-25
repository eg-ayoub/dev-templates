{
  description = "Development environment for mk8s/dev/128";

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
      url = "https://github.com/NixOS/nixpkgs/archive/336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3.tar.gz";
      sha256 = "0v8vnmgw7cifsp5irib1wkc0bpxzqcarlv8mdybk6dck5m7p10lr";
    }) { inherit system; };

    golangci_pkgs = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/9957cd48326fe8dbd52fdc50dd2502307f188b0d.tar.gz";
      sha256 = "1l2hq1n1jl2l64fdcpq3jrfphaz10sd1cpsax3xdya0xgsncgcsi";
    }) { inherit system; };

    pkgs = import nixpkgs { inherit system; config.allowUnfree = true;config.permittedInsecurePackages = ["python-2.7.18.8"];};

    opm = pkgs.callPackage ./opm.nix {};
  in
  {

    devShell.${system} = pkgs.mkShell {
    
      packages = with pkgs; [
        acl
        curl
        enchant
        gawk
        libgcc
        git
        libassuan
        btrfs-progs
        lvm2
        gdbm
        gpgme
        ncurses5
        libxml2
        xmlsec
        libffi
        xz
        openssl
        bzip2
        readline
        sqlite
        gnumake
        # nodejs
        pkg-config
        plantuml
        # shellcheck
        tk
        zlib
        python
        crane
        gcrane
        skopeo
        kubernetes-helm
        vagrant
        jq
        isomd5sum
        cdrkit
      ] ++ [
        (py36_pkgs.python36.withPackages (python36-pkgs: [
          python36-pkgs.virtualenv
          python36-pkgs.pip
        ]))
        (python312Full.withPackages (python312-pkgs: [
          python312-pkgs.tox
          python312-pkgs.virtualenv
          python312-pkgs.pip
        ]))
        go_pkgs.go_1_20
        golangci_pkgs.golangci-lint
        # opm downloaded from github
        opm
      ]; 
    };

  };
}

