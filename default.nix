{ lib
, stdenv
, fetchurl
, zstd
, dwProtonVersions
}:

stdenv.mkDerivation {
  name = "dw-proton";
  version = "${dwProtonVersions.base}-${dwProtonVersions.release}";

  src = fetchurl {
    url = "https://dawn.wine/dawn-winery/dwproton/releases/download/v${dwProtonVersions.base}-${dwProtonVersions.release}/dwproton-${dwProtonVersions.base}-${dwProtonVersions.release}.tar.zst";
    inherit (dwProtonVersions) hash;
  };

  nativeBuildInputs = [ zstd ];

  installPhase = ''
    tar -I zstd -xf $src
    mkdir -p $out/share/steam/compatibilitytools.d
    mv usr/share/steam/compatibilitytools.d/dw-proton $out/share/steam/compatibilitytools.d/
  '';

  meta = with lib; {
    description = "Dawn Winery Proton build";
    homepage = "https://dawn.wine/dawn-winery/dwproton";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ shochraos ];
  };
}
