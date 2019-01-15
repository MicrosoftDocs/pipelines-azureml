# Set to your Azure Machine Learning workspace name
WORKSPACE='ldfml'
RESOURCEGROUP='larrygroup0102'
EXPERIMENT='train-model'

echo "Adding ML extension"
az extension add -s https://azuremlsdktestpypi.blob.core.windows.net/wheels/sdk-release/Preview/E7501C02541B433786111FE8E140CAA1/azure_cli_ml-0.1.68-py2.py3-none-any.whl --pip-extra-index-urls  https://azuremlsdktestpypi.azureedge.net/sdk-release/Preview/E7501C02541B433786111FE8E140CAA1 --yes

echo "training model"
az ml run submit -c mybai --verbose train.py > output.txt

# To query the status, you can use the following and then compare for 'Completed' to verify if training finished
# az ml history last --experiment-name train-on-amlcompute -g groupname -w workspace --query status

# This returns the name of the model with the best (lowest) MSE
$MODEL=$(az ml history last --experiment-name $EXPERIMENT -g $RESOURCEGROUP -w $WORKSPACE --query best)
# The run ID of the experiment
$RUNID=$(az ml history last --experiment-name $EXPERIMENT -g $RESOURCEGROUP -w $WORKSPACE --query run_id)

# Register the best model
az ml run register-model --experiment-name $EXPERIMENT --model-name $MODEL --run $RUNID -w $WORKSPACE --output-metadata-file rmodel.json
# Create an image from the registered model


