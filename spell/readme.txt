copiar a cd ~/Downloads/spell/
sudo cp ./* /usr/share/vim/vim74/spell/

para usar como verificador ortográfico de vim en español
vim ~/.vimrc

# Añadimos
set spell
setlocal spell spelllang=es
