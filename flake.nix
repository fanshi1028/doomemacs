{
  inputs = {
    nixpkgs.url = "nixpkgs-unstable";
    my-aider.url = "my-aider";
    my-wg-quick.url = "my-wg-quick";
  };
  outputs = { self, nixpkgs, my-aider, my-wg-quick }: {
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
        fonts = [
          # sarasa-gothic
          nerdfonts.nerd-fonts-symbols-only
        ];
        aider = my-aider.packages.${system}.default;
        wg-quick = my-wg-quick.packages.${system}.default;
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
            ffmpegthumbnailer
            mediainfo
            # NOTE: for jinx-mod.dylib compilation
            pkg-config
            (enchant.override {
              aspell =
                # NOTE: https://github.com/NixOS/nixpkgs/issues/1000#issuecomment-491513497
                aspellWithDicts (ds: with ds; [ en ]);
            })
            wordnet
            aider
            wg-quick
          ]
          # ++ fonts
          # NOTE: for compiling VTERM
            ++ [
              libtool
              cmake
            ]
            # NOTE: for doom doctor checking font requirements
            ++ [ fontconfig ];

          # NOTE: remember to delete the fontd hard-linked when it is updated to replace it by the shellHook.
          # shellHook = let font-dest = "~/Library/fonts/nix";
          # in ''
          #   if [ ! -d ${font-dest} ]; then
          #     mkdir -p ${font-dest}
          #   fi
          #   if [ ! -d ${font-dest}/NerdFonts ]; then
          #     cp -ral ${nerd-fonts-symbol}/share/fonts/truetype/NerdFonts ${font-dest}
          #   fi
          #   # ln -s {emacs-grammars}/lib ~/.emacs.d/.local/cache/tree-sitter
          #   # echo ${tree-sitter-grammars.tree-sitter-typescript}
          #   # echo ${tree-sitter-grammars.tree-sitter-tsx}
          # '';
        };
      }) nixpkgs.legacyPackages;
  };
}
