printf "\n"
printf "=======================================================================\n"
printf "moving neovim.\n"
printf "=======================================================================\n"
cp -rv nvim/init.lua ~/config/nvim/
cp -rv nvim/lua ~/.config/nvim

printf "=======================================================================\n"
printf "moving .tmux.conf .zshrc\n"
printf "=======================================================================\n"
cp -rv .tmux.conf ~/
cp -rv .zshrc ~/
