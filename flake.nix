{
  description = "Flutter 3.22.2";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils";
};
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };
        buildToolsVersion = "34.0.0";
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          platformVersions = [ "34" ];
          abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
          buildToolsVersions = [ buildToolsVersion ];
        };
        androidSdk = androidComposition.androidsdk;
      in
      {
        devShell =
          with pkgs; mkShell rec {
            ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
            buildInputs = [
              flutter
              androidSdk # The customized SDK that we've made above
              jdk17
            ];
          };
      });
}
