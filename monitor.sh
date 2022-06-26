#!/bin/bash
echo Cont MemUsed MemFree MemShared MemBuffer DiskUsed CpuUsr CpuSys CpuSoft CpuIdle Data Hora Bytes Pacotes > log.txt
echo Cont MemUsed MemFree MemShared MemBuffer DiskUsed CpuUsr CpuSys CpuSoft CpuIdle Data Hora Bytes Pacotes

# -le siginfca less or equal menor ou igual
# -le significa menor que  less than
# pra o mqtt usa o -le
# Ou pode ser True 


cont=1
bytes_y=0
bytes_x=`cat /proc/net/dev | grep eth0 |  awk '{print$2}'`

pacotes_x=`cat /proc/net/dev | grep eth0 |  awk '{print$3}'`
pacotes_y=0

while [ $cont -le 10 ] 
do 

 mem=`free | grep Mem | awk '{print $3, $4, $5, $6}'`
 disco=`df | grep sdb7 | awk '{print $3}'`
 cpu=`mpstat 1 1 | grep Average | awk '{print $3, $5, $8, $12}'`
 data=`date --rfc-3339=seconds`

 # Monitorando o bytes 
 bytes_y=`cat /proc/net/dev | grep eth0 |  awk '{print$2}'`
 bytes=`expr $bytes_y - $bytes_x`

 #Monitoramento packets
 pacotes_y=`cat /proc/net/dev | grep eth0 |  awk '{print$3}'`
 pacotes=`expr $pacotes_y - $pacotes_x`

 
 echo $cont $mem $disco $cpu $data $bytes $pacotes >> log.txt
 echo $cont $mem $disco $cpu $data $bytes $pacotes
 
 #echo "Bytes antes: $bytes_x --- Depois: $bytes_y --- result: $bytes"
 #echo "Pacotes antes: $pacotes_x --- Depois: $pacotes_y --- result: $pacotes"
 
 cont=`expr $cont + 1`
 
 bytes_x=`cat /proc/net/dev | grep eth0 |  awk '{print$2}'`

 pacotes_x=`cat /proc/net/dev | grep eth0 |  awk '{print$3}'`
 # Intervalo de monitoramento (segundos)
 sleep 5

done
