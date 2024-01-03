#!/bin/bash

if [[ -z "$YEAR" ]]; then
    echo "YEAR is not set"
    exit 1
fi

if [[ -z "$DAY" ]]; then
    echo "DAY is not set"
    exit 1
fi

if [[ -z "$SESSION" ]]; then
    echo "SESSION is not set"
    exit 1
fi

if [[ -z "$1" ]]; then
    echo "Please pass output file as first arg"
    exit 2
fi

curl "https://adventofcode.com/$YEAR/day/$DAY/input" \
    --compressed -A 'https://github.com/paciops/AdventOfCode' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' \
    -H "Cookie: session=$SESSION" \
    -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-origin' \
    -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Sec-GPC: 1' -H 'TE: trailers' > $1