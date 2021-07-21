do_backup_db_snapshots(){

   dt=`date "+%Y%m%d-%H%M%S"`
	do_set_aws_region_n_profile ${ENV:-}

   aws rds describe-db-instances --profile $AWS_PROFILE --region $AWS_REGION | jq -r '.DBInstances[].DBInstanceIdentifier' | \
      while read -r db_instance ; do
      do_log "START attempt to backup the following db instance: $db_instance"
      export db_instance=$db_instance ;
      set -x
         aws rds create-db-snapshot --profile $AWS_PROFILE --region $AWS_REGION \
          --db-instance-identifier $db_instance \
          --db-snapshot-identifier $db_instance'-'$dt | jq '.'
      set -x
      sleep 2
      done

}
