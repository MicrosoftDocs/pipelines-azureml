# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license.

import pickle
import os
import numpy as np
from sklearn.datasets import load_diabetes
from sklearn.linear_model import Ridge
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split
from azureml.core.run import Run

from utils import mylib

os.makedirs('./outputs', exist_ok=True)

X, y = load_diabetes(return_X_y=True)

run = Run.get_context()

X_train, X_test, y_train, y_test = train_test_split(X, y,
                                                    test_size=0.2,
                                                    random_state=0)
data = {"train": {"X": X_train, "y": y_train},
        "test": {"X": X_test, "y": y_test}}

# list of numbers from 0.0 to 1.0 with a 0.05 interval
alphas = mylib.get_alphas()

for alpha in alphas:
    # Use Ridge algorithm to create a regression model
    reg = Ridge(alpha=alpha)
    reg.fit(data["train"]["X"], data["train"]["y"])

    preds = reg.predict(data["test"]["X"])
    mse = mean_squared_error(preds, data["test"]["y"])
    run.log('alpha', alpha)
    run.log('mse', mse)

    # Save model in the outputs folder so it automatically get uploaded when running on AML Compute
    model_file_name = 'ridge_{0:.2f}.pkl'.format(alpha)
    with open(os.path.join('./outputs/', model_file_name), 'wb') as file:
        pickle.dump(reg, file)

    print('alpha is {0:.2f}, and mse is {1:0.2f}'.format(alpha, mse))
