#!/bin/sh

cd /app/ovpn

# echo "Running get_ovpn_config.sh"

# check strategy to get ovpn files
if [ -z "${OVPN_SERVICE_PROVIDER}" ] && [ -z "${OVPN_CONFIGS_URL}" ]
then
    echo >&2 "OVPN_SERVICE_PROVIDER or OVPN_CONFIGS_URL required "
    exit 1
fi

# remove file from current dir
rm -rf *.ovpn *.crt ovpn_configs.zip

case "${OVPN_SERVICE_PROVIDER}" in
   "ipvanish") OVPN_CONFIGS_URL=https://configs.ipvanish.com/configs/configs.zip && curl -s -o ovpn_configs.zip $OVPN_CONFIGS_URL ;;
   "surfshark") cp /app/ovpn/surfshark_config.zip ovpn_configs.zip ;;
   *) [ -z "${OVPN_CONFIGS_URL}" ] && (echo >&2 "OVPN_CONFIGS_URL required" && exit 1) || echo "" > /dev/null ;;
esac

if [ -z "$OVPN_FILE" ]; then
  OVPN_FILE=$(/app/ovpn/select_server.sh)
fi

unzip -p ovpn_configs.zip $OVPN_FILE > $OVPN_FILE
for zipfiles in ovpn_configs.zip; do unzip -xo "$zipfiles" '*.crt' ; done > /dev/null

sed -i '/keysize/d' $OVPN_FILE

# get vpn file server config
echo "$OVPN_FILE"
