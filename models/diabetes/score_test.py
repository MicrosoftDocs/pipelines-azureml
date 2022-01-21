import json
import os
import pickle
from azureml.core.model import Model
from utils import mylib


def init():
    global model
    print("reach init()")

    model_path = Model.get_model_path("test-ado-model")
    with open(os.path.join(model_path, "test_models", "AD3_v1.pkl"), "rb") as file:
        model = pickle.load(file)

    print("model loaded successfully")


def run(data):
    print("get it!")
    return 1
