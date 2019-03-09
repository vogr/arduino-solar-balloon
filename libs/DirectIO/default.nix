{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "Arduino-DirectIO-${version}";
  version = "1.2.0";
  src = fetchurl {
    url = "https://github.com/mmarchetti/DirectIO/archive/v1.2.tar.gz";
    sha256 = "1kqzfjarg8ipq7v53lrj6djzd3prmwjqgar3y42ih4g70hq6i1gq";
  };
  installPhase = ''
    mkdir -p $out/lib && \
    cp -r . $out/lib
  '';
}
