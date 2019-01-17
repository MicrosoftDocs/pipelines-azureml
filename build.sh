#!/bin/bash

# Set to your Azure Machine Learning workspace name
WORKSPACE='your-workspace'
RESOURCEGROUP='your-resource-group'
EXPERIMENT='myexperiment'

echo "Adding ML extension"
# Add the ML extension to the Azure CLI
az extension add -s https://azuremlsdktestpypi.blob.core.windows.net/wheels/sdk-release/Preview/E7501C02541B433786111FE8E140CAA1/azure_cli_ml-1.0.6-py2.py3-none-any.whl --pip-extra-index-urls https://azuremlsdktestpypi.azureedge.net/sdk-release/Preview/E7501C02541B433786111FE8E140CAA1 --yes

echo "training model"
# Train the model
az ml run submit -c myconfig train.py

echo "Get experiment history for this run"
az ml history last --experiment-name $EXPERIMENT -g $RESOURCEGROUP -w $WORKSPACE -o JSON > history.json

# Did the run fail?
STATUS=$(jq '.status' < history.json)
if [ "$STATUS" = "Failed" ]; then
    echo "Run failed"
    exit 1
fi
# If it didn't fail, continue

echo "Get the model name"
# Get the name of the 'best' model (lowest MCE)
# In this case, the train.py adds a 'best' element in the logs, which contains the model name
MODEL=$(jq -r '.best' < history.json)
echo $MODEL

echo "Get run ID"
# Get the run ID of the experiment from the history
RUNID=$(jq -r '.run_id' < history.json)
echo $RUNID

echo "Register the model"
# In this case, we register the model asset (output/$MODEL) of the 'best' model as 'mymodel.pkl'
# This is so the score.py can be hard coded to 'mymodel.pkl' instead of trying to dynamically add a model name to the score.py via pipeline
az ml run register-model --experiment-name $EXPERIMENT --model-name mymodel.pkl --model-path outputs/$MODEL --run $RUNID -w $WORKSPACE --output-metadata-file rmodel.json

# Create an image from the registered model
echo "Get model ID"
# This is a temporary workaround to get the model ID. Once fixed, we can skip this and use the commented out a ml image create that uses rmodel.json as input.
MODELID=$(jq -r '.modelId' < rmodel.json)

echo "Create and register the container image"
#az ml image create container --execution-script score.py --image-name myimage --runtime python -c runtime_dependencies.yml --model-metadata-file rmodel.json -w $WORKSPACE -g $RESOURCEGROUP --output-metadata-file rimage.json
az ml image create container --execution-script score.py --image-name myimage --runtime python -c runtime_dependencies.yml --model $MODELID -w $WORKSPACE -g $RESOURCEGROUP --output-metadata-file rimage.json

# Do we need to deploy a service, or update it?
# If the service name exists in the list of services, it exists.
SERVICE=$(az ml service list -g $RESOURCEGROUP -w $WORKSPACE | jq -r '.[] | select(.name == "myservice") | .name')
if [ "$SERVICE" = "myservice" ]; then
    # Service exists, update it
    echo "Update the web service"
    az ml service update aci --name myservice -g $RESOURCEGROUP -w $WORKSPACE --image-metadata-file rimage.json
else
    echo "Deploy the web service"
    # In a production scenario, you might want to create a release that uses approvers and gates to sign off on a publish. 
    # For more information, see https://docs.microsoft.com/en-us/azure/devops/pipelines/release/deploy-using-approvals?view=vsts
    az ml service create aci --name myservice -g $RESOURCEGROUP -w $WORKSPACE --image-metadata-file rimage.json
fi
