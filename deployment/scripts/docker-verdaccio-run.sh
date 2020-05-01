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
  DOC_MNT_VOL=/home/$3/
fi

if [ -z "$5"]
then
  DOC_PUBISH_PORT="4873"
else
  DOC_PUBISH_PORT=$5
fi

DOC_CUST_CMD="$6"

set -e
docker run -d --rm --name ${DOC_PROJ_NAME} \
  -v ${DOC_MNT_VOL}:/verdaccio \
  -p ${DOC_PUBISH_PORT}:4873 \
  --restart unless-stopped \
  ${DOC_CUST_CMD} ${DOC_IMAGE_NAME}:${DOC_IMAGE_TAG}

sleep 10s
docker logs ${DOC_PROJ_NAME}