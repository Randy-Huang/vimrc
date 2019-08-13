#!/bin/sh
cd ~/.vim/colors/
rm -rf *.vim
ln -s ~/.vim/bundle/wombat256.vim/colors/wombat256mod.vim wombat265.vim
ln -s ~/.vim/bundle/Solarized/colors/solarized.vim solarized.vim

cd ~
ln -s .vim/vimrc .vimrc

