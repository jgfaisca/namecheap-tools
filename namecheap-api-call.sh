#!/bin/bash
#
# Programmatically call namecheap API. You need to change API_USER,
# API_KEY and USER_NAME. API Response is saved on /tmp/response.xml
#
# Author: Jose G. Faisca <jose.faisca@gmail.com>>
#

# Help function
function show_help() {
   echo
   echo "Usage:"
   echo "./$(basename "$0") <--production|--sandbox> '<command for execution>'"
   echo
   echo "Example:"
   echo "Gets a list of DNS servers associated with the requested domain using API sandbox"
   echo "./$(basename "$0") --sandbox 'namecheap.domains.dns.getList&SLD=domain&TLD=com'"
   echo
   exit 1
}

# Function to get end-user IP address
function myIP(){
    dig +short myip.opendns.com @resolver1.opendns.com
}

# Verify arguments
[ $# != 2 ] && show_help

# API request parameters
API_USER="user"         # Username required to access the API
API_KEY="key"           # Password required used to access the API
USER_NAME="user"        # The Username on which a command is executed
CLIENT_IP=$(myIP)       # IP address of the client accessing your application
API_COMMAND="$2"        # Command for execution

# API production server environment
URL_PRODUCTION="https://api.namecheap.com/xml.response"

# API test server environment
URL_SANDBOX="https://api.sandbox.namecheap.com/xml.response"

# Set API environment URL
case "$1" in
  --production)
      URL_DEFAULT="$URL_PRODUCTION"
      shift
      ;;
  --sandbox)
      URL_DEFAULT="$URL_SANDBOX"
      shift
      ;;
  *)
      show_help
      ;;
esac

# Verify curl command
curl --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "curl is not being recognized as a command; please install "
fi

# Verify dig command
dig -version >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "dig is not being recognized as a command; please install "
fi

# API call
REQUEST="curl --verbose '${URL_DEFAULT}?\
ApiUser=${API_USER}&\
ApiKey=${API_KEY}&\
UserName=${USER_NAME}&\
ClientIp=${CLIENT_IP}&\
Command=${API_COMMAND}'"
echo
echo $REQUEST
echo
eval $REQUEST > /tmp/response.xml
cat /tmp/response.xml

exit 0
