{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "precomp";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "schnaader";
    repo = "precomp-cpp";
    rev = "v${version}";
    hash = "sha256-UNU0UuQXivAjZ2XpFreyUuHX8+tjdDOpjSro+3XHma8=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace contrib/liblzma/rangecoder/range_encoder.h \
      --replace-fail '#include "price.h"' $'#include "price.h"\n#include <assert.h>'
  '';

  cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security -Wno-error=unused-result";

  installPhase = ''
    runHook preInstall
    install -Dm755 precomp $out/bin/precomp
    runHook postInstall
  '';

  meta = {
    description = "Command-line precompressor to achieve better compression";
    homepage = "https://github.com/schnaader/precomp-cpp";
    license = lib.licenses.asl20;
    mainProgram = "precomp";
    platforms = lib.platforms.unix;
  };
}
