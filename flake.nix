{
  description = "obliviate: forget your files";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages = rec {
          obliviate = with pkgs.python310Packages; buildPythonApplication {
            name = "obliviate";
            version = builtins.readFile ./version;
            checkInputs = [ pytest ];
            checkPhase = "pytest";
            src = ./.;
          };
          default = obliviate;
        };
        apps = rec {
          obliviate = flake-utils.lib.mkApp { drv = self.packages.${system}.obliviate; };
          default = obliviate;
        };
      }
    );
}
