{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      compiler = "ghc924";
      supported-systems = [ "x86_64-linux" "aarch64-linux" ];
    in
    flake-utils.lib.eachSystem supported-systems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        defaultPackage =
          pkgs.haskell.packages.${compiler}.callPackage ./swarm.nix { };

        devShell =
          pkgs.mkShell {
            buildInputs = with pkgs; [
              asciidoctor
              cabal2nix
              cabal-install
              haskell.compiler.${compiler}
            ];
          };
      });

}
