{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    preservation.url = "github:nix-community/preservation";

    niri.url = "github:sodiboo/niri-flake";
    inir.url = "github:snowarch/inir";
  };

  outputs = { self, nixpkgs, disko, preservation, niri, inir, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        disko.nixosModules.disko
        preservation.nixosModules.default
        niri.nixosModules.niri
        inir.nixosModules.inir
        ./configuration.nix
        ./preservation.nix
        ./disko.nix
      ];
    };
  };
}