#!/bin/bash

#
# Copyright (C) 2026 Nethesis S.r.l.
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Log in to the SOGo web interface, then print the INBOX listing as JSON.

set -e

url=${1:?missing url}
user=${2:?missing user}
password=${3:?missing password}

jar=$(mktemp)
trap 'rm -f "${jar}"' EXIT

curl -sS -f -o /dev/null -c "${jar}" \
    -H 'Content-Type: application/json' \
    -d "{\"userName\":\"${user}\",\"password\":\"${password}\"}" \
    "${url}/SOGo/connect"

# Sent by hand: curl would hold back a cookie flagged Secure on plain http.
cookies=$(awk -F'\t' 'NF==7 {printf "%s=%s; ", $6, $7}' "${jar}")
token=$(awk -F'\t' '$6=="XSRF-TOKEN" {print $7}' "${jar}")
if [[ -z "${token}" ]]; then
    echo "no XSRF-TOKEN cookie after the login" >&2
    exit 1
fi

curl -sS -f \
    -H "Cookie: ${cookies}" \
    -H "X-XSRF-TOKEN: ${token}" \
    -H 'Content-Type: application/json' \
    -d '{"sortingAttributes":{"sort":"arrival","asc":false}}' \
    "${url}/SOGo/so/${user}/Mail/0/folderINBOX/view"
