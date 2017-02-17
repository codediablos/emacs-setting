sudo cp emacs.service /etc/init.d/emacs
sudo emacs /etc/init.d/emacs

sudo update-rc.d emacs defaults
sudo update-rc.d emacs enable
#sudo update-rc.d emacs remove
