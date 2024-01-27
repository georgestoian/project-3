#!/bin/bash

# DEPLOY_INCREMENTS=2

# function manual_verification {
#   read -p "Continue deployment? (y/n) " answer

#     if [[ $answer =~ ^[Yy]$ ]] ;
#     then
#         echo "continuing deployment"
#     else
#         exit
#     fi
# }

function green_deploy {
  kubectl apply -f green.yml
  # Check deployment rollout status every 1 second until complete.
  ATTEMPTS=0
  ROLLOUT_STATUS_CMD="kubectl rollout status deployment/green -n udacity"
  until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
    $ROLLOUT_STATUS_CMD
    ATTEMPTS=$((attempts + 1))
    sleep 1
  done
  SERVICE_STATUS_CMD=$(kubectl get svc | grep green | awk '{print $4}')
  CURL_STATUS_CMD="curl ${SERVICE_STATUS_CMD}"
  until $CURL_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
    $CURL_STATUS_CMD
    ATTEMPTS=$((attempts + 1))
    sleep 1
  done
  echo "GREEN deployment successful!"
}

sleep 1
# Begin canary deployment
# while [ $(kubectl get pods -n udacity | grep -c canary-v1) -gt 0 ]
# do
green_deploy
#   manual_verification
# done
