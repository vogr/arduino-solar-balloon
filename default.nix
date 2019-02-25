{ pkgs ? import <nixpkgs> {} }:
let
  libs = rec {
    directio = pkgs.callPackage ./libs/DirectIO {};
    bmp280 = pkgs.callPackage ./libs/AdafruitBMP280 {};
    adafruit-sensor = pkgs.callPackage ./libs/AdafruitSensor {};
    mq135 = pkgs.callPackage ./libs/ViliusMQ135 {} ;
  };
in
rec {
  ballon-solaire = pkgs.callPackage ./build.nix libs;
  avrdude = "${pkgs.arduino-core}/share/arduino/hardware/tools/avr/bin/avrdude";
  deployScript = pkgs.writeShellScriptBin "deployScript.sh" ''
    ${avrdude} \
    -C${pkgs.arduino-core}/share/arduino/hardware/tools/avr/etc/avrdude.conf \
    -patmega328p \
    -carduino \
    -v -v -v -v \
    -P/dev/ttyACM0 \
    -b115200 \
    -D \
    -Uflash:w:${ballon-solaire}/main.cpp.hex:i
  '';
  deployEnv = pkgs.stdenv.mkDerivation {
    name = "deploy-env";
    buildInputs = [ deployScript ];
  };
}
