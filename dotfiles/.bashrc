if (( RANDOM % 4096 == 0 )); then
    echo -e "\033[33momg omg omg u got a shiny pokemon aaaa\033[0m"
    pokeget random --shiny
else
    pokeget random
fi

alias rb='sudo nixos-rebuild switch -I nixos-config=/home/larry/.config/nixos/configuration.nix'
alias nc='cd ~/.config/nixos'