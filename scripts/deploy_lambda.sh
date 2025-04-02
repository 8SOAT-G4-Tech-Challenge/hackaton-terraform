#!/bin/bash
base_folder="$(dirname "$(pwd)")/lambdas"

# Arquivo para subir lambdas manualmente quando houver alteração no código node da lambda

folders=$(find "$base_folder" -mindepth 1 -maxdepth 1 -type d)

for folder in $folders;
do
  echo "Deploying $folder..."
  
  cd "$folder" || { echo "Failed to enter $folder"; exit 1; }
  folder_name=$(basename "$folder") 

  if aws lambda create-function --function-name cognito-$folder_name-lambda --runtime nodejs18.x --handler index.handler --role arn:aws:iam::$AWS_ACCOUNT_ID:role/LabRole --zip-file fileb://$folder/lambda.zip --no-cli-pager; then
    echo "Lambda deployed for $folder"
  elif aws lambda update-function-code --function-name cognito-$folder_name-lambda --zip-file fileb://$folder/lambda.zip --no-cli-pager; then
    echo "Lambda update completed for $folder"
  else 
    echo "Deployment failed for $folder"
    exit 1;
  fi
  
  cd ../..
done

echo "Deploy completed!"