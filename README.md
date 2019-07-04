# Introduction 
Sample files used to set up an E2E training and deployment pipeline with the Azure ML CLI.
For more info, please visit https://docs.microsoft.com/azure/machine-learning/service/reference-azure-machine-learning-cli

Install the Machine Learning DevOps extension in your project here https://marketplace.visualstudio.com/items?itemName=ms-air-aiagility.vss-services-azureml to scope your project to your Azure Machine Learning service workspace. 

# How to use

This example requires familiarity with Azure Pipelines. For more information, see [https://docs.microsoft.com/azure/devops/pipelines/create-first-pipeline?view=azure-devops&tabs=tfs-2018-2](https://docs.microsoft.com/azure/devops/pipelines/create-first-pipeline?view=azure-devops&tabs=tfs-2018-2).

This example also requires an Azure Machine Learning service workspace. For more information, see [https://docs.microsoft.com/azure/machine-learning/service/setup-create-workspace](https://docs.microsoft.com/azure/machine-learning/service/setup-create-workspace).

You can clone this repo and use it with Azure Pipelines. Before creating the pipeline you must do the following:

1. Create a [service connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops) named `azmldemows`. This connection must reference your Azure subscription and the Azure resource group that contains your Azure Machine Learning service workspace.
1. Modify the `azure-pipelines.yml` and change `myresourcegroup` to the Azure resource group that contains your workspace. You must also change the `myworkspace` entry to the name of your Azure Machine Learning service workspace.
1. When creating the pipeline for the project, you can point it to the `azure-pipelines.yml` file. This defines an example pipeline.

