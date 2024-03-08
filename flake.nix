{
  description = "Personal configurations";

  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-urils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      systems = [
        # "x86_64-linux"
        # "x86_64-darwin"
        "aarch64-darwin"
      ];
      # Define a function which generates an attribute by calling a provided function,
      # with each system in the systems list.
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Build our custom packages
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Format nix files, via `nix fmt`.
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
      # Overlay additionnal packages and modifications.
      overlays = import ./overlays { inherit inputs; };

      # Standalone home-manager configurations.
      # Available via `home-manager --fake .#matousdzivjak`
      homeConfigurations."matousdzivjak" = home-manager.lib.homeManagerConfiguration {
        # home-manager requires 'pkgs' instance
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        # Without this, our overlays won't be available.
        extraSpecialArgs = { inherit inputs outputs; };
        # We specify the home-manager configuration module here.
        modules = [
          ./users/matousdzivjak.nix
        ];
      };
    };
}
