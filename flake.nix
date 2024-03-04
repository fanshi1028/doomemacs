{
  inputs = {
    nixpkgs.url = "nixpkgs-unstable";
    # NOTE: for using gnupg 2.4.0, see below
    old-nixpkgs.url = "github:Nixos/nixpkgs/nixos-23.05";
  };
  outputs = { self, nixpkgs, old-nixpkgs }: {
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
            # NOTE: https://www.reddit.com/r/emacs/comments/137r7j7/gnupg_241_encryption_issues_with_emacs_orgmode/
            # NOTE: https://dev.gnupg.org/T6481
            old-nixpkgs.legacyPackages.${system}.gnupg
            pass
            coreutils
            pandoc
            emacs-lsp-booster
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
