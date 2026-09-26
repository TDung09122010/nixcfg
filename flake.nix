{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    preservation.url = "github:nix-community/preservation";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Giữ chung một phiên bản nixpkgs
    };

    umbriel = {
      type = "git";
      url = "https://github.com/noctalia-dev/umbriel";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    custom-packages.url = "github:Rishabh5321/custom-packages-flake";
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs"; # this line is optional, prevents downloading two versions of nixpkgs but disables cache
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, preservation, home-manager, noctalia, umbriel, custom-packages, nix-cachyos-kernel, noctalia-greeter, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        disko.nixosModules.disko
        noctalia-greeter.nixosModules.default
        umbriel.nixosModules.default
        preservation.nixosModules.default
        home-manager.nixosModules.home-manager
        ./configuration.nix
        ./preservation.nix
        ./disko.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; }; #If you want access to inputs in your home.nix
            users.tdung0912 = ./home.nix; # replace <USERNAME> with your actual username
          };
        }
      ];
    };
  };
}