#!/bin/bash
########################################################################################
#
# One shot namecheap API response via HTTP using Netcat. Netcat only serves the
# response file once to the first client that connects and then exits.
#
# # dependencies:
# - netcat
#
# usage:
# ./oneshot-response-http.sh
#
# example:
# Using curl command to get response.xml
# curl http://localhost:8000/response.xml
#
# authors:
# Jose G. Faisca <jose.faisca@gmail.com>
#
########################################################################################

RESPONSE_DIR="/tmp/namecheap"
PORT=8000

# Verify netcat command
nc -h >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "nc (Netcat) is not being recognized as a command; please install"
  exit 1
fi

# Run netcat
{ echo -ne "HTTP/1.0 200 OK\r\n\r\n"; cat $RESPONSE_DIR/response.xml; } | nc -l -p $PORT
