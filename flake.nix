{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, nixpkgs, devshell, flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        devshell.flakeModule
      ];

      systems = [
        "x86_64-linux"
      ];

      perSystem = { pkgs, system, ... }: {
        devshells.default = {
          env = [
            { name = "LD_LIBRARY_PATH"; value = "${pkgs.stdenv.cc.cc.lib}/lib"; }
            { name = "PATH"; prefix = "~/.cargo/bin:~/.rustup/toolchains/**/bin"; }
            { name = "LIBCLANG_PATH"; value = pkgs.lib.makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ]; }
          ];

          packages = with pkgs; [
            rustup
            clang
          ];

        };
      };
    };
}
