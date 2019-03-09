{ pkgs ? import <nixpkgs> {} }:
let
  libs = rec {
    directio = pkgs.callPackage ./libs/DirectIO {};
    bmp280 = pkgs.callPackage ./libs/AdafruitBMP280 {};
    adafruit-sensor = pkgs.callPackage ./libs/AdafruitSensor {};
    mq135 = pkgs.callPackage ./libs/ViliusMQ135 {} ;
    mq135-calibrated = pkgs.stdenv.mkDerivation {
      name = "MQ135-Calibrated";
      src = mq135;
      buildPhase = ''
        substituteInPlace lib/MQ135.h \
          --replace "#define RZERO 76.63" "#define RZERO 1800.0" \
          --replace "#define ATMOCO2 397.13" "#define ATMOCO2 410.90"
      '';
      installPhase = ''
        cp -r . $out
      '';
    };
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
    -v \
    -P/dev/ttyACM0 \
    -b115200 \
    -D \
    -Uflash:w:${ballon-solaire}/main.cpp.hex:i
  '';
  deployShell = pkgs.mkShell {
    name = "deploy-shell";
    buildInputs = [ deployScript ];
  };
} // libs
