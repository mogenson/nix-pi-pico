{ pkgs ? import <nixpkgs> { } }:
let

  pico-sdk-version = "1.5.1";

  pico-sdk = pkgs.pico-sdk.overrideAttrs (old: {
    version = pico-sdk-version;
    src = pkgs.fetchFromGitHub {
      fetchSubmodules = true;
      owner = "raspberrypi";
      repo = "pico-sdk";
      rev = pico-sdk-version;
      hash = "sha256-GY5jjJzaENL3ftuU5KpEZAmEZgyFRtLwGVg3W1e/4Ho=";
    };
  });

  pico-async = pkgs.stdenvNoCC.mkDerivation {
    name = "pico-async";
    src = pkgs.fetchFromGitHub {
      owner = "FunMiles";
      repo = "PicoAsync";
      rev = "c765be82e7be09cee16fd854bb4efee7044e707a";
      hash = "sha256-ZVEXGdXxqvD5FZ4o2hcqRqhvn4Q2p578w0fjLFEFang=";
    };
    patches = ./pico_async_include_vector.patch;
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -a * $out/
      runHook postInstall
    '';
  };

  pico-extras = pkgs.stdenvNoCC.mkDerivation {
    name = "pico-extras";
    src = pkgs.fetchFromGitHub {
      fetchSubmodules = true;
      owner = "raspberrypi";
      repo = "pico-extras";
      rev = "sdk-${pico-sdk-version}";
      hash = "sha256-mnK8BhtqTOaFetk3H7HE7Z99wBrojulQd5m41UFJrLI=";
    };
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -a * $out/
      runHook postInstall
    '';
  };

in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    gcc-arm-embedded
    pico-async
    pico-extras
    pico-sdk
    picotool
    python3
  ];

  shellHook = ''
    export ARM_NONE_EABI_INCLUDE_PATH=${pkgs.gcc-arm-embedded}/arm-none-eabi/include
    export CMAKE_VERSION=${pkgs.cmake.version}
    export PICO_ASYNC_PATH=${pico-async}
    export PICO_EXTRAS_PATH=${pico-extras}/
    export PICO_SDK_PATH=${pico-sdk}/lib/pico-sdk/
  '';
}
