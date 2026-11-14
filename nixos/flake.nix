{
inputs = {
    	nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    	mangowm = {
      		url = "github:mangowm/mango";
      		inputs.nixpkgs.follows = "nixpkgs";
    	};
	home-manager = {
      		url = "github:nix-community/home-manager";
      		inputs.nixpkgs.follows = "nixpkgs";
    	};
};

outputs = { self, nixpkgs, mangowm, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        mangowm.nixosModules.mango
	home-manager.nixosModules.home-manager
	{
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nanon = import ./home.nix;
        }
      ];
    };
  };
}
