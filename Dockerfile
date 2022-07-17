FROM alpine:latest
LABEL maintainer.name="Jose Rodriguez" \
    maintainer.email="josearodrigueze@gmail.com" \
    version="1.0" \
    description="OpenVPN client for multiple service providers"

WORKDIR /vpn

ARG OVPN_SERVICE_PROVIDER
ARG OVPN_USER
ARG OVPN_PASSWORD

ARG OVPN_FILE
ARG OVPN_CONFIGS_URL
ARG OVPN_SERVICE_PROVIDER

# ARG OVPN_CA_CRT

ARG OVPN_OPTS
ARG CREATE_TUN_DEVICE

RUN apk add --update --no-cache openvpn unzip curl

HEALTHCHECK --interval=120s --timeout=10s --start-period=30s CMD curl -s -L 'https://checkip.amazonaws.com/'

COPY ./scripts ./scripts
COPY startup.sh .
RUN chmod +x ./startup.sh
ENTRYPOINT [ "./startup.sh" ]
