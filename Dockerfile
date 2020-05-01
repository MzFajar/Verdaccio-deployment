# DEFINE BASE IMAGE
ARG DOC_VERDACCIO_VER=4.6
FROM verdaccio/verdaccio:${DOC_VERDACCIO_VER}

# CUSTOM IMAGE
USER root
ENV NODE_ENV=production


# CUSTOM IMAGE / NPM Package
RUN npm i 
  # && npm install verdaccio-s3-storage

# CUSTOM IMAGE / User
ARG VERDACCIO_USER_NAME
ARG VERDACCIO_USER_UID

RUN echo ${VERDACCIO_USER_NAME} \
    && echo ${VERDACCIO_USER_UID}
RUN grep 1000 /etc/passwd

RUN adduser -u $VERDACCIO_USER_UID -S -D -h $VERDACCIO_APPDIR -g "$VERDACCIO_USER_NAME user" -s /sbin/nologin $VERDACCIO_USER_NAME && \
    chmod -R +x $VERDACCIO_APPDIR/bin $VERDACCIO_APPDIR/docker-bin && \
    chown -R $VERDACCIO_USER_UID:root /verdaccio/storage && \
    chmod -R g=u /verdaccio/storage /etc/passwd

USER ${VERDACCIO_USER_NAME}