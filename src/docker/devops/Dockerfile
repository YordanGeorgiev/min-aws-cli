FROM python:3.8.3-alpine

ARG UID
ARG GID

ENV USR=appuser
ENV GRP=appgroup
ENV PS1='`date "+%F %T"` \u@\h  \w \n\n  '
ENV PRODUCT_DIR="/opt/dd-ams"
ENV EDITOR="vim"

VOLUME $PRODUCT_DIR


# install backend-utils
RUN apk update && apk upgrade && apk add --no-cache \
    bash libc6-compat zip unzip curl binutils libmagic cairo-dev pango-dev gdk-pixbuf ttf-freefont
# install OS utils
RUN apk update && apk upgrade && apk add --no-cache \
    vim perl jq curl wget busybox-extras su-exec sudo shadow

# start ::: adding OS user and group
# Enable host to container edit of proj code on ubuntu and mac.
RUN test -z $(getent group $GID | cut -d: -f1) || \
      groupmod -g $((GID+1000)) $(getent group $GID | cut -d: -f1)

# create a group and user
RUN set -x ; addgroup -g "$GID" -S "$GRP" && \
	adduser \
	--disabled-password \
	-g "$GID" \
	-D \
	-s "/bin/bash" \
	-h "/home/$USR" \
	-u "$UID" \
	-G "$GRP" "$USR" && exit 0 ; exit 1

RUN echo "$USR ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# start ::: awscli2
RUN apk add --no-cache \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli \
    && rm -rf /var/cache/apk/*

RUN aws --version
# stop  ::: awscli2

USER $USR
ADD --chown=$USR:$GRP "." "/home/$USR/$PRODUCT_DIR"
# stop ::: adding OS usr and group


WORKDIR $PRODUCT_DIR

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
