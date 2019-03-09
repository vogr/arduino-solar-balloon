{stdenv}:

stdenv.mkDerivation rec {
  name = "Vilius-MQ135-${version}";
  version = "1.0.0";

  src = builtins.fetchGit {
    url = "https://github.com/ViliusKraujutis/MQ135.git";
    ref = "master";
    rev = "fb1bed6fff7418777930cdf8173bb6fb5c7e70a9";
  };
  installPhase = ''
    mkdir -p $out/lib && \
    cp -r . $out/lib && \
    sed -i.bak 's/\(#define RZERO\).*/\1 85.5/g; s/\(#define ATMOCO2\).*/\1 410.0/g' $out/lib/MQ135.h && \
    rm $out/lib/MQ135.h.bak
  '';
}
