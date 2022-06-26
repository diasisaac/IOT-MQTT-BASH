#!/bin/bash

function categoria_qos0()
{
    tmp_epoch_msg_pub="$1"

    tmp_epoch_chegada_msg_sub_qos_0=`awk 'NR==1{print $1}' logmsg.txt`

    # Fazer a subtração de tempo chegada no sub - tempo envio do pub.
    delay_qos0="$(echo "$tmp_epoch_chegada_msg_sub_qos_0 - $tmp_epoch_msg_pub" | bc)"

    printar 0 $tmp_epoch_msg_pub $tmp_epoch_chegada_msg_sub_qos_0 $delay_qos0

}


function categoria_qos1()
{
    tmp_epoch_msg_pub="$1"

    tmp_epoch_chegada_msg_sub_qos_1=`awk 'NR==2{print $1}' logmsg.txt`
    
    
    # Fazer a subtração de tempo chegada no sub - tempo envio do pub.
    delay_qos1="$(echo "$tmp_epoch_chegada_msg_sub_qos_1 - $tmp_epoch_msg_pub" | bc)"

    printar 1 $tmp_epoch_msg_pub $tmp_epoch_chegada_msg_sub_qos_1 $delay_qos1 


}

function categoria_qos2()
{
    tmp_epoch_msg_pub="$1"

    tmp_epoch_chegada_msg_sub_qos_2=`awk 'NR==3{print $1}' logmsg.txt`

    # Fazer a subtração de tempo chegada no sub - tempo envio do pub.

    delay_qos2="$(echo "$tmp_epoch_chegada_msg_sub_qos_2 - $tmp_epoch_msg_pub" | bc)"

    printar 2 $tmp_epoch_msg_pub $tmp_epoch_chegada_msg_sub_qos_2 $delay_qos2 

}

function printar()
{
    
    qos="$1"
    tmp_epoch_msg_pub="$2"
    tmp_epoch_chegada_msg_sub_qos="$3"
    delay_qos="$4"

    echo "QOS: " $qos
    echo "Tempo no momento de envio no pub: " $tmp_epoch_msg_pub
    echo "Tempo que a mensagem chegou no subscriber - QOS $qos:" $tmp_epoch_chegada_msg_sub_qos
    echo "O delay em segundos epoc total foi de: " $delay_qos

    echo "$tmp_epoch_chegada_msg_sub_qos : $tmp_epoch_msg_pub : $delay_qos" >> delay_qos$qos.txt
}

cont=1


while [ $cont -le 120 ]
do


    mosquitto_sub -W 60 -t test_topic -F '@s.@N : %p : %q : %I' -u "tht" -P "senha123" -q 0 -q 1 -q 2 > logmsg.txt

    num_linhas=`wc --lines logmsg.txt | awk {'print $1'}`
    
    if [ $num_linhas -eq 0 ]; then
       
        echo "linhas eh 0"
        break
    else
        # Verifica qual é o QOS desejado
        # Aqui tá em tempo EPOCH 
        tmp_epoch_msg_pub=`awk 'NR==1{print $3}' logmsg.txt` # em segundos epoch


        categoria_qos0 $tmp_epoch_msg_pub
        categoria_qos1 $tmp_epoch_msg_pub
        categoria_qos2 $tmp_epoch_msg_pub
        cont=`expr $cont + 1`
    fi
    
            # executa funcao do qos requerido 

    #categoria_qos0 $tmp_epoch_msg_pub
    #categoria_qos1 $tmp_epoch_msg_pub
    #categoria_qos2 $tmp_epoch_msg_pub
  
    
    cont=`expr $cont + 1`

done
