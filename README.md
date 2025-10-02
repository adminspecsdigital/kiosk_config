# Specs Digital Ubuntu Server Kiosk Mode

## Iniciando

Este documento lhe fornecerá instruções para a instalação do Ubuntu Server rodando ambiente gráfico em modo Kiosk, contando com o uso de telas sensíveis ao toque.

### Pré Requisitos

Tenha certeza de que instalou estes pré requisitos

Nota: Instalando o Ubuntu Server há o requerimento de uma conexão com a internet para que seja possível instalar os pacotes necessários ao funcionamento do modo kiosk após a instalação do sistema operacional.

* Ubuntu Server - [Download](https://ubuntu.com/download/server)

### Passos

Após a instalação do sistema operacional e tendo acessado o prompt de terminal execute os seguintes passos

* Baixando o conteúdo deste repositório 
        
    ```
    git clone https://github.com/adminspecsdigital/kiosk_config.git
    ```
* Executando os scripts de instalação de gerenciador de rede para conexão com redes wifi (se houver conexão via cabo pode considerar este passo opcional)

    ````
    cd kiosk_config
    sh ./install-network-manager.sh
    ````  
  
* Instalação do ambiente gráfico

    ````
    sh ./setup.sh
    ````
    Durante o processo você será questionado sobre a orientação da tela. As opções são:

    * normal (opção padrão, orientação em modo paisagem)
    * right (orientação em modo retrato rotacionado à esquerda)
    * left (orientação em modo retrato rotacionado à direita)
    * inverted (orientação em modo paisagem invertido)

    Salientando que se houver um dispositivo touch atrelado ao display, sua matriz será ajustada para trabalhar de acordo com a orientação.

    Após este passo será habilitado automaticamente o modo gráfico, executando o Google Chrome em modo kiosk para o site do Specs Digital. 

* Ajustes

    * Modificando a Orientação

    Modifique o arquivo /opt/kiosk.sh 
    ````
    sudo nano /opt/kiosk.sh
    ````
    Na segunda linha temos: 
    ````
    ROTATION=normal
    ````
    Troque o termo "normal", por aquele que for mais conveniente de acordo com o expressado anteriormente. Salve o arquivo e reinicie a máquina.

    * Modifique a aplicação que está sendo carregada
    Modifique o arquivo /opt/kiosk.sh 
    ````
    sudo nano /opt/kiosk.sh
    ````
    no trecho:
    ````
    while true; do
        #
        # Substituir os comandos abaixo pela chamada da aplicação do cliente
        # 
        rm -rf ~/.{config,cache}/google-chrome/
        google-chrome --kiosk --no-first-run  'https://github.com/wlabesamis'
    done
    ````
    substitua as linas sem comentários pela chamada de seu aplicativo

## Autores

* **Adminstrador Specs Digital** - (https://github.com/adminspecsdigital)
* **Edison Junior** 

## Agradecimentos

* Thank you to Wilson Abesamis
* **Wilson Abesamis** - (https://github.com/wlabesamis)
