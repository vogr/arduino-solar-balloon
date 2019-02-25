{stdenv}:

stdenv.mkDerivation rec {
  name = "Arduino-DirectIO-${version}";
  version = "1.0.0";

  src = builtins.fetchGit {
    url = "https://github.com/mmarchetti/DirectIO.git";
    ref = "master";
    rev = "9d7176d2f8bb5015db2457b2e502e49fe999f40b";
  };
  installPhase = ''
    mkdir -p $out/DirectIO && \
    cp -r . $out/DirectIO
  '';
}
