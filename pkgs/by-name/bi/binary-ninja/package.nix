{
  dbus,
  fontconfig,
  freetype,
  kdePackages,
  lib,
  libgcc,
  libGL,
  libxkbcommon,
  lldb_16,
  makeWrapper,
  stdenv,
  fetchzip,
  xorg,
}:

let
  libs = lib.makeLibraryPath [
    kdePackages.qtbase
    lldb_16
    libgcc
    libGL
    xorg.libX11
    libxkbcommon
    freetype
    dbus
  ];
in
stdenv.mkDerivation {
  pname = "binary-ninja";
  version = "4.2.6455";

  src = fetchzip {
    url = "https://web.archive.org/web/20241123130419/https://cdn.binary.ninja/installers/binaryninja_free_linux.zip";
    hash = "sha256-reuDakafnRvJDJ2UcPnFI+a8opURFfm+g4eN26YQ/JI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./binaryninja $out/bin
    wrapProgram $out/bin/binaryninja --prefix LD_LIBRARY_PATH ":" ${libs}

    runHook postInstall
  '';

  meta = {
    description = "Interactive decompiler, disassembler, debugger, and binary analysis platform";
    homepage = "https://binary.ninja/free/";
    changelog = "https://binary.ninja/changelog/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ scoder12 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "binaryninja";
  };
}
