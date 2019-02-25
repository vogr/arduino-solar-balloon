{ pkgs ? import <nixpkgs> {} }:
let
  ballon-solaire = (import ./default.nix {}).ballon-solaire;
in
  pkgs.buildEnv {
    name = "shell";
    paths = [ ballon-solaire ];
  }
