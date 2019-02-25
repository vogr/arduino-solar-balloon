{stdenv}:

stdenv.mkDerivation rec {
  name = "AdafruitSensor-${version}";
  version = "1.0.0";

  src = builtins.fetchGit {
    url = "https://github.com/adafruit/Adafruit_Sensor.git";
    ref = "master";
    rev = "a78507261d6854ff5514604a4b17183758e8c146";
  };
  installPhase = ''
    mkdir -p $out/lib && \
    cp -r . $out/lib
  '';
}
