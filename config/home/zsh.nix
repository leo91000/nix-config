{ config, lib, pkgs, ... }:

let inherit (import ../../options.nix) flakeDir theShell hostname; in
lib.mkIf (theShell == "zsh") {
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    historySubstringSearch.enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "npm" "docker" ];
    };
    profileExtra = ''
      #if [ -z "$DISPLAY" ] && [ "$XDG_VNTR" = 1 ]; then
      #  exec Hyprland
      #fi
    '';
    initExtra = ''
      zstyle ":completion:*" menu select
      zstyle ":completion:*" matcher-list "" "m:{a-z0A-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*"
      if type nproc &>/dev/null; then
        export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)-1))"
      fi
      bindkey '^[[3~' delete-char                     # Key Del
      bindkey '^[[5~' beginning-of-buffer-or-history  # Key Page Up
      bindkey '^[[6~' end-of-buffer-or-history        # Key Page Down
      bindkey '^[[1;3D' backward-word                 # Key Alt + Left
      bindkey '^[[1;3C' forward-word                  # Key Alt + Right
      bindkey '^[[H' beginning-of-line                # Key Home
      bindkey '^[[F' end-of-line                      # Key End
      bindkey '^H' backward-delete-word
      #neofetch
      export TERM='screen-256color'
      if [ -f $HOME/.zshrc-personal ]; then
        source $HOME/.zshrc-personal
      fi
      if [ -z "$TMUX" ]; then
        tmux attach || tmux new-session
      fi
    '';
    initExtraFirst = ''
      HISTFILE=~/.histfile
      HISTSIZE=1000
      SAVEHIST=1000
      setopt autocd nomatch
      unsetopt beep extendedglob notify
      autoload -Uz compinit
      compinit
    '';
    sessionVariables = {

    };
    shellAliases = {
      sv="sudo vim";
      flake-rebuild="sudo nixos-rebuild switch --flake ${flakeDir}#nixos";
      flake-update="sudo nix flake update ${flakeDir}";
      gcCleanup="nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      v="nvim";
      ls="lsd";
      ll="lsd -l";
      la="lsd -a";
      lal="lsd -al";
      ".."="cd ..";
      neofetch="neofetch --ascii ~/.config/ascii-neofetch";
      grt = "cd \"$(git rev-parse --show-toplevel)\"";
      gs = "git status";
      gp = "git push";
      gpf = "git push --force";
      gpft = "git push --follow-tags";
      gpl = "git pull --rebase";
      gcl = "git clone";
      gst = "git stash";
      grm = "git rm";
      gmv = "git mv";
      main = "git checkout main";
      gco = "git checkout";
      gcob = "git checkout -b";
      gb = "git branch";
      gbd = "git branch -d";
      grb = "git rebase";
      grbom = "git rebase origin/main";
      grbc = "git rebase --continue";
      gl = "git log";
      glo = "git log --oneline --graph";
      grh = "git reset HEAD";
      grh1 = "git reset HEAD~1";
      ga = "git add";
      gA = "git add -A";
      gc = "git commit";
      gcm = "git commit -m";
      gca = "git commit -a";
      gcam = "git add -A && git commit -m";
      gfrb = "git fetch origin && git rebase origin/master";
      gxn = "git clean -dn";
      gx = "git clean -df";
      gsha = "git rev-parse HEAD | pbcopy";
      ghci = "gh run list -L 1";
      nd="nix develop -c $SHELL";
    };
  };
}
