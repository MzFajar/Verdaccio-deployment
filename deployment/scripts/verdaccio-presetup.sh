SERVER_USER_NAME=[SERVER_USER_NAME]
PACKAGE_CONF_NAME=[PACKAGE_CONF_NAME]

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

unzip -d /home/${SERVER_USER_NAME}/ /home/${SERVER_USER_NAME}/${PACKAGE_CONF_NAME}.zip