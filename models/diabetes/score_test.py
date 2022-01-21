import json
import numpy as np
import os
import pickle
from sklearn.linear_model import Ridge
from azureml.core.model import Model
from inference_schema.schema_decorators import input_schema, output_schema
from inference_schema.parameter_types.numpy_parameter_type import NumpyParameterType
from utils import mylib


def init():
    global model
    model_path = Model.get_model_path("test-ado-model")
    with open(os.path.join(model_path, "test_models", "AD3_v1.pkl"), "rb") as file:
        model = pickle.load(file)

    print("model loaded successfully")


@input_schema("data", NumpyParameterType(input_sample))
@output_schema(NumpyParameterType(output_sample))
def run(data):
    print("get it!")
    return 1
