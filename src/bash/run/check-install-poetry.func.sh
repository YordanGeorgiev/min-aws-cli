#!/bin/bash
# usage:
# the tgt dir MUST have pyproject.toml poetry file ...
# export TGT_DIR=/opt/min-aws-cli
# do_check_install_poetry
do_check_install_poetry(){

  TGT_DIR=${1:-}
  test -z ${TGT_DIR:-} && TGT_DIR=$PRODUCT_DIR
  cd $TGT_DIR
  test -d .venv && rm -r .venv
  python3 -m venv .venv && source .venv/bin/activate && \
  pip3 install --upgrade pip

  export POETRY_VERSION=1.1.7
  curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
  sudo ln -fns "$HOME/.poetry/bin/poetry" /usr/bin/poetry
  sudo chmod 700 /usr/bin/poetry
  poetry --version

}
