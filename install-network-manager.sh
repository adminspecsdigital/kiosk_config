#!/bin/bash

# Garantir que o NetworkManager esteja instalado e rodando
sudo apt install -y network-manager net-tools
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# Verifica se já existe conexão ativa (cabo ou Wi-Fi)
conexao_ativa=$(nmcli -t -f NAME con show --active)

if [ -n "$conexao_ativa" ]; then
    echo "Já conectado à rede: $conexao_ativa"
    echo "Nenhuma ação necessária."
    exit 0
fi

# Lista redes Wi-Fi disponíveis
echo "Nenhuma conexão ativa encontrada."
echo "Buscando redes Wi-Fi disponíveis..."
mapfile -t redes < <(nmcli -t -f SSID dev wifi list | grep -v '^$' | sort -u)

if [ ${#redes[@]} -eq 0 ]; then
    echo "Nenhuma rede Wi-Fi encontrada. Tente novamente."
    exit 1
fi

echo "Selecione a rede Wi-Fi:"
select SSID in "${redes[@]}"; do
    if [ -n "$SSID" ]; then
        echo "Você selecionou: $SSID"
        break
    else
        echo "Opção inválida. Tente novamente."
    fi
done

# Pede senha
read -sp "Digite a senha para $SSID: " PASSWORD
echo

# Tenta conectar
echo "Conectando a $SSID..."
if nmcli dev wifi connect "$SSID" password "$PASSWORD"; then
    echo "✅ Conectado com sucesso a $SSID"
else
    echo "❌ Falha ao conectar a $SSID"
fi
