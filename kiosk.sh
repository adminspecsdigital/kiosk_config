#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/kiosk/.Xauthority

LOGFILE=/var/log/kiosk-app.log
ROTATION=normal

echo "=== Iniciando kiosk.sh === $(date)" >> "$LOGFILE" 2>&1

# Espera o X estar ativo
until xset q >/dev/null 2>&1; do
    echo "⏳ Aguardando servidor X..." >> "$LOGFILE"
    sleep 1
done

# Configura tela
xset -dpms
xset s off
xset s noblank

# Inicia openbox (apenas se não já estiver rodando)
pgrep -x openbox >/dev/null || openbox-session &

# Ajusta rotação (se necessário)
if [ -x /opt/rotate-screen.sh ]; then
    /opt/rotate-screen.sh "$ROTATION" >> "$LOGFILE" 2>&1
fi

# Loop da aplicação
while true; do
    echo "▶️ Iniciando aplicação $(date)" >> "$LOGFILE"

    # Se quiser rodar Chrome:
    google-chrome --kiosk --no-first-run 'https://github.com/adminspecsdigital/kiosk_config' >> "$LOGFILE" 2>&1

    # Se quiser rodar sua app:
    # /opt/app/app >> "$LOGFILE" 2>&1 

    echo "⚠️ Aplicação caiu, reiniciando em 3s..." >> "$LOGFILE"
    sleep 3
done
