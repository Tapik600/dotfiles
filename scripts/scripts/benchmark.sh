#!/bin/bash

#https://habr.com/ru/company/wd/blog/569754/
#Получаем значения температуры, текущей частоты вычислительных ядер и информацию о троттлинге с помощью утилиты vcgencmd

function get_info() {

    vcgencmd measure_temp

    vcgencmd measure_clock arm

    vcgencmd get_throttled

    echo

}

get_info

#Запускаем 10 прогонов sysbench в четырехпоточном режиме (по потоку на каждое ядро, для Zero/Zero W достаточно 1) и перенаправляем вывод бенчмарка в /dev/null

for ((i=1;i<=10;i++))

do

   sysbench --num-threads=4 --test=cpu --cpu-max-prime=20000 run > /dev/null # 2>&1

    get_info

done

