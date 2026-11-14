{ config, pkgs, ... }:
{  
home.username = "nanon";
home.homeDirectory = "/home/nanon";
home.stateVersion = "26.05";

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
