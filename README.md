# vpn-multiclient
VPN client for multiple service providers



# DOCKER RUN
docker run -d --cap-add=NET_ADMIN --device /dev/net/tun \
    --name CONTAINER_NAME
    -e OVPN_SERVICE_PROVIDER=ipvanish \
    -e OVPN_USER=YOUR_USER \
    -e OVPN_PASSWORD=YOUR_PASS \
    josearodrigueze/vpn-multiclient
