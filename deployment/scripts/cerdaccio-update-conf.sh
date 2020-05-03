SERVER_USER_NAME=[SERVER_USER_NAME]
PACKAGE_CONF_NAME=[PACKAGE_CONF_NAME]
DOC_PROJ_NAME=[DOC_PROJ_NAME]


set -x
set -e

rm -rf /home/${SERVER_USER_NAME}/verdaccio/conf
unzip -d /home/${SERVER_USER_NAME}/ /home/${SERVER_USER_NAME}/${PACKAGE_CONF_NAME}.zip

docker restart ${DOC_PROJ_NAME}

sleep 10s
docker logs ${DOC_PROJ_NAME}