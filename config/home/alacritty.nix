{ pkgs, config, lib, ... }:

let
  palette = config.colorScheme.palette;
  inherit (import ../../options.nix) alacritty;
in lib.mkIf (alacritty == true) {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
	padding.x = 4;
	padding.y = 0;
	decorations = "none";
	startup_mode = "Windowed";
	dynamic_title = true;
	opacity = 0.85;
      };
      cursor = {
	style = {
	  shape = "Beam";
	  blinking = "On";
	};
      };
      live_config_reload = true;
      font = {
	normal.family = "JetBrainsMono NFM";
	bold.family = "JetBrainsMono NFM";
	italic.family = "JetBrainsMono NFM";
	bold_italic.family = "JetBrainsMono NFM";
	size = 14;
      };
      colors = {
	bright = {
	  black = "#444b6a";
	  red = "#ff7a93";
	  green = "#b9f27c";
	  yellow = "#ff9e64";
	  blue = "#7da6ff";
	  magenta = "#bb9af7";
	  cyan = "#0db9d7";
	  white = "#acb0d0";
	};
	normal = {
	  black = "#32344a";
	  red = "#f7768e";
	  green = "#9ece6a";
	  yellow = "#e0af68";
	  blue = "#7aa2f7";
	  magenta = "#ad8ee6";
	  cyan = "#449dab";
	  white = "#787c99";
	};
	primary = {
	  background = "#1a1b26";
	  foreground = "#a9b1d6";
	};
      };
    };
  };
}
