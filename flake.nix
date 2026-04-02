{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
    opencode-flake.url = "github:dmitryryabkov/opencode/2d3916b95a7452a7bf4ca266320e0aa5dcc701ab";
    opencode-flake.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      opencode-flake,
    }:
    {
      devShells = builtins.mapAttrs (
        system: pkgs: with pkgs; {
          jinx-compile = mkShell {
            buildInputs = [ enchant ];
            nativeBuildInputs = [ pkg-config ];
          };
          vterm-compile = mkShell {
            buildInputs = [ libvterm-neovim ];
            nativeBuildInputs = [
              cmake
              libtool
            ];
          };
          default = mkShell {
            buildInputs = [
              opencode-flake.packages."${system}".default
              gcc
              ripgrep
              findutils
              fd
              libvterm-neovim
              sqlite
              ledger
              gnupg
              pass
              coreutils
              pandoc
              hledger
              djvulibre
              ffmpegthumbnailer
              mediainfo
              emacs-lsp-booster
              imagemagick
              nixfmt-rfc-style
              vips
              epub-thumbnailer
              poppler-utils
              tree
              fd
              pngpaste
              (
                let
                  pname = "pi-acp";
                  version = "0.0.23";
                in
                buildNpmPackage {
                  inherit pname version;
                  src = fetchFromGitHub {
                    owner = "svkozak";
                    repo = pname;
                    rev = "v${version}";
                    sha256 = "sha256-vTNzyq+mmvme1Zq6Kf6bo3wbaSt0k9A2YZPIPssDz74=";
                  };
                  npmDepsHash = "sha256-xY+mfaF1UzFOOd4/+IN7TqnD8Ji1nj9DXdzbUh9/CNI=";
                  makeWrapperArgs = [
                    "--prefix PATH : ${lib.makeBinPath [ nixpkgs-unstable.legacyPackages.${system}.pi-coding-agent ]}"
                  ];
                }
              )

            ]
            ++ [
              # NOTE TEMP: https://github.com/NixOS/nixpkgs/pull/496179
              # NOTE: https://github.com/always-further/nono/pull/188
              # nixpkgs-update-nono.url = "github:r-ryantm/nixpkgs/auto-update/nono";
              (nixpkgs-unstable.legacyPackages.${system}.nono.overrideAttrs (
                finalAttrs: prevAttrs: {
                  cargoHash = "sha256-xZgPNfNsA/6qytyxRpFlDARGB9Xik6HiYQtG3nYGTKc=";
                  src = fetchFromGitHub {
                    owner = "always-further";
                    repo = "nono";
                    tag = "v0.22.1";
                    hash = "sha256-/CE4XaJrUFX65z2l848xmDaP31tF17bm9ZCSV+4Cc58=";
                  };
                  version = "v0.22.1";
                  cargoDeps = rustPlatform.fetchCargoVendor {
                    inherit (finalAttrs) pname src version;
                    hash = finalAttrs.cargoHash;
                  };
                  checkFlags = [
                    # TEMP FIXME error: test failed
                    "--skip=env_nono_allow_comma_separated"
                  ];
                }
              ))
            ];
          };
        }
      ) nixpkgs.legacyPackages;
    };
}
