#!/bin/bash

if [[ -z "${USER}" ]]
then
	echo "No user was set. Use -u=username"
	exit 10
else
  USER=${USER}
fi

if [[ -z "${PASSWORD}" ]]
then
	echo "No password was set. Use -p=password"
	exit 20
else
  PASSWORD=${PASSWORD}
fi

if [[ -z "${HOSTNAME}" ]]
then
	echo "No host name. Use -h=host.example.com"
	exit 30
else
  HOSTNAME=${HOSTNAME}
fi

if [[ -z "${SERVICE}" ]]
then
	SERVICE="noip"
else
  SERVICE=${SERVICE}
fi

if [[ -n "${DETECTIP}" ]]
then
	IP=$(wget -qO- "http://myexternalip.com/raw")
else
  DETECTIP=${DETECTIP}
fi

if [[ -n "${DETECTIP}" ]] && [[ -z ${IP} ]]
then
	RESULT="Could not detect external IP."
fi

if [[ ${INTERVAL} != [0-9]* ]]
then
	echo "Interval is not an integer."
	exit 35
else
  INTERVAL=${INTERVAL}
fi

SERVICEURL="dynupdate.no-ip.com/nic/update"
NOIPURL="https://${USER}:${PASSWORD}@"

case "${SERVICE}" in
  noip)
    SERVICEURL="dynupdate.no-ip.com/nic/update"
    ;;

  dyndns)
    SERVICEURL="members.dyndns.org/v3/update"
    ;;

  duckdns)
    SERVICEURL="www.duckdns.org/v3/update"
    ;;

	google)
    SERVICEURL="domains.google.com/nic/update"
    ;;

	dynudns)
    SERVICEURL="api.dynu.com/nic/update"
    NOIPURL="https://"
    ;;

  *)
		SERVICEURL="dynupdate.no-ip.com/nic/update"
esac

USERAGENT="--user-agent=\"no-ip shell script/1.0 mail@mail.com\""
BASE64AUTH=$(echo -n "${USER}:${PASSWORD}" | base64)
AUTHHEADER="--header=\"Authorization: ${BASE64AUTH}\""

NOIPURL="${NOIPURL}${SERVICEURL}"

if [[ -n "${IP}" ]] || [[ -n "${HOSTNAME}" ]] || [[ ${SERVICE} == "dynudns" ]]
then
	NOIPURL="${NOIPURL}?"
fi

if [[ -n "${HOSTNAME}" ]]
then
	NOIPURL="${NOIPURL}hostname=${HOSTNAME}"
fi

if [[ ${SERVICE} == "dynudns" ]]
then
	if [[ -n "${HOSTNAME}" ]]
	then
		NOIPURL="${NOIPURL}&"
	fi
	SHA256PASSWORD=$(printf "%s" "${PASSWORD}" | sha256sum | cut -d " " -f 1)
	NOIPURL="${NOIPURL}username=${USER}&password=${SHA256PASSWORD}"
fi

while :
do

  if [[ -n "${HOSTNAME}" ]] || [[ ${SERVICE} == "dynudns" ]]
  then
    TEMPURL="${NOIPURL}&"
  fi
  IP=$(wget -qO- "http://myexternalip.com/raw")
  TEMPURL="${NOIPURL}myip=$IP"

  if [[ ${SERVICE} == "dynudns" ]]
  then
    echo "${TEMPURL}"
    RESULT=$(wget --no-check-certificate -qO- ${TEMPURL})
  else
    echo "${AUTHHEADER} ${USERAGENT} ${TEMPURL}"
    RESULT=$(wget --no-check-certificate -qO- "${AUTHHEADER} ${USERAGENT} ${TEMPURL}")
  fi

	echo "${RESULT}"

	if [[ ${INTERVAL} -eq 0 ]]
	then
		break
	else
		sleep "${INTERVAL}m"
	fi

done

exit 0
