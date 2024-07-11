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

  pico-extras = pkgs.fetchFromGitHub {
    fetchSubmodules = true;
    owner = "raspberrypi";
    repo = "pico-extras";
    rev = "sdk-${pico-sdk-version}";
    hash = "sha256-mnK8BhtqTOaFetk3H7HE7Z99wBrojulQd5m41UFJrLI=";
  };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    gcc-arm-embedded
    pico-sdk
    picotool
    python3
  ];

  shellHook = ''
    export PICO_SDK_PATH=${pico-sdk}/lib/pico-sdk/
    export PICO_EXTRAS_PATH=${pico-extras}/
    export ARM_NONE_EABI_INCLUDE_PATH=${pkgs.gcc-arm-embedded}/arm-none-eabi/include
  '';
}
