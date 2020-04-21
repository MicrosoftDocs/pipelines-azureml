# Introduction 

This repo shows an E2E training and deployment pipeline with Azure Machine Learning's CLI. For more info, please visit [Azure Machine Learning CLI documentation](https://docs.microsoft.com/azure/machine-learning/service/reference-azure-machine-learning-cli).

This example requires some familiarity with Azure Pipelines or GitHub Actions. For more information, see [here](https://docs.microsoft.com/azure/devops/pipelines/create-first-pipeline?view=azure-devops&tabs=tfs-2018-2).

# Instructions

## Detailed Instructions

First, fork (or clone) the repository to your own GitHub account, so that you can make modification to your pipelines. From there, follow these instructions to get the whole setup and demo up and running:

:page_facing_up: [Detailed step-by-step setup instructions](docs/getting_started.md) :page_facing_up:

## Short Instructions

If you are familar with Azure Machine Learning and Azure DevOps, you can follow these shortend instructions:

1. Fork or clone this repo
1. Create an [Azure Machine Learning workspace](https://docs.microsoft.com/azure/machine-learning/service/setup-create-workspace) named `aml-demo` in a resource group named `aml-demo`
1. Create a new project in Azure DevOps/Pipelines
1. Goto `Project settings`, select `Service connections`, create a new connection of type `Azure Resource Manager`, select `Service principal (automatic)` and configure it to the `Resource Group` of your Machine Learning workspace. Name it `azmldemows`. For more details see [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops) or follow the [tutorial](docs/intial_setup.md).
1. Create a new pipeline for the project, point it to the `pipelines/diabetes-train-and-deploy.yml` file in your forked GitHub repo. This defines an example pipeline.
1. Modify the `pipelines/diabetes-train-and-deploy.yml` and change the `ml-rg` variable to the Azure resource group that contains your workspace. You may also change the `ml-ws` variable to the name of your Azure Machine Learning service workspace.
1. Run the pipeline

## Declare variables for CI/CD pipeline

In case you want to leverage an existing ML workspace, you can customize it in the example pipeline [`pipelines/diabetes-train-and-deploy.yml`](pipelines/diabetes-train-and-deploy.yml):

```yaml
 - ml-ws-connection: 'azmldemows'  # Workspace Service Connection name
 - ml-ws: 'aml-demo'               # AML Workspace name
 - ml-rg: 'aml-demo'               # AML resource Group name
 - ml-ct: 'cpu-cluster-1'          # AML Compute cluster name
 - ml-path: 'models/diabetes'      # Model directory path in repo
 - ml-exp: 'exp-test'              # Experiment name
 - ml-model-name: 'diabetes-model' # Model name
 - ml-aks-name: 'aks-prod'         # AKS cluster name
```

## Run CLI scripts to create training compute, train model, register model, deploy model

You can also manually emulate the [example pipeline](pipelines/diabetes-train-and-deploy.yml) on your machine by running the following commands (make sure to substitue the variables from above):

```bash
az extension add -n azure-cli-ml

cd models/diabetes/
az ml folder attach -w $(ml-ws) -g $(ml-rg)
az ml computetarget create amlcompute -n $(ml-ct) --vm-size STANDARD_D2_V2 --max-nodes 1
az ml run submit-script -c config/train --ct $(ml-ct) -e $(ml-exp) -t run.json train.py
az ml model register -n $(ml-model-name) -f run.json --asset-path outputs/ridge_0.95.pkl -t model.json
az ml model deploy -n diabetes-qa-aci -f model.json --ic config/inference-config.yml --dc config/deployment-config-aci.yml --overwrite
az ml computetarget create aks --name $(ml-aks-name) --cluster-purpose DevTest
az ml model deploy --name diabetes-prod-aks --ct $(ml-aks-name) -f model.json --ic config/inference-config.yml --dc config/deployment-config-aks.yml  --overwrite
```
## Further notes

If you want to scope your project to your Azure Machine Learning service workspace, you can install the [Machine Learning DevOps extension](https://marketplace.visualstudio.com/items?itemName=ms-air-aiagility.vss-services-azureml) in your Azure DevOps project.
