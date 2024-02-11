{ pkgs, config, ... }:
{
  programs.tmux = {
    enable = true;

    extraConfig = ''
      set -g default-shell ${pkgs.zsh}/bin/zsh
      set -g default-terminal "screen-256color"
      set -g mouse on
      set -g focus-events on
      set -g status-bg default
      set -g status-style bg=default
      set-option -sg escape-time 10
      set-option -sa terminal-features ',screen-256color:RGB'
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix
      bind ^ split-window -h -c "#{pane_current_path}"
      bind $ split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
      unbind '"'
      unbind %
      bind-key -r Left resize-pane -L 1
      bind-key -r Right resize-pane -R 1
      bind-key -r Up resize-pane -U 1
      bind-key -r Down resize-pane -D 1
      bind-key x kill-pane
      bind r source-file ~/.config/tmux/.tmux.conf
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "${pkgs.xclip}/bin/xclip -in -selection clipboard"
      set -g @catppuccin_flavour 'latte' # or frappe, macchiato, mocha
    '';

    plugins = with pkgs; [
      tmuxPlugins.catppuccin
    ];
  };
}
