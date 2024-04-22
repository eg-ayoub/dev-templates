{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };

  outputs = { self, nixpkgs, nixpkgs-python, ... }:
  let

    system = "x86_64-linux"; 

    helm_pkgs = import (builtins.fetchTarball {
      # HELM 3.12.1
      # https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=kubernetes-helm
      url = "https://github.com/NixOS/nixpkgs/archive/5a8650469a9f8a1958ff9373bd27fb8e54c4365d.tar.gz";
      sha256 = "0qij2z6fxlmy4y0zaa3hbza1r2pnyp48pwvfvba614mb8x233ywq";
    }) { inherit system; };
    helm = helm_pkgs.kubernetes-helm;

    pkgs = import nixpkgs { inherit system; };
  in
  {

    devShell.${system} = pkgs.mkShell {
    
      packages = [ 
        nixpkgs-python.packages.${system}."2.7"
        nixpkgs-python.packages.${system}."3.6"
        (nixpkgs-python.packages.${system}."3.10".withPackages (ps: with ps; [ tox ]))
        helm
      ];

    };

  };
}
