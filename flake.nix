{
  # inputs = { nixpkgs.url = "github:Nixos/nixpkgs"; };
  inputs = { nixpkgs.url = "nixpkgs-unstable"; };
  outputs = { self, nixpkgs }: {
    devShells = builtins.mapAttrs (system: pkgs:
      let
        # emacs-grammars = (pkgs.callPackage
        #   "${nixpkgs}/pkgs/applications/editors/emacs/elisp-packages/manual-packages/treesit-grammars/default.nix" {
        #     inherit pkgs;
        #     inherit (pkgs) lib;
        #   }).with-grammars
        #   (grammars: with grammars; [ tree-sitter-tsx tree-sitter-typescript ]);
      in with pkgs;
      let
        # NOTE: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/data/fonts/nerdfonts/shas.nix
        nerd-fonts-symbol =
          nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; };
        fonts = [
          # sarasa-gothic
          nerd-fonts-symbol
        ];

      in {
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
          ] ++ fonts
            # NOTE: for compiling vterm
            ++ [
              libtool
              cmake
            ]
            # NOTE: for doom doctor checking font requirements
            ++ [ fontconfig ];

          # NOTE: remember to delete the fonts hardlinked when it is updated to replace it by the shellHook.
          shellHook = let font-dest = "~/Library/fonts/nix";
          in ''
            if [ ! -d ${font-dest} ]; then
              mkdir -p ${font-dest}
            fi
            if [ ! -d ${font-dest}/NerdFonts ]; then
              cp -ral ${nerd-fonts-symbol}/share/fonts/truetype/NerdFonts ${font-dest}
            fi
            # ln -s {emacs-grammars}/lib ~/.emacs.d/.local/cache/tree-sitter
            # echo ${tree-sitter-grammars.tree-sitter-typescript}
            # echo ${tree-sitter-grammars.tree-sitter-tsx}
          '';
        };
      }) nixpkgs.legacyPackages;
  };
}
