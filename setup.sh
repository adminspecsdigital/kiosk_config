# Install google chrome, xorg, xserver-xorg-legacy, openbox and pulseaudio
sudo add-apt-repository 'deb http://dl.google.com/linux/chrome/deb/ stable main'
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt update -y
sudo apt install -y --no-install-recommends xorg openbox google-chrome-stable pulseaudio xserver-xorg-legacy
sudo apt install -y --no-install-recommends xorg openbox pulseaudio xserver-xorg-legacy
sudo apt install -y --no-install-recommends libsecret-1-0 libmpv2
sudo apt install -y xinput xserver-xorg-input-all
sudo usermod -a -G audio $USER

# Config xserver-xorg-legacy and change to "Anybody" users
sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config
echo "needs_root_rights=yes" | sudo tee -a /etc/X11/Xwrapper.config

# Enable tty1 tty2 tty3
sudo systemctl enable getty@tty1 getty@tty2 getty@tty3

#Update Grub
sudo cp grub /etc/default/grub
sudo update-grub

# install kiosh service
sudo cp kiosk.sh /opt/
sudo cp rotate-screen.sh /opt/
sudo chmod +x /opt/kiosk.sh
sudo chmod +x /opt/rotate-screen.sh

# Pergunta rotação
echo "Qual rotação deseja usar para a tela? (normal/left/right/inverted)"
read ROTACAO
# Aplica alteração no kiosk.sh
sudo sed -i "s|/opt/rotate-screen.sh .*|/opt/rotate-screen.sh $ROTACAO|" /opt/kiosk.sh

sudo cp kiosk.service /etc/systemd/system/
sudo systemctl enable kiosk.service
sudo systemctl start kiosk.service
