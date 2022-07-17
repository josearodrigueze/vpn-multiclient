# vpn-multiclient

VPN client for multiple service providers with very low RAM consumption (aprox 5 MB)

This image is based on alpine and openvpn, for an environment capable of masking and routing your connections
through the different VPN providers.

# Support for:

- IPVanish
- Surfshark

# Environment configs

| Name                    | Required    | Description                                                    | Default    | Example                        |
|-----------------------	|----------	|-------------------------------------------------------------	|---------	|-------------------------------	|
| OVPN_SERVICE_PROVIDER    | Yes        | To choose a service provider. Check support list for values    |         	|                               	|
| OVPN_USER                | Yes        | Username provided by service                                    |         	|                               	|
| OVPN_PASSWORD            | Yes        | Password provided by service                                    |         	|                               	|
| OVPN_FILE                |          	| To select specific server.                                    | Random    | ipvanish-PE-Lima-lim-c01.ovpn    |
| OVPN_OPTS                |          	| To pass extra openvpn options.                                | Empty    |                               	|

# Minimal docker run Example

```
docker run -d --cap-add=NET_ADMIN --device /dev/net/tun \
    --name CONTAINER_NAME
    -e OVPN_SERVICE_PROVIDER=ipvanish \
    -e OVPN_USER=YOUR_USER \
    -e OVPN_PASSWORD=YOUR_PASS \
    josearodrigueze/vpn-multiclient
```

# Minimal docker-compose example

```
version: '3.9'

x-logging: &logging
  logging:
    driver: "json-file"
    options:
      max-size: "10m"
      max-file: "1"

x-openvpn: &openvpn
  image: josearodrigueze/vpn-multiclient
  restart: unless-stopped
  <<: *logging # calling var &logging
  cap_add:
    - NET_ADMIN
  devices:
    - /dev/net/tun
  dns: # optional
    - 1.1.1.1
  env_file: # for load your env variables
    - .env # youu can use .env.example

services:
  vpn_multiclient1:
    <<: *openvpn # calling var &openvpn
    container_name: vpn_multiclient1 # very import to connect antoher container
    
  # this way you can connect other container 
  test:
    image: byrnedo/alpine-curl
    container_name: test
    command: -s -L 'https://checkip.amazonaws.com'
    depends_on:
      vpn_multiclient1: # Same as container_name connected to provider 
        condition: service_healthy
    network_mode: service:openvpn_1
    restart: always

```

# WPI

- More specific documentation
- Support for more providers
- Add sock5 support


# You want to help me?
