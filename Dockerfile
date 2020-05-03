# DEFINE BASE IMAGE
ARG DOC_VERDACCIO_VER=4.6
FROM verdaccio/verdaccio:${DOC_VERDACCIO_VER}

# CUSTOM IMAGE
USER root
ENV NODE_ENV=production

# CUSTOM IMAGE / NPM Package
RUN npm i 
  # && npm install verdaccio-s3-storage

USER ${VERDACCIO_USER_NAME}