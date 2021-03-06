echo "User: ${TURN_USER}"
echo "Pass: ${TURN_PASS}"
echo "Realm: ${TURN_REALM}"
echo "Turn Server Args: '${TURN_ARGS}'"

turnadmin -a -u ${TURN_USER} -p "${TURN_PASS}" -r ${TURN_REALM}

CONFIG_FILE=/etc/turnserver/turnserver.conf

# Update config file with IP info
internalIp="$(ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')"
externalIp="$(dig +short myip.opendns.com @resolver1.opendns.com)"

echo "listening-ip=${internalIp}
relay-ip=${internalIp}
external-ip=${externalIp}

realm=${TURN_REALM}" >> ${CONFIG_FILE}

/usr/bin/turnserver -c ${CONFIG_FILE} ${TURN_ARGS}

