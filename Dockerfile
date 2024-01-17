FROM alpine:latest
LABEL maintainer.name="Jose Rodriguez" \
    maintainer.email="josearodrigueze@gmail.com" \
    version="1.0" \
    description="OpenVPN client for multiple service providers"

EXPOSE 8118

WORKDIR /app

ARG OVPN_SERVICE_PROVIDER
ARG OVPN_USER
ARG OVPN_PASSWORD

ARG OVPN_FILE
ARG OVPN_CONFIGS_URL
ARG OVPN_SERVICE_PROVIDER

# ARG OVPN_CA_CRT

ARG OVPN_OPTS
ARG CREATE_TUN_DEVICE

RUN apk add --update --no-cache openvpn unzip curl privoxy runit jq

HEALTHCHECK --interval=60s --timeout=10s --start-period=30s CMD curl -s https://api.surfshark.com/v1/server/user | grep '"secured":true'

COPY app /app
RUN find /app/ovpn -name *.sh | xargs chmod u+x
RUN find /app -name run | xargs chmod u+x

CMD ["runsvdir", "/app"]
