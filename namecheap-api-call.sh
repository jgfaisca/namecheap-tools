#!/bin/bash
#######################################################################################
# 
# Script to programmatically call namecheap API. You need to change API_USER,
# API_KEY and USER_NAME. API Response is saved on /tmp/response.xml
# 
# API documentation:
# https://www.namecheap.com/support/api/intro.aspx
#
# dependencies: 
# - add curl and dig
# - a working internet connection
#
# usage:
# ./namecheap-api-call.sh <--production|--sandbox> '<command>'
#
#  --production   set API production server environment   
#  --sandbox      set API test server environment 
#    command      API command for execution
# 
# example:
# Gets a list of DNS servers associated with the requested domain using sandbox
# ./namecheap-api-call.sh --sandbox 'namecheap.domains.dns.getList&SLD=domain&TLD=com'    
#
# authors: 
# Jose G. Faisca <jose.faisca@gmail.com>>
#
#######################################################################################

# Help function
function show_help() {
   echo
   echo "Usage:"
   echo "./$(basename "$0") <--production|--sandbox> '<command>'"
   echo
   echo "   --production   set API production server environment"   
   echo "   --sandbox      set API test server environment" 
   echo "     command      API command for execution"
   echo
   echo "Example:"
   echo "Gets a list of DNS servers associated with the requested domain using sandbox"
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

# Verify curl command
curl --version >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "curl is not being recognized as a command; please install"
  exit 1
fi

# Verify dig command
dig -version >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "dig is not being recognized as a command; please install"
  exit 1
fi

# API request parameters
API_USER="user"         # Username required to access the API
API_KEY="key"           # Password required used to access the API
USER_NAME="user"        # The Username on which a command is executed
CLIENT_IP=$(myIP)       # IP address of the client accessing your application
API_COMMAND="$2"        # Command for execution

# API production server environment URL
URL_PRODUCTION="https://api.namecheap.com/xml.response"

# API test server environment URL
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
