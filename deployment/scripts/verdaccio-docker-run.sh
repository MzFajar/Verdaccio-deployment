DOC_PROJ_NAME=[DOC_PROJ_NAME]
DOC_IMAGE_NAME=[DOC_IMAGE_NAME]
DOC_IMAGE_TAG=[DOC_IMAGE_TAG]
DOC_MNT_VOL=/home/[SERVER_USER_NAME]/
DOC_PUBISH_PORT=[DOC_PUBISH_PORT]
PACKAGE_IMAGE_NAME=[PACKAGE_IMAGE_NAME]
DOC_CUST_CMD="[DOC_CUST_CMD]"

set -x
docker stop ${DOC_PROJ_NAME}
docker rm ${DOC_PROJ_NAME}
docker rmi $(docker images |grep "${DOC_IMAGE_NAME}")

set -e
docker load --input ${PACKAGE_IMAGE_NAME}.tar

docker run -d --rm --name ${DOC_PROJ_NAME} \
  -v ${DOC_MNT_VOL}:/verdaccio \
  -p ${DOC_PUBISH_PORT}:4873 \
  --restart unless-stopped \
  ${DOC_CUST_CMD} ${DOC_IMAGE_NAME}:${DOC_IMAGE_TAG}

sleep 10s
docker logs ${DOC_PROJ_NAME}