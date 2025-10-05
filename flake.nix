{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };
  outputs =
    { self, nixpkgs }:
    {
      packages = builtins.mapAttrs (
        system: pkgs: with pkgs; {
          vterm-compile = writeShellApplication {
            name = "vterm-compile";
            text = ''
              ~/.emacs.d/bin/doom env
              emacs -f vterm-module-compile
              echo "Done. Please regenerate doom env by running ~/.emacs.d/bin/doom env"
            '';
            runtimeInputs = [
              # emacs -- NOTE HACK: from my global env
              libtool
              cmake
              libvterm-neovim
            ];
          };
        }
      ) nixpkgs.legacyPackages;
      devShells = builtins.mapAttrs (
        system: pkgs: with pkgs; {
          default = mkShell {
            buildInputs = [
              ripgrep
              findutils
              fd
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
