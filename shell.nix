{ pkgs ? import <nixpkgs> {} }:
let
  ballon-solaire = (import ./default.nix {}).ballon-solaire;
in
  pkgs.mkShell {
    name = "shell";
    paths = [ ballon-solaire ];
  }
