#!/bin/sh

# echo "Running get_ovpn_config.sh"

# check strategy to get ovpn files
if [ -z "${OVPN_SERVICE_PROVIDER}" ] && [ -z "${OVPN_CONFIGS_URL}" ]
then
    echo >&2 "OVPN_SERVICE_PROVIDER or OVPN_CONFIGS_URL required "
    exit 1
fi

case "${OVPN_SERVICE_PROVIDER}" in
   "ipvanish") OVPN_CONFIGS_URL=https://www.ipvanish.com/software/configs/configs.zip ;;
   "surfshark") OVPN_CONFIGS_URL=https://my.surfshark.com/vpn/api/v1/server/configurations ;;
   *) [ -z "${OVPN_CONFIGS_URL}" ] && (echo >&2 "OVPN_CONFIGS_URL required" && exit 1) || echo "" > /dev/null ;;
esac

# remove file from current dir
rm -rf *.ovpn *.crt ovpn_configs.zip

# echo "Download ovpn from ${$OVPN_CONFIGS_URL}"
curl -s -o ovpn_configs.zip $OVPN_CONFIGS_URL

if [ -z "$OVPN_FILE" ]
then
  # echo "Unzip ovpns"
  unzip -q ovpn_configs.zip

  OVPN_FILE=$(find . -type f -name '*.ovpn' | shuf -n 1)
else
  # echo "extract selected file ${OVPN_FILE}"
  unzip -p ovpn_configs.zip $OVPN_FILE > $OVPN_FILE
  for zipfiles in ovpn_configs.zip; do unzip -xo "$zipfiles" '*.crt' ; done > /dev/null
fi

rm ovpn_configs.zip

# get vpn file server config
echo "$OVPN_FILE"
