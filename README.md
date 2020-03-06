# Introduction 

This repo shows an E2E training and deployment pipeline with Azure Machine Learning's CLI for implementing MLOps. For more info, please visit [https://docs.microsoft.com/azure/machine-learning/service/reference-azure-machine-learning-cli](Azure Machine Learning CLI documentation).

Install the Machine Learning DevOps extension in your project [from here](https://marketplace.visualstudio.com/items?itemName=ms-air-aiagility.vss-services-azureml) to scope your project to your Azure Machine Learning service workspace. 

# How it works

## Declare variables for CI/CD pipeline
 - ml-ws-connection: 'azmldemows' # Workspace Service Connection name
 - ml-ws: 'aml-demo' # AML Workspace name
 - ml-rg: 'aml-demo' # AML resource Group name
 - ml-ct: 'cpu-cluster-1' # AML Compute cluster name
 - ml-path: 'models/diabetes' # Model directory path in repo
 - ml-exp: 'exp-test' # Experiment name
 - ml-model-name: 'diabetes-model' # Model name
 - ml-aks-name: 'aks-prod' # AKS cluster name

## Run CLI scripts to create training compute, train model, register model, deploy model
```cli
    inlineScript: 'az extension add -n azure-cli-ml'
    inlineScript: 'az ml folder attach -w $(ml-ws) -g $(ml-rg)'
    inlineScript: 'az ml computetarget create amlcompute -n $(ml-ct) --vm-size STANDARD_D2_V2 --max-nodes 1'
    inlineScript: 'az ml run submit-script -c config/train --ct $(ml-ct) -e $(ml-exp) -t run.json train.py'
    inlineScript: 'az ml model register -n $(ml-model-name) -f run.json --asset-path outputs/ridge_0.95.pkl -t model.json'
    inlineScript: 'az ml model deploy -n diabetes-qa-aci -f model.json --ic config/inference-config.yml --dc config/deployment-config-aci.yml --overwrite'
    inlineScript: 'az ml computetarget create aks --name $(ml-aks-name) --cluster-purpose DevTest'
    inlineScript: 'az ml model deploy --name diabetes-prod-aks --ct $(ml-aks-name) -f model.json --ic config/inference-config.yml --dc config/deployment-config-aks.yml  --overwrite'
```

# How to use

This example requires familiarity with Azure Pipelines or GitHub Actions. For more information, see [this link](https://docs.microsoft.com/azure/devops/pipelines/create-first-pipeline?view=azure-devops&tabs=tfs-2018-2).

This example also requires an Azure Machine Learning service workspace. For more information, see [this introduction](https://docs.microsoft.com/azure/machine-learning/service/setup-create-workspace).

You can clone/fork this repo and use it with Azure Pipelines. Before creating the pipeline you must do the following:

1. Create a new project in Azure DevOps/Pipelines
1. Goto `Project settings`, select `Service connections`, create a new connection of type `Azure Resource Manager`, select `Service principal (automatic)` and configure it to the `Machine Learning Workspace`. Name it `azmldemows` and point it to your Azure Machine Learning workspace (see [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops) for more details)
1. Modify the `pipelines/diabetes-train-and-deploy.yml` and change the `ml-rg` variable to the Azure resource group that contains your workspace. You must also change the `ml-ws` variable to the name of your Azure Machine Learning service workspace.
<img src="docs/service_connection.png" width="250px" />
1. When creating the pipeline for the project, you can point it to the `pipelines/diabetes-train-and-deploy.yml` file. This defines an example pipeline.

