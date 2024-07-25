{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "opm";
  src = pkgs.fetchurl {
    url="https://github.com/operator-framework/operator-registry/releases/download/v1.45.0/linux-amd64-opm";
    sha256="79922aea113916b6a488bdfcad4521fa836d5b393a34d11488fa4e68e63f68f2";
  };
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/bin
    install -D $src $out/bin/opm
    chmod +x $out/bin/opm
  '';
}
