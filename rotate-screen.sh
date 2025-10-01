#!/bin/bash

# Nome do dispositivo touchscreen
DEVICE_NAME="ILITEK ILITEK-TP"
ROTACAO="${1:-normal}"  # padrão: normal
CONNECTED_PORT=$(DISPLAY=:0 xrandr --query | grep " connected" | head -n1 | cut -d' ' -f1)

# Função de rotação
rotacionar_tela_e_touch() {
    local orientacao="$1"
    local matriz

    case "$orientacao" in
        # Posição normal
        normal)
            DISPLAY=:0 xrandr --output "$CONNECTED_PORT" --rotate normal
            matriz="1 0 0 0 1 0 0 0 1"
            ;;

        # Rotaciona à direita
        right)
            DISPLAY=:0 xrandr --output "$CONNECTED_PORT" --rotate right
            matriz="0 -1 1 1 0 0 0 0 1"
            ;;
        
        # Rotaciona à esquerda
        left)
            DISPLAY=:0 xrandr --output "$CONNECTED_PORT" --rotate left
            matriz="0 1 0 -1 0 1 0 0 1"
            ;;

        inverted)
            DISPLAY=:0 xrandr --output "$CONNECTED_PORT" --rotate inverted
            matriz="-1 0 1 0 -1 1 0 0 1"
            ;;


        # Avisa de parâmetro inválido
        *)
            echo "Uso: $0 [normal|right|left|inverted]"
            exit 1
            ;;
    esac

    # Descobre o ID do touchscreen
    DEVICE_ID=$(DISPLAY=:0 xinput list --id-only "$DEVICE_NAME")
    if [ -z "$DEVICE_ID" ]; then
        echo "Dispositivo touch '$DEVICE_NAME' não encontrado."
        exit 1
    fi

    # Aplica matriz de transformação
    DISPLAY=:0 xinput set-prop "$DEVICE_ID" "Coordinate Transformation Matrix" $matriz
}

rotacionar_tela_e_touch "$ROTACAO"
exit 0
