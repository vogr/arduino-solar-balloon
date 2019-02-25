{stdenv}:

stdenv.mkDerivation rec {
  name = "AdafruitBMP280-${version}";
  version = "1.0.0";

  src = builtins.fetchGit {
    url = "https://github.com/adafruit/Adafruit_BMP280_Library.git";
    ref = "master";
    rev = "d20a271b3c166145b50fdf2dc382324ab8e37b55";
  };
  installPhase = ''
    mkdir -p $out/BMP280 && \
    cp -r . $out/BMP280
  '';
}
