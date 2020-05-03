DOC_PROJ_NAME=[DOC_PROJ_NAME]
DOC_IMAGE_NAME=[DOC_IMAGE_NAME]
DOC_IMAGE_TAG=[DOC_IMAGE_TAG]
DOC_MNT_VOL=/home/[SERVER_USER_NAME]/verdaccio
DOC_MNT_VOL_CONF=/conf
DOC_MNT_VOL_LOG=/log
DOC_MNT_VOL_STOR=/storage
DOC_MNT_VOL_WEB=/web
DOC_MNT_VOL_PLUG=/plugins
DOC_PUBISH_PORT=[DOC_PUBISH_PORT]
PACKAGE_IMAGE_NAME=[PACKAGE_IMAGE_NAME]
DOC_CUST_CMD="[DOC_CUST_CMD]"

set -x
docker stop ${DOC_PROJ_NAME}
docker rm ${DOC_PROJ_NAME}
docker rmi $(docker images |grep "${DOC_IMAGE_NAME}")

set -e
docker load --input ${PACKAGE_IMAGE_NAME}.tar

docker run -d --name ${DOC_PROJ_NAME} \
  -v ${DOC_MNT_VOL}${DOC_MNT_VOL_CONF}:/verdaccio/conf \
  -v ${DOC_MNT_VOL}${DOC_MNT_VOL_LOG}:/verdaccio/log \
  -v ${DOC_MNT_VOL}${DOC_MNT_VOL_PLUG}:/verdaccio/plugins \
  -v ${DOC_MNT_VOL}${DOC_MNT_VOL_STOR}:/verdaccio/storage \
  -v ${DOC_MNT_VOL}${DOC_MNT_VOL_WEB}:/verdaccio/web \
  -p ${DOC_PUBISH_PORT}:4873 \
  --restart unless-stopped \
  ${DOC_CUST_CMD} ${DOC_IMAGE_NAME}:${DOC_IMAGE_TAG}

sleep 10s
docker logs ${DOC_PROJ_NAME}
