#!/bin/bash
ROTATION=normal

if ! pgrep -x Xorg > /dev/null; then
    xinit -- :0 &
    while ! xdpyinfo -display :0 >/dev/null 2>&1; do 
      sleep 1; 
    done
fi

export DISPLAY=:0

xset -dpms
xset s off
openbox-session &
start-pulseaudio-x11

# Executa o script de rotação antes de abrir a aplicação
/opt/rotate-screen.sh "$ROTATION"

while true; do
  #
  # Substituir os comandos abaixo pela chamada da aplicação do cliente
  # 
  rm -rf ~/.{config,cache}/google-chrome/
  google-chrome --kiosk --no-first-run  'https://github.com/adminspecsdigital/kiosk_config'
done
