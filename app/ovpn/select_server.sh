#!/bin/sh

ZIP_FILE="/app/ovpn/ovpn_configs.zip" # El archivo ZIP en la misma ruta que este script

files=$(unzip -l "$ZIP_FILE" | grep '.ovpn' | awk '{print $4}')

if [ -z "$files" ]; then
    echo "Error: No se encontraron archivos .ovpn en el archivo ZIP."
    exit 1
fi

selected_files=""

if [ "$OVPN_SERVICE_PROVIDER" = "surfshark" ]; then
    files=$(echo "$files" | grep 'udp')
fi

if [ -n "$SERVER_CITY" ]; then
    selected_files=$(echo "$files" | grep -i "\-${SERVER_CITY}")
fi

if [ -z "${selected_files}" ] && [ -n "${SERVER_COUNTRY}" ]; then
    selected_files=$(echo "$files" | grep -i "${SERVER_COUNTRY}\-")
fi

if [ -n "$selected_files" ]; then
    selected_file=$(echo "$selected_files" | shuf -n 1)
else
    # when dont found config files coincidences
    if [ -n "$SERVER_CITY" ] || [ -n "$SERVER_COUNTRY" ]; then
        echo "Error: No se encontró un archivo que coincida con los criterios."
        exit 1
    else
        # select random file
        selected_file=$(echo "$files" | shuf -n 1)
    fi
fi

echo "$selected_file"
