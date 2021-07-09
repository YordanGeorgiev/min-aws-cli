#Makefile

SHELL  := /bin/bash

default: help

.PHONY: help  ## @-> show this help  the default action
help:
	@clear
	@fgrep -h "##" $(MAKEFILE_LIST)|fgrep -v fgrep|sed -e 's/^\.PHONY: //'|sed -e 's/^\(.*\)##/\1/'|column -t -s $$'@'

.PHONY: install ## @-> setup the whole environment to run this proj
install: do_build_devops_docker_image do_create_container

.PHONY: install_no_cache ## @-> setup the whole environment to run this proj, do NOT use docker cache
install_no_cache: do_build_devops_docker_image_no_cache do_create_container

.PHONY: run ## @-> run some function , in this case hello world
run:
	./run -a do_run_hello_world

.PHONY: do_run ## @-> run some function , in this case hello world
do_run:
	docker exec -it proj-con ./run -a do_run_hello_world

.PHONY: do_build_devops_docker_image ## @-> build the devops docker image
do_build_devops_docker_image:
	docker build . -t proj-img --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) -f src/docker/devops/Dockerfile

.PHONY: do_build_devops_docker_image_no_cache ## @-> build the devops docker image
do_build_devops_docker_image_no_cache:
	docker build . -t proj-img --no-cache --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) -f src/docker/devops/Dockerfile

.PHONY: do_create_container ## @-> create a new container our of the build img
do_create_container:
	-docker container stop $$(docker ps -aqf "name=proj-con"); docker container rm $$(docker ps -aqf "name=proj-con")
	docker run -d -v $$(pwd):/opt/min-aws-cli \
	-v $$HOME/.aws:/home/appuser/.aws \
   	-v $$HOME/.ssh:/home/appuser/.ssh \
		--name proj-con proj-img ;
	@echo -e to attach run: "\ndocker exec -it proj-con /bin/bash"
	@echo -e to get help run: "\ndocker exec -it proj-con ./run --help"

.PHONY: stop_container ## @-> stop the devops running container
stop_container:
	docker container stop $$(docker ps -aqf "name=proj-con"); docker container rm $$(docker ps -aqf "name=proj-con")

.PHONY: zip_me ## @-> zip the whole project without the .git dir
zip_me:
	-rm -v ../min-aws-cli.zip ; zip -r ../min-aws-cli.zip  . -x '*.git*'

demand_var-%:
	@if [ "${${*}}" = "" ]; then \
		echo "the var \"$*\" is not set in the shell!!! Do set it by: export $*='value'"; \
		exit 1; \
	fi

task_which_requires_a_var: demand_var-ENV ## @-> test how-to pass a shell var to this Makefile
	@echo ${ENV}

.PHONY: spawn_tgt_project ## @-> spawn a new target project
spawn_tgt_project: demand_var-TGT_PROJ zip_me
	-rm -r $(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ)
	unzip -o ../min-aws-cli.zip -d $(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ)
	to_srch=min-aws-cli to_repl=$(shell echo $$TGT_PROJ) dir_to_morph=$(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ) ./run -a do_morph_dir

.PHONY: do_prune_docker_system ## @-> stop & completely wipe out all the docker caches for ALL IMAGES !!!
do_prune_docker_system:
	-docker kill $$(docker ps -q) ; -docker rm $(docker ps -a -q)
	docker builder prune -f --all ; docker system prune -f
