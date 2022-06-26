#!/bin/bash

# salva num arquivo os dados de cada mensagem enviada 
touch pacote_teste.txt

cont=1

while [ $cont -le 5 ]
do
        
    tempo_atual_epoch_segundos=`date +%s.%N`

    echo $tempo_atual_epoch_segundos
    echo $tempo_atual_epoch_segundos >> pacote_teste.txt

    mosquitto_pub -t test_topic -m $tempo_atual_epoch_segundos -u "tht" -P "senha123" -q 0;
    mosquitto_pub -t test_topic -m $tempo_atual_epoch_segundos -u "tht" -P "senha123" -q 1;
    mosquitto_pub -t test_topic -m $tempo_atual_epoch_segundos -u "tht" -P "senha123" -q 2
    echo 'Mensagem enviada'

    cont=`expr $cont + 1`

    # Intervalo de monitoramento (segundos)
    sleep 59

done
