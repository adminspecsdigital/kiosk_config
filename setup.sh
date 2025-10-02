#install network manager 
sh ./install-network-manager.sh
# Install google chrome, xorg, xserver-xorg-legacy, openbox and pulseaudio
sudo add-apt-repository 'deb http://dl.google.com/linux/chrome/deb/ stable main'
wget -q -O- https://dl.google.com/linux/linux_signing_key.pub | \
  sudo gpg --dearmor -o /usr/share/keyrings/google-linux-signing-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-signing-keyring.gpg] https://dl.google.com/linux/chrome/deb/ stable main" | \
  sudo tee /etc/apt/sources.list.d/google-chrome.list

sudo apt update -y

sudo apt install -y --no-install-recommends google-chrome-stable
sudo apt install -y --no-install-recommends xorg openbox pulseaudio xserver-xorg-legacy
sudo apt install -y --no-install-recommends xinput xserver-xorg-input-all
sudo apt install -y --no-install-recommends libsecret-1-0 libmpv2

sudo usermod -a -G audio $USER

# Config xserver-xorg-legacy and change to "Anybody" users
sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config
echo "needs_root_rights=yes" | sudo tee -a /etc/X11/Xwrapper.config

# Enable tty1 tty2 tty3
sudo systemctl enable getty@tty1 getty@tty2 getty@tty3

#Update Grub
if [ -f grub ]; then
    sudo cp grub /etc/default/grub
    sudo update-grub
else
    echo "Arquivo grub não encontrado. Pulei essa etapa."
fi

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
