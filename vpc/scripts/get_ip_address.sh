#!/bin/bash
URL="ipinfo.io/ip"
IP_ADDRESS=$(curl $URL)

jq -n --arg ip_address "$IP_ADDRESS" \
      --arg url "$URL" \
      '{"ip_address":$ip_address, "provider_url":$url}'
