{
  lib,
  mold,
  myLib,
  rustPlatform,
}:
let
  inherit (myLib) filters;
  inherit (myLib.build) cleanSourcePipe;
  cargoToml = ../Cargo.toml |> builtins.readFile |> builtins.fromTOML;
in
rustPlatform.buildRustPackage {
  inherit (cargoToml.package) version;
  RUSTFLAGS = "-Clink-arg=-fuse-ld=mold";
  cargoLock.lockFile = ../Cargo.lock;
  meta = {
    description = "A tool for converting plain text into Unicode-escaped text";
    license = lib.licenses.mit;
    mainProgram = "unicodeescape";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
  nativeBuildInputs = [
    mold
  ];
  pname = cargoToml.package.name;
  src = cleanSourcePipe ../. [
    filters.isNotNixDirectory
    filters.isNotNixFiles
  ];
}
