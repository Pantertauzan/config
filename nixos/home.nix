{lib, config, pkgs, ... }:
{  
home.username = "nanon";
home.homeDirectory = "/home/nanon";
home.stateVersion = "26.05";

home.activation = {
  createDefaultDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p $HOME/{Documents,Downloads,Pictures,Projects}
  '';
};


programs.home-manager.enable = true;

home.pointerCursor = {
    	name = "Vanilla-DMZ";
    	package = pkgs.vanilla-dmz;
    	size = 24;
    	gtk.enable = true;
};

home.sessionVariables = {
    	XCURSOR_THEME = "Vanilla-DMZ";
    	XCURSOR_SIZE = "24";
};

home.packages = with pkgs; [

];
}
