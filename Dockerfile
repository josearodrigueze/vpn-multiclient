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
COPY app /app

RUN find /app -name *.sh | xargs chmod u+x && \
    find /app -name run | xargs chmod u+x

HEALTHCHECK --interval=60s --timeout=15s --start-period=20s CMD curl -sx localhost:8118 https://checkip.amazonaws.com | grep "\."
CMD ["runsvdir", "/app"]

