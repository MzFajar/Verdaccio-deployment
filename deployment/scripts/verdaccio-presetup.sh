if [ -z "$1"]
then
  echo "Please supply Server Username"
  exit 1
else
  SERVER_USER_NAME=$1
fi

if [ -z "$2"]
then
  echo "Please supply Package Configutaion Name"
  exit 1
else
  PACKAGE_CONF_NAME=$1
fi

set -x
set -e

if [ -d "/home/${SERVER_USER_NAME}/verdaccio" ] 
then
  echo "Verdaccio has been Setuped!"

  rm -rf /home/${SERVER_USER_NAME}/verdaccio/conf
  rm -rf /home/${SERVER_USER_NAME}/verdaccio/log
else 
  mkdir /home/${SERVER_USER_NAME}/verdaccio
  mkdir /home/${SERVER_USER_NAME}/verdaccio/storage
  mkdir /home/${SERVER_USER_NAME}/verdaccio/plugins
  mkdir /home/${SERVER_USER_NAME}/verdaccio/log

  sudo chown -R ${SERVER_USER_NAME}:65533 /home/${SERVER_USER_NAME}/verdaccio
fi

unzip -d /home/${SERVER_USER_NAME}/verdaccio/ /home/${SERVER_USER_NAME}/${PACKAGE_CONF_NAME}.zip