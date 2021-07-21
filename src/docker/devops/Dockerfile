FROM python:3.8.3-alpine

ARG UID
ARG GID

ENV USER=appuser
ENV GROUP=appgroup
ENV PS1='`date "+%F %T"` \u@\h  \w \n\n  '
ENV PRODUCT_DIR="/opt/min-aws-cli"
ENV EDITOR="vim"
ENV ENV=dev

VOLUME $PRODUCT_DIR

# install backend-utils
RUN apk update && apk upgrade && apk add --no-cache \
    bash libc6-compat zip git unzip curl binutils libmagic cairo-dev pango-dev gdk-pixbuf ttf-freefont

# install OS utils
RUN apk update && apk upgrade && apk add --no-cache \
    vim perl jq curl wget busybox-extras su-exec sudo shadow

# start ::: awscli
RUN apk add --no-cache \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli \
    && rm -rf /var/cache/apk/*

RUN aws --version
# stop  ::: awscli1

# start ::: adding OS user and group
# Enable host to container edit of proj code on ubuntu and mac.
RUN test -z $(getent group $GID | cut -d: -f1) || \
    groupmod -g $((GID+1000)) $(getent group $GID | cut -d: -f1)

# create a group and user
RUN set -x ; addgroup -g "$GID" -S "$GROUP" && \
  adduser \
  --disabled-password \
  -g "$GID" \
  -D \
  -s "/bin/bash" \
  -h "/home/$USER" \
  -u "$UID" \
  -G "$GROUP" "$USER" && exit 0 ; exit 1

RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USER
ADD --chown=$USER:$GROUP "." "/home/$USER/$PRODUCT_DIR"
# stop ::: adding OS USER and group


# Install poetry
RUN bash /home/$USER/$PRODUCT_DIR/run -a do_check_install_poetry

# start ::: install prowler
RUN bash /home/$USER/$PRODUCT_DIR/run -a do_check_install_prowler
# stop  ::: install prowler

# Install terraform
RUN bash /home/$USER/$PRODUCT_DIR/run -a do_check_install_terraform

# Install checkov
RUN bash /home/$USER/$PRODUCT_DIR/run -a do_check_install_checkov

WORKDIR $PRODUCT_DIR

CMD exec /bin/bash -c "./run -a do_check_install_python_modules ; trap : TERM INT; sleep infinity & wait"
