#!/bin/sh

chmod +x ./scripts/get_ovpn_config.sh
OVPN_FILE=$(./scripts/get_ovpn_config.sh)
echo "Chose: ${OVPN_FILE}"

chmod +x ./scripts/build_auth_file.sh
AUTH_FILE=$(./scripts/build_auth_file.sh)

if [ "${CREATE_TUN_DEVICE}" = "true" ]; then
  echo "New TUN device in /dev/net/tun"
  mkdir -p /dev/net
  mknod /dev/net/tun c 10 200
  chmod 0666 /dev/net/tun
fi


echo "[INFO] openvpn --config ${OVPN_FILE} --auth-user-pass ${AUTH_FILE} --mute-replay-warnings --auth-nocache ${OVPN_OPTS}"
openvpn --config $OVPN_FILE \
  --auth-user-pass $AUTH_FILE \
  --mute-replay-warnings \
  --auth-nocache $OVPN_OPTS
