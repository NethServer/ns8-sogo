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

headers=$(mktemp)
trap 'rm -f "${headers}"' EXIT

curl -sS -f -o /dev/null -D "${headers}" \
    -H 'Content-Type: application/json' \
    -d "{\"userName\":\"${user}\",\"password\":\"${password}\"}" \
    "${url}/SOGo/connect"

# Read from the headers: the session cookie is flagged Secure, and an old curl
# drops it from its cookie jar on plain http.
cookies=$(tr -d '\r' < "${headers}" | sed -n 's/^[Ss]et-[Cc]ookie: *\([^;]*\).*/\1/p' | paste -sd ';' | sed 's/;/; /g')
token=$(tr -d '\r' < "${headers}" | sed -n 's/^[Ss]et-[Cc]ookie: *XSRF-TOKEN=\([^;]*\).*/\1/p')
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
