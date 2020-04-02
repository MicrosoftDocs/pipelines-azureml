# Diabetes example model

## Training this model locally

Create local Conda environement:

```cli
conda env create -f config/train-conda.yml
conda activate diabetes-training-env
```

Train the model:

```cli
python train.py
```

## Training this model remotely on AML compute

Install Azure Machine Learning CLI extension:

```cli
az extension add -n azure-cli-ml
```

Attach the current folder to an AML workspace:

```cli
az ml folder attach -w aml-demo -g aml-demo
```

Create a remote compute target in AML:

```cli
az ml computetarget create amlcompute -n cpu-cluster --vm-size STANDARD_D2_V2 --max-nodes 1
```

Send the training job to the remote compute target:

```cli
az ml run submit-script -c config/train --ct cpu-cluster -e diabetes-train-remote -t run.json train.py
```