{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };
  outputs =
    { self, nixpkgs }:
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
            ];
          };
        }
      ) nixpkgs.legacyPackages;
    };
}
