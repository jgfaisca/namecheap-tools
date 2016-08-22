
#!/bin/bash
########################################################################################
#
# Serve namecheap API response via HTTP
#
# # dependencies:
# - add python
#
# usage:
# ./response-http.sh
#
# example:
# Using curl command to get response.xml
# curl http://localhost:8000/response.xml
#
# authors:
# Jose G. Faisca <jose.faisca@gmail.com>
#
########################################################################################

RESPONSE_DIR="/tmp/namecheap/"
PORT=8000

# Verify python command
python --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "python is not being recognized as a command; please install"
  exit 1
fi

# Run HTTP server
pushd $RESPONSE_DIR; python -m SimpleHTTPServer $PORT; popd
