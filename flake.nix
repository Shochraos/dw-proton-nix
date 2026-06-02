{
  description = "DW-Proton build";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      dwProtonVersions = builtins.fromJSON (builtins.readFile ./versions.json);
    in {
      packages.${system} = {
        dw-proton = pkgs.callPackage ./default.nix {
          inherit dwProtonVersions;
        };
        default = self.packages.${system}.dw-proton;
      };
    };
}
