#------------------------------------------------------------------------------
# usage example:
# source $PRODUCT_DIR/lib/bash/funcs/set-aws-env.func.sh
# do_set_aws_env dev
# do_set_aws_env tst
# do_set_aws_env stg
# do_set_aws_env prd
#------------------------------------------------------------------------------
do_set_aws_env(){

   ENV=${1:-}
   test -z ${ENV:-} && echo "run export ENV={dev,tst,stg,prd} in your shell !!!" && exit 1

   test $ENV == dev && export AWS_PROFILE='dev_org_profile'
   test $ENV == dev && export AWS_REGION='eu-central-1'

   test $ENV == tst && export AWS_PROFILE='stg_org_profile'
   test $ENV == tst && export AWS_REGION='us-east-1'

   test $ENV == stg && export AWS_PROFILE='stg_org_profile'
   test $ENV == stg && export AWS_REGION='us-east-1'

   test $ENV == prd && export AWS_PROFILE='prd_org_profile'
   test $ENV == prd && export AWS_REGION='us-east-1'

}
