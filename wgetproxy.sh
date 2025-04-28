#!/bin/sh
# wgetproxy: Transparently rewrite http:// and https:// URLs to a local proxy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

PROXY_HOST=192.168.1.80
PROXY_PORT=8081

URL="$1"
shift

# Force http:// URLs to https://
case "$URL" in
  http://*)
    URL=`echo "$URL" | sed 's|^http://|https://|'`
    ;;
esac

case "$URL" in
  https://*)
    TARGET=`echo "$URL" | sed 's|^https://||'`
    exec wget.bin "http://$PROXY_HOST:$PROXY_PORT/https/$TARGET" "$@"
    ;;
  *)
    exec wget.bin "$URL" "$@"
    ;;
esac
