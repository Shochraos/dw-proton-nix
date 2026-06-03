{ lib
, stdenv
, fetchurl
, dwProtonVersions
}:

stdenv.mkDerivation rec {
  version = "${dwProtonVersions.base}-${dwProtonVersions.release}";

  archiveName = "dwproton-${version}-x86_64";
  protonDisplayName = "DW-Proton-${version}";

  src = fetchurl {
    url = "https://dawn.wine/dawn-winery/dwproton/releases/download/dwproton-${version}/${archiveName}.tar.xz";
    inherit (dwProtonVersions) hash;
  };

  postPatch = ''
    substituteInPlace "compatibilitytool.vdf" \
      --replace-fail "${archiveName}" "${protonDisplayName}"
  '';

  installPhase = ''
    mkdir -p $out/share/steam/compatibilitytools.d/dw-proton
    mv * $out/share/steam/compatibilitytools.d/dw-proton/
  '';

  meta = with lib; {
    description = "Dawn Winery Proton build";
    homepage = "https://dawn.wine/dawn-winery/dwproton";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ shochraos ];
  };
}