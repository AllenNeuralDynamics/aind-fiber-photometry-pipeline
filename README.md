# Fiber Photometry processing pipeline

The fiber photometry pipeline runs on [Nextflow](https://www.nextflow.io/) and contains the following steps:

* [nwb-subject-capsule](https://github.com/AllenNeuralDynamics/aind-subject-nwb): This simple capsule is designed to create an NWB file with basic subject and session information.

* [aind-fip-nwb-base-capsule](https://github.com/AllenNeuralDynamics/aind-fip-nwb-base-capsule): FiberPhotometry Capsule which appends to an NWB subject file. Adds behavior and FiberPhotometry information if present.

* [aind-fip-dff](https://github.com/AllenNeuralDynamics/aind-fip-dff): Processes input NWB files containing raw fiber photometry data by generating baseline-corrected (ΔF/F) and motion-corrected traces, which are then appended back to the NWB file.

* [aind-dynamic-foraging-qc](https://github.com/AllenNeuralDynamics/aind-dynamic-foraging-qc): QC capsule for dynamic foraging behavior (modality:behavior) raw data acquired together with HARP/Bonsai-based behavior

* [aind-fip-qc-raw](https://github.com/AllenNeuralDynamics/aind-fip-qc-raw): QC capsule for fiber photometry (modality:fib, device:fip) raw data acquired together with HARP/Bonsai-based behavior (e.g. Dynamic Foraging)

* [aind-generic-quality-control-evaluation-aggregator](https://github.com/AllenNeuralDynamics/aind-generic-quality-control-evaluation-aggregator): Combines QC outputs into one QC JSON

# Input

Currently, the pipeline supports the following input data types:

* `aind`: data ingestion used at AIND. The input folder must contain a subdirectory called `behavior` (for planar-ophys) which contains the json including behavior timestamps. If an "fib" folder is included, fiber data will also be packaged. The root directory must contain JSON files following [aind-data-schema](https://github.com/AllenNeuralDynamics/aind-data-schema).

```plaintext
📦data
 ┣ 📂behavior_MouseID_YYYY-MM-DD_HH-M-S
 ┃ ┣ 📂behavior
 ┃ ┣ 📂fib
 ┣ 📜data_description.json
 ┣ 📜session.json
 ┗ 📜processing.json
 ```
# Output

Tools used to read files in python are [h5py](https://pypi.org/project/h5py/), json and csv.

* `aind`: The pipeline outputs are saved under the `results` top-level folder with JSON files following [aind-data-schema](https://github.com/AllenNeuralDynamics/aind-data-schema). Each field of view (plane) runs as a parallel process from motion-correction to event detection. The first subdirectory under `results` is named according to Allen Institute for Neural Dynamics standard for derived asset formatting. Below that folder, each field of view is named according to the anatomical region of imaging and the index (or plane number) it corresponds to. The index number is generated before processing in the session.json which details out the imaging configuration during acquisition. As the movies go through the processsing pipeline, a JSON file called processing.json is created where processing data from input parameters are appended. The final JSON will sit at the root of the `results` folder at the end of processing. 

```plaintext
📦results
 ┣ 📂behavior_MouseID_YYYY-MM-DD_HH-M-S
 ┃ ┣ 📂dff-qc
 ┃ ┣ 📂dynamic-foraging-qc
 ┃ ┣ 📂nwb
 ┗ 📜processing.json
 ```

The following files will be under the 'dff-qc' directory within the `results` folder (if there is fiber data to qc):

**`dff-qc`**

```plaintext
📦dff-qc
 ┣ 📜ROI0_bright.png
 ┣ 📜ROI0_exp.png
 ┣ 📜ROI0_poly.png
 ┣ 📜ROI1_bright.png
 ┣ 📜ROI1_exp.png
 ┣ 📜ROI1_poly.png
 ┣ 📜ROI2_bright.png
 ┣ 📜ROI2_exp.png
 ┣ 📜ROI2_poly.png
 ┣ 📜ROI3_bright.png
 ┣ 📜ROI3_exp.png
 ┣ 📜ROI3_poly.png
 ```
*Note: Prior to pipeline version 7, these files are indexed starting from 1, rather than 0. The version of the pipeline used to process each asset is present in the processing.json*

The following files will be under the 'dynamic-foraging-qc' directory within the `results` folder (if there is fiber data to qc):

**`dynamic-foraging-qc`**

```plaintext
📦dynamic-foraging-qc
 ┣ 📜lick_intervals.png
 ┣ 📜side_bias.png
 ```

The following files will be under the 'qc-raw' directory within the `results` folder (if there is fiber data to qc):

**`qc-raw`**

```plaintext
📦qc-raw
┣ 📜CMOS_Floor.pdf
┣ 📜CMOS_Floor.png
┣ 📜SyncPulseDiff.pdf
┣ 📜SyncPulseDiff.png
┣ 📜raw_traces.pdf
┣ 📜raw_traces.png
```

# Parameters

No parameters are used for this pipeline

# Run

`aind` Runs in the Code Ocean pipeline [here](https://codeocean.allenneuraldynamics.org/capsule/7026342/tree). If a user has credentials for `aind` Code Ocean, the pipeline can be run using the [Code Ocean API](https://github.com/codeocean/codeocean-sdk-python). 

Derived from the example on the [Code Ocean API Github](https://github.com/codeocean/codeocean-sdk-python/blob/main/examples/run_pipeline.py)

```python
import os

from codeocean import CodeOcean
from codeocean.computation import RunParams
from codeocean.data_asset import (
    DataAssetParams,
    DataAssetsRunParam,
    PipelineProcessParams,
    Source,
    ComputationSource,
    Target,
    AWSS3Target,
)

# Create the client using your domain and API token.

client = CodeOcean(domain=os.environ["CODEOCEAN_URL"], token=os.environ["API_TOKEN"])

# Run a pipeline with ordered parameters.

run_params = RunParams(
    pipeline_id=os.environ["PIPELINE_ID"],
    data_assets=[
        DataAssetsRunParam(
            id="eeefcc52-b445-4e3c-80c5-0e65526cd712",
            mount="FIP",
        ),
)

computation = client.computations.run_capsule(run_params)

# Wait for pipeline to finish.

computation = client.computations.wait_until_completed(computation)

# Create an external (S3) data asset from computation results.

data_asset_params = DataAssetParams(
    name="My External Result",
    description="Computation result",
    mount="my-result",
    tags=["my", "external", "result"],
    source=Source(
        computation=ComputationSource(
            id=computation.id,
        ),
    ),
    target=Target(
        aws=AWSS3Target(
            bucket=os.environ["EXTERNAL_S3_BUCKET"],
            prefix=os.environ.get("EXTERNAL_S3_BUCKET_PREFIX"),
        ),
    ),
)

data_asset = client.data_assets.create_data_asset(data_asset_params)

data_asset = client.data_assets.wait_until_ready(data_asset)
```


