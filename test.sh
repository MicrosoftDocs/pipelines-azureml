#!/bin/bash
az extension add -n azure-cli-ml
az ml folder attach -w $1 -g $2
