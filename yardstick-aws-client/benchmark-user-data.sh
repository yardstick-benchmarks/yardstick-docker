#!/bin/bash

if [ ! -f /home/user-data ]; then
    wget http://169.254.169.254/latest/user-data
    mv user-data /home/ 2>/dev/null
    sed -i -e '$a\ ' /home/user-data
fi

while read p; do
    if [[ ${p} == $1* ]]; then
        echo ${p} | sed 's/.*=\(.*\)/\1/' | tr -d '\r'
        break
    fi
done < /home/user-data