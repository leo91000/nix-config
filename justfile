rebuild:
  git add . && git commit --amend -m "modif leo" && sudo nixos-rebuild switch --flake . && git push --force-with-lease github main
