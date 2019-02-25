{stdenv, callPackage,
arduino-core,
directio, bmp280, adafruit-sensor}:

stdenv.mkDerivation rec {
  name = "ballon-solaire";
  ARDUINO_SDK_PATH = "${arduino-core}";
  arduino-bin = "${arduino-core}/share/arduino/arduino";
  arduino-builder = "${arduino-core}/share/arduino/arduino-builder";
  src=./src;
  buildPhase = ''
    mkdir -p $out && \
    ${arduino-builder} \
    -build-path $out \
    -debug-level 10 \
    -fqbn arduino:avr:uno \
    -hardware ${ARDUINO_SDK_PATH}/share/arduino/hardware/ \
    -libraries ${ARDUINO_SDK_PATH}/share/arduino/libraries/ \
    -libraries ${directio}/ \
    -libraries ${bmp280}/ \
    -libraries ${adafruit-sensor}/ \
    -tools ${ARDUINO_SDK_PATH}/share/arduino/tools/ \
    -tools ${ARDUINO_SDK_PATH}/share/arduino/tools-builder/ \
    -tools ${ARDUINO_SDK_PATH}/share/arduino/hardware/tools/ \
    -verbose \
    -warnings all \
    main.cpp
  '';
  installPhase = ":";
  fixupPhase = ":";
  shellHook = ''
    export PATH="$PATH:${arduino-core}/share/arduino/"
  '';
}
