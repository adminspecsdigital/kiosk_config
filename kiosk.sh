#!/bin/bash
ROTATION=normal

if ! pgrep -x Xorg > /dev/null; then
    xinit -- :0 &
    sleep 2  # dá um tempo para o X inicializar
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
  google-chrome --kiosk --no-first-run  'https://github.com/wlabesamis'
done
