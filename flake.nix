{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };
  outputs =
    { self, nixpkgs }:
    {
      devShells = builtins.mapAttrs (
        system: pkgs: with pkgs; {
          default = mkShell {
            buildInputs =
              [
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
              ]
              # NOTE: for compiling vterm
              ++ [
                libtool
                cmake
              ];
          };
        }
      ) nixpkgs.legacyPackages;
    };
}
