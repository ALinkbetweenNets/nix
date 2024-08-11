{ lib, stdenvNoCC, fetchFromGitHub, jdupes, }:
stdenvNoCC.mkDerivation {
  pname = "candy-icon-theme";
  version = "unstable-2021-07-21";
  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "f78e4e763afb4ff2cc78ae7eb6a70d2235445d01";
    hash = "sha256-BwcuIu8dDSjhIGHGdGDBXI26EP2NIRXg924kRAqd2HI=";
  };
  nativeBuildInputs = [ jdupes ];
  dontDropIconThemeCache = true;
  dontPatchELF = true;
  dontRewriteSymlinks = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/Candy
    cp -a * $out/share/icons/Candy/
    jdupes --quiet --link-soft --recurse $out/share
    runHook postInstall
  '';
  meta = with lib; {
    description = "Candy Icon theme";
    homepage = "https://github.com/m4thewz/dracula-icons";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ link ];
  };
}
