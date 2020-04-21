# Curated Environments tied to SDK release

## Authors' Guide

Curated environments let users to get started with Azure ML quickly and easily. They contain ML libraries relevant for specific scenario, with Microsoft stamp of approval.

Publishing a curated environment is equivalent to shipping a GA product. Once published, the environment cannot be pulled back without potentially breaking users' applications. As an author of curated environment, you:

 * Commit to supporting the environment for the life of Azure ML service.
 * Address bugs, customer issues and live site issues promptly.
 * Ensure that environment and its documentation stay up-to date.
 * Ensure you have CELA clearance to ship the environment and its dependencies.
 * If leaving the team, transfer the environment to new owner.


### Checklist

 * There must be a valid use case for publishing a new environment
   * First review if an existing environment could be adapted or updated.
   * Do not publish a new environment just to advertise a new feature.
 * Environment must have documentation such as Notebooks to show the use case
 * Environment must be named "AzureML-\<Short Name\>"
 * External packages must be high quality and actively maintained.
 * External packages must support the OS and Python versions that Azure ML supports.
 * Environment must build correctly as Docker Image.
 * Make environment as small as possible and avoid unnecessary dependencies. Smaller environments build and load faster, resulting in better user experience.
 * Avoid pinned dependencies. Pinned dependencies make it harder for user to customize the environment.

 ### Process
  * Create folder "Short Name" and place envdef.json and .contact files there.
  * Start a PR with "curated-env-reviewers" as required reviewers.
  * Environments shipped as part of AzureML-SDK release.
    * Environment that fails to build as a Docker image will not ship.
  * Environments are shipped only if there's been an update.
  * Environments are versioned. By default, users will receive the latest version.
  * Environments are distributed to:
    * Global cache
    * Data Science Instance (TBD)
  * Once shipped, environments are visible through:
    * SDK and CLI list queries
    * Workspace UI (TBD)
    * As Jupyter Kernels on DSI (TBD)


## List of environments

| Environment     |      Use case |
|-----------------|---------------|
| AzureML-Minimal | Minimal environment that supports core Azure ML operations. Users can layer their custom packages on top.|
| AzureML-Tutorial | Environment intended for running tutorial Notebooks. Contains different Azure ML packages, and common data science packages, but no deep learning libraries.|
| AzureML-TensorFlow-\<tf-version\>-CPU | Environment for Tensorflow Estimator |
| AzureML-TensorFlow-\<tf-version\>-GPU | Environment for Tensorflow Estimator |
| AzureML-PyTorch-\<pytorch-version\>-CPU | Environment for PyTorch Estimator |
| AzureML-PyTorch-\<pytorch-version\>-GPU | Environment for PyTorch Estimator |
| AzureML-Chainer-\<chainer-version\>-CPU | Environment for Chainer Estimator |
| AzureML-Chainer-\<chainer-version\>-GPU | Environment for Chainer Estimator |
| AzureML-Scikit-Learn | Environment for Scikit-Learn Estimator |
| AzureML-AutoML | Environment for AutoML runs

