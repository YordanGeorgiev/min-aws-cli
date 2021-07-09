# MIN-AWS-CLI
A minimalistic alpine Docker based project to demonstrate aws cli usage

## PREREQUISITES
Bash, make, docker. Winblows not tested ... Runs via docker or natively on Ubuntu 20.04 or alpine

## USAGE
Check the usage
```bash
make
```
, which is the same as
```bash
make help
```
and ran natively without the docker
```bash
./run --help
```

## INSTALL
Build the ubuntu 20.04 image, init the container and show the help from the deploy script
```bash
make install
```
use the _no_cache suffix if you did changes to the Dockerfile
```bash
make install_no_cache
```
If you happen to be on Ubuntu 20.04 you should be able to run natively



## HOW-TO ADD A NEW FUNC
Just copy the hello-world.func.sh file into the new func file ...
```bash
  cp -v src/bash/run/ubuntu/ubuntu-20.04.2-lts/run-hello-world.func.sh \
		src/bash/run/ubuntu/ubuntu-20.04.2-lts/run-my-thingy.func.sh
'src/bash/run/ubuntu/ubuntu-20.04.2-lts/run-hello-world.func.sh' -> 'src/bash/run/ubuntu/ubuntu-20.04.2-lts/run-my-thingy.func.sh'
```
Than change in the run-my-thingy.func.sh the function name to do_run_my_thingy for the "magic" in run.sh to know how-to pick it ...



## SPAWN !!!
This one is for advanced students only ...
To spawn this whole project into YOUR thingy do:
```bash
TGT_PROJ=thingy make spawn_tgt_project
```
