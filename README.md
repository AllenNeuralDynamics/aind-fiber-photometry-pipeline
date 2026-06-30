# Combined Dynamic Foraging + Fiber Photometry pipeline

> **Note on the name:** this GitHub repo is called `aind-fiber-photometry-pipeline`, but the Code Ocean pipeline it backs has been renamed to "Combined Dynamic Foraging + fiber pipeline". The repo name predates that rename and is kept as-is to avoid breaking existing links, clones, and references. It is the same pipeline.

This is the **legacy** pipeline that processes both dynamic foraging behavior and fiber photometry data for Pavlovian and Dynamic Foraging tasks, acquired together on HARP/Bonsai-based behavior systems. These legacy systems will begin to be phased out starting June 2026. New fiber-only acquisition is handled by the successor repo, [`aind-fiber-photometry-harp-pipeline`](https://github.com/AllenNeuralDynamics/aind-fiber-photometry-harp-pipeline).

The [pipeline](https://codeocean.allenneuraldynamics.org/capsule/1307799/tree) runs on [Nextflow](https://www.nextflow.io/) and contains the following steps:

* [aind-fip-nwb-base-capsule](https://github.com/AllenNeuralDynamics/aind-fip-nwb-base-capsule): Fiber photometry capsule that creates the base NWB file. Adds behavior and fiber photometry information if present.

* [aind-fip-dff](https://github.com/AllenNeuralDynamics/aind-fip-dff): Processes input NWB files containing raw fiber photometry data by generating baseline-corrected (ΔF/F) and motion-corrected traces, which are then appended back to the NWB file.

* [aind-dynamic-foraging-qc](https://github.com/AllenNeuralDynamics/aind-dynamic-foraging-qc): QC capsule for dynamic foraging behavior (modality:behavior) raw data acquired together with HARP/Bonsai-based behavior.

* [aind-fip-qc-raw](https://github.com/AllenNeuralDynamics/aind-fip-qc-raw): QC capsule for fiber photometry (modality:fib, device:fip) raw data acquired together with HARP/Bonsai-based behavior (e.g. Dynamic Foraging).

* [aind-generic-quality-control-evaluation-aggregator](https://github.com/AllenNeuralDynamics/aind-generic-quality-control-evaluation-aggregator): Combines QC outputs into one QC JSON.

# Input

Currently, the pipeline supports the following input data types:

* `aind`: data ingestion used at AIND. The input folder must contain a `behavior` subdirectory holding the JSON with behavior timestamps. If an `fib` folder is included, fiber data will also be packaged. The root directory must contain JSON files following [aind-data-schema](https://github.com/AllenNeuralDynamics/aind-data-schema).

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

* `aind`: Pipeline outputs are written under the top-level `results` folder, with JSON files following [aind-data-schema](https://github.com/AllenNeuralDynamics/aind-data-schema). The single subdirectory under `results` is named according to the Allen Institute for Neural Dynamics standard for derived-asset formatting. Each step appends to a `processing.json` that records its input parameters; the final `processing.json` sits at the root of `results` at the end of the run, alongside the aggregated quality control JSON.

```plaintext
📦results
 ┣ 📂behavior_MouseID_YYYY-MM-DD_HH-M-S
 ┃ ┣ 📂nwb
 ┃ ┣ 📂dff-qc
 ┃ ┣ 📂qc-raw
 ┃ ┣ 📂dynamic-foraging-qc
 ┃ ┣ 📂alignment-qc
 ┗ 📜processing.json
 ```

The following files are written under the `dff-qc` directory (produced when fiber data is present):

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

The following files are written under the `qc-raw` directory (produced when fiber data is present):

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

The following files are written under the `dynamic-foraging-qc` directory (produced from the dynamic foraging behavior data):

**`dynamic-foraging-qc`**

```plaintext
📦dynamic-foraging-qc
 ┣ 📜lick_intervals.png
 ┣ 📜side_bias.png
 ```

The `alignment-qc` directory holds alignment QC outputs from the NWB base packaging step (`aind-fip-nwb-base-capsule`).

# Parameters

No parameters are used for this pipeline

# Run

`aind` runs in the Code Ocean pipeline [here](https://codeocean.allenneuraldynamics.org/capsule/1307799/tree). If a user has credentials for `aind` Code Ocean, the pipeline can be run using the [Code Ocean API](https://github.com/codeocean/codeocean-sdk-python).

Derived from the example on the [Code Ocean API Github](https://github.com/codeocean/codeocean-sdk-python/blob/main/examples/run_pipeline.py)

```python
import os

from codeocean import CodeOcean
from codeocean.computation import RunParams
from codeocean.data_asset import (
    DataAssetParams,
    DataAssetsRunParam,
    Source,
    ComputationSource,
    Target,
    AWSS3Target,
)

# Create the client using your domain and API token.

client = CodeOcean(domain=os.environ["CODEOCEAN_URL"], token=os.environ["API_TOKEN"])

# Run the pipeline against a raw session data asset. The whole asset is mounted;
# the capsules read the behavior/ and fib/ subfolders from it.

run_params = RunParams(
    pipeline_id=os.environ["PIPELINE_ID"],
    data_assets=[
        DataAssetsRunParam(
            id="<raw data asset id>",
            mount="<raw data asset name>",
        ),
    ],
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
