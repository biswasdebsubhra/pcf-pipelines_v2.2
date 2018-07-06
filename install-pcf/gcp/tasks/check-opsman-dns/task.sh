#!/bin/bash
set -e

function check_opsman_available {
  local opsman_domain=$1

  if [[ -z $(dig +short $opsman_domain) ]]; then
    echo "unavailable"
    return
  fi

  status_code=$(curl -L -s -o /dev/null -w "%{http_code}" -k "https://${opsman_domain}/login/ensure_availability")
  if [[ $status_code != 200 ]]; then
    echo "unavailable"
    return
  fi

  echo "available"
}

opsman_available=$(check_opsman_available "${OPSMAN_DOMAIN_OR_IP_ADDRESS}")
if [[ $opsman_available != "available" ]]; then
  echo Could not reach ${OPSMAN_DOMAIN_OR_IP_ADDRESS}. Is DNS set up correctly?
  exit 1
fi
