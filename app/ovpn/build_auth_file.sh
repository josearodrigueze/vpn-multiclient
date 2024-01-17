#!/bin/sh

# echo "Running build_auth_file.sh"
# build auth-file
AUTH_FILE=.auth.txt

printf "%s\n%s" "${OVPN_USER}" "${OVPN_PASSWORD}" > $AUTH_FILE
chmod 0600 $AUTH_FILE

echo "$AUTH_FILE"
