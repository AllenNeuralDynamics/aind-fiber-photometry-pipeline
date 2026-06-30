> # ⚠️ DEAD BRANCH: DO NOT USE
>
> **This `feat-fiber-only-new-file-standard` branch was never deployed to production.** It was prepared as a standalone fiber-only pipeline (with v1 metadata) that was never released, and it is now abandoned.
>
> **Do not run any pipeline from this branch, and do not build further work on top of it.** Anything here is stale and unsupported.
>
> For the live, production pipeline (the combined Dynamic Foraging + fiber photometry pipeline) and current documentation, use the [`master`](https://github.com/AllenNeuralDynamics/aind-fiber-photometry-pipeline/tree/master) branch instead.

# Fiber Photometry processing pipeline
This is a pipeline in development to process Fiber Photometry data adapted to a fiber acquisition standard defined here: [Fiber Photometry Acquisition Standard](https://github.com/AllenNeuralDynamics/aind-file-standards/blob/main/file_formats/fip.md). NOTE: The data currently attached to the pipeline is a subset of the standard defined, and is only meant for testing purposes. Currently is `fiber_standard` folder in the pipeline.

The [fiber photometry pipeline](https://codeocean.allenneuraldynamics.org/capsule/7378248/tree) runs on [Nextflow](https://www.nextflow.io/) and contains the following steps:

* [nwb-subject-capsule](https://github.com/AllenNeuralDynamics/aind-subject-nwb): This simple capsule is designed to create an NWB file with basic subject and session information.

* [aind-fip-nwb-base-capsule](https://github.com/AllenNeuralDynamics/aind-fip-nwb-base-capsule/tree/feat-add-new-file-standard): FiberPhotometry Capsule which appends to an NWB subject file. Currently in development for new standard

* [aind-fip-dff](https://github.com/AllenNeuralDynamics/aind-fip-dff): Processes input NWB files containing raw fiber photometry data by generating baseline-corrected (ΔF/F) and motion-corrected traces, which are then appended back to the NWB file.

* [aind-fip-qc-raw](https://github.com/AllenNeuralDynamics/aind-fip-qc-raw/tree/feat-add-new-file-standard): QC capsule for fiber photometry. Currently in development for new standard.

* [aind-generic-quality-control-evaluation-aggregator](https://github.com/AllenNeuralDynamics/aind-generic-quality-control-evaluation-aggregator): Combines QC outputs into one QC JSON

# Input

Currently, the pipeline supports the following input data types:

* `aind`: data ingestion used at AIND. If an "fib" folder is included, fiber data will be packaged. The root directory must contain JSON files following [aind-data-schema](https://github.com/AllenNeuralDynamics/aind-data-schema).

Under the `fib` folder, the data will be stored as defined in the file standard linked above.

```plaintext
📦data
 ┣ 📂MouseID_YYYY-MM-DD_HH-M-S
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
 ┃ 📂dff-qc
 ┃ 📂qc-raw
 ┃ 📂nwb
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

The following files will be under the 'qc-raw' directory within the `results` folder (if there is fiber data to qc):

**`qc-raw`**

```plaintext
📦qc-raw
┣ 📜CMOS_Floor.pdf
┣ 📜CMOS_Floor.png
┣ 📜raw_traces.pdf
┣ 📜raw_traces.png
```

**`nwb`**

The NWB output has both raw and processed data. The raw data can be found under the `acquisition` field in the NWB. It contains timerseries for each channel-fiber. Under the `processing` field, there will be a `fiber_photometry` module that will contain timeseries for different combinations of channel-fiber connection, dff, and motion-correction.

```plaintext
📦nwb
┣ 📜acquisition
┃ ┣ 📂G_0
┃ ┣ 📂G_1
┃ ┣ 📂G_2
┃ ┣ 📂G_3
┃ ┣ 📂Iso_0
┃ ┣ 📂Iso_1
┃ ┣ 📂Iso_2
┃ ┣ 📂Iso_3
┃ ┣ 📂Red_0
┃ ┣ 📂Red_1
┃ ┣ 📂Red_2
┃ ┣ 📂Red_3
┣ 📜processing
┃ ┣ 📂fiber_photometry
┃ ┃ ┣ 📂G_0_dff-bright
┃ ┃ ┣ 📂G_0_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂G_0_dff-exp
┃ ┃ ┣ 📂G_0_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂G_0_dff-poly
┃ ┃ ┣ 📂G_0_dff-poly_mc-ISO-IRLS
┃ ┃ ┣ 📂G_1_dff-bright
┃ ┃ ┣ 📂G_1_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂G_1_dff-exp
┃ ┃ ┣ 📂G_1_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂G_1_dff-poly
┃ ┃ ┣ 📂G_1_dff-poly_mc-ISO-IRLS
┃ ┃ ┣ 📂G_2_dff-bright
┃ ┃ ┣ 📂G_2_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂G_2_dff-exp
┃ ┃ ┣ 📂G_2_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂G_2_dff-poly
┃ ┃ ┣ 📂G_2_dff-poly_mc-ISO-IRLS
┃ ┃ ┣ 📂G_3_dff-bright
┃ ┃ ┣ 📂G_3_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂G_3_dff-exp
┃ ┃ ┣ 📂G_3_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂G_3_dff-poly
┃ ┃ ┣ 📂G_3_dff-poly_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_0_dff-bright
┃ ┃ ┣ 📂Iso_0_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_0_dff-exp
┃ ┃ ┣ 📂Iso_0_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_0_dff-poly
┃ ┃ ┣ 📂Iso_0_dff-poly_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_1_dff-bright
┃ ┃ ┣ 📂Iso_1_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_1_dff-exp
┃ ┃ ┣ 📂Iso_1_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_1_dff-poly
┃ ┃ ┣ 📂Iso_1_dff-poly_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_2_dff-bright
┃ ┃ ┣ 📂Iso_2_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_2_dff-exp
┃ ┃ ┣ 📂Iso_2_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_2_dff-poly
┃ ┃ ┣ 📂Iso_2_dff-poly_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_3_dff-bright
┃ ┃ ┣ 📂Iso_3_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_3_dff-exp
┃ ┃ ┣ 📂Iso_3_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂Iso_3_dff-poly
┃ ┃ ┣ 📂Iso_3_dff-poly_mc-ISO-IRLS
┃ ┃ ┣ 📂R_0_dff-bright
┃ ┃ ┣ 📂R_0_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂R_0_dff-exp
┃ ┃ ┣ 📂R_0_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂R_0_dff-poly
┃ ┃ ┣ 📂R_0_dff-poly_mc-ISO-IRLS
┃ ┃ ┣ 📂R_1_dff-bright
┃ ┃ ┣ 📂R_1_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂R_1_dff-exp
┃ ┃ ┣ 📂R_1_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂R_1_dff-poly
┃ ┃ ┣ 📂R_1_dff-poly_mc-ISO-IRLS
┃ ┃ ┣ 📂R_2_dff-bright
┃ ┃ ┣ 📂R_2_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂R_2_dff-exp
┃ ┃ ┣ 📂R_2_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂R_2_dff-poly
┃ ┃ ┣ 📂R_2_dff-poly_mc-ISO-IRLS
┃ ┃ ┣ 📂R_3_dff-bright
┃ ┃ ┣ 📂R_3_dff-bright_mc-ISO-IRLS
┃ ┃ ┣ 📂R_3_dff-exp
┃ ┃ ┣ 📂R_3_dff-exp_mc-ISO-IRLS
┃ ┃ ┣ 📂R_3_dff-poly
┃ ┃ ┣ 📂R_3_dff-poly_mc-ISO-IRLS
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


