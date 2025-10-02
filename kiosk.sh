#!/bin/bash
ROTATION=normal

# Inicia X se não estiver rodando
if ! pgrep -x Xorg > /dev/null; then
    xinit /usr/bin/openbox-session -- :0 &
fi

export DISPLAY=:0

# Aguarda X ficar pronto
until xset q >/dev/null 2>&1; do
    echo "⏳ Aguardando servidor X..."
    sleep 1
done

# Desativa suspensão de tela
xset -dpms
xset s off

# Som (caso use pulseaudio)
command -v start-pulseaudio-x11 >/dev/null && start-pulseaudio-x11

# Rotaciona tela
/opt/rotate-screen.sh "$ROTATION"

# Loop da aplicação
while true; do
    # limpa apenas cache (não remove configs)
    rm -rf ~/.cache/google-chrome/

    # inicia chrome em modo kiosk
    google-chrome --kiosk --no-first-run 'https://github.com/wlabesamis'

    # espera antes de reiniciar em caso de crash/fechamento
    sleep 2
done
