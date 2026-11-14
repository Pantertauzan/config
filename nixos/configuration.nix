{ config, lib, pkgs, ... }:
{
#FLAKE
nix.settings.experimental-features = [ "nix-command" "flakes" ];

imports =[
./hardware-configuration.nix
];

#ALLOW UNFREE PROGRAMS
nixpkgs.config.allowUnfree = true;

#BOOT
boot.loader = {
systemd-boot.enable = false;
grub = {
    	enable = true;
    	efiSupport = true;
    	device = "nodev"; 
    	useOSProber = true; 
};  
efi.canTouchEfiVariables = true;
efi.efiSysMountPoint = "/boot";
};


boot.kernelPackages = pkgs.linuxPackages;

#TIME
time.timeZone = "Europe/Chisinau";

#NETWORK
networking.networkmanager.enable = true;

#FONT
fonts = {
  fontDir.enable = true;
  enableDefaultPackages = true;
  packages = with pkgs; [
    corefonts
  ];

  fontconfig = {
    defaultFonts = {
      sansSerif = [ "Arial" "Calibri" ];
      serif     = [ "Times New Roman" "Cambria" ];
      monospace = [ "Courier New" "Consolas" ];
    };
  };
};


#FILE MANAGER
services.gvfs.enable = true;
services.udisks2.enable = true;
services.devmon.enable = true;
xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
};


#PACKAGES
environment.systemPackages = with pkgs; [
	#system
	systemd
	util-linux
	xdg-desktop-portal-wlr
	xdg-desktop-portal
	xdg-desktop-portal-gtk
	#lib
	libnotify	
	#cli
	btop
	cmatrix
	fastfetch
	cava
	#terminal
	alacritty
	#wayland stuff
	wayland
	#notification daemon
	swaynotificationcenter
	rofi
	#daily utility	
	vesktop
	google-chrome
	spotify
	swaybg
	#screenshot tool
	slurp
	grim
	xdg-user-dirs
	wayfreeze
	#clipboard manager
	wl-clipboard
	copyq
	#system utils
	git
	zip
	#audio manager
	pulseaudio
	pamixer
	pavucontrol
	#power menu
	swaylock
	procps
	#waybar
	waybar
	#file manager
	nautilus
	#text viever
	mousepad
	#img viewer
	swayimg
];

#FLATHUB
services.flatpak.enable = true;

#MANGO
programs.mango.enable = true;

#SWAY
programs.sway = {
	enable = true;
    	wrapperFeatures.gtk = true;
	extraOptions = [ "--unsupported-gpu" ];
	extraPackages = [];
};

#LOGIN MANAGER
services.displayManager.ly = {
  enable = true;
  settings = {
    animation = "doom";
    animation_timeout_sec = 300;
    bigclock = "en";
  };
};

#WAYLAND (?)
programs.xwayland.enable = true;

#AUDIO
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  jack.enable = true; 
};

#NVIDIA DRIVERS
hardware.graphics = {
    enable = true;
    enable32Bit = true;
};

services.xserver.videoDrivers = ["nvidia"];

hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
};

#USERS
users.users.nanon = {
	isNormalUser = true;
	description = "nixos-nanon";
	extraGroups = [ "wheel" "networkmanager" "audio" ];
};

#SSH	
services.openssh = {
	enable = true;
	openFirewall = true;
	settings = {
		PasswordAuthentication = true;
		PermitRootLogin = "yes";
		MaxAuthTries = 3;
		PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
	};
};	
programs.ssh = {
	extraConfig = ''
		Host myhost
		Hostname 192.168.100.169
		Port 22
		User user
	'';
};

system.stateVersion = "26.05";
}

