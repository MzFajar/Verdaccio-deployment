if [ -z "$1" ]
then
	DOC_PROJ_NAME="verdaccio"
else
	DOC_PROJ_NAME=$1
fi

if [ -z "$2"]
then
  echo "Please supply Docker Image Name"
  exit 1
else
  DOC_IMAGE_NAME=$2
fi

if [ -z "$3"]
then
  echo "Please supply Docker Image Tag"
  exit 1
else
  DOC_IMAGE_TAG=$3
fi

if [ -z "$4"]
then
  echo "Please supply Server Username"
  exit 1
else
  DOC_MNT_VOL=/home/$4/
fi

if [ -z "$5"]
then
  DOC_PUBISH_PORT="4873"
else
  DOC_PUBISH_PORT=$5
fi

if [ -z "$6"]
then
  echo "Please supply Package Image Name"
  exit 1
else
  PACKAGE_IMAGE_NAME=$6
fi

DOC_CUST_CMD="$7"

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