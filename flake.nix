{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, pre-commit-hooks, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      preCommitCheck = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks.clang-format.enable = true;
        hooks.keep-sorted.enable = true;
        hooks.nixfmt.enable = true;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # Run compote with: uvx --python 3.14 --from idf-component-manager compote
          uv
        ];
        shellHook = preCommitCheck.shellHook;
      };
    };
}
