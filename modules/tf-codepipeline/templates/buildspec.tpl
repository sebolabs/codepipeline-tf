version: 0.2

env:
  variables:
    TF_PLAN_NAME: ${tfscaffold_output_plan_name}
    TF_DEPLOYER_ROLE_ARN: ${tfscaffold_deployer_role_arn}
    TF_CLI_ARGS: "-no-color"
  exported-variables:
    - TF_CLI_ARGS

phases:
  pre_build:
    commands:
      - echo '[INFO] Assuming TF Deployer IAM role...'
      - TF_DEPLOYER_ROLE=`aws sts assume-role --role-arn $${TF_DEPLOYER_ROLE_ARN} --role-session-name $${TF_PLAN_NAME}`
      - export AWS_ACCESS_KEY_ID=`echo "$${TF_DEPLOYER_ROLE}" | jq -r '.Credentials.AccessKeyId'`
      - export AWS_SECRET_ACCESS_KEY=`echo "$${TF_DEPLOYER_ROLE}" | jq -r '.Credentials.SecretAccessKey'`
      - export AWS_SESSION_TOKEN=`echo "$${TF_DEPLOYER_ROLE}" | jq -r '.Credentials.SessionToken'`
      - echo '[INFO] Gathering environment information...'
      - bash /opt/tf-bash.sh
      - echo '[INFO] Collecting artifacts...'
      - if [ $${TF_ACTION} == "apply" ]; then cp $${CODEBUILD_SRC_DIR_TerraformPlanArtifacts}/* /opt/; fi
  build:
    commands:
      - echo "[INFO] Running TFScaffold $${TF_ACTION}..."
      - ./bin/terraform.sh -p $${TF_PROJECT} -e $${TF_ENVIRONMENT} -c $${TF_COMPONENT} -b $${TF_STATE_BUCKET} -r $${AWS_REGION} -a $${TF_ACTION} -o /opt/$${TF_PLAN_NAME}.plan
  post_build:
    commands:
      - echo "[INFO] TFScaffold $${TF_ACTION} run successfully."

artifacts:
  files:
    - $${TF_PLAN_NAME}.plan
  name: TerraformPlanArtifacts
  discard-paths: no
  base-directory: /opt
