#!/bin/bash

    echo "Input process name"
    read procname
    echo "Input args"
    read args
    echo "time check [ min h d m y]"
    read timeCheck
    echo "$timeCheck $procname $args" >> rec_g 