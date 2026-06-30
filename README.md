# Combined Dynamic Foraging + Fiber Photometry pipeline

> **Note on the name:** this GitHub repo is called `aind-fiber-photometry-pipeline`, but the Code Ocean pipeline it backs has been renamed to "Combined Dynamic Foraging + fiber pipeline". The repo name predates that rename and is kept as-is to avoid breaking existing links, clones, and references. It is the same pipeline.

This is the **legacy** pipeline that processes both dynamic foraging behavior and fiber photometry data for Pavlovian and Dynamic Foraging tasks, acquired together on legacy pre-Harp/Bonsai behavior systems with the legacy teensy-based FIP system. These legacy systems will begin to be phased out starting in the summer of 2026. New fiber-only acquisition is handled by the successor repo, [`aind-fiber-photometry-harp-pipeline`](https://github.com/AllenNeuralDynamics/aind-fiber-photometry-harp-pipeline). And a new behavior-only Dynamic Foraging processing pipeline is under development (library functions here: https://github.com/AllenNeuralDynamics/dynamic-foraging-processing)

The pipeline [link to latest release](https://codeocean.allenneuraldynamics.org/capsule/1307799/tree) runs on [Nextflow](https://www.nextflow.io/) and contains the following steps:

* [aind-fip-nwb-base-capsule](https://github.com/AllenNeuralDynamics/aind-fip-nwb-base-capsule): Fiber photometry capsule that creates the base NWB file. Adds behavior and fiber photometry information if present.

* [aind-fip-dff](https://github.com/AllenNeuralDynamics/aind-fip-dff): Processes input NWB files containing raw fiber photometry data by generating baseline-corrected (ΔF/F) and motion-corrected traces, which are then appended back to the NWB file.

* [aind-dynamic-foraging-qc](https://github.com/AllenNeuralDynamics/aind-dynamic-foraging-qc): QC capsule for dynamic foraging behavior (modality:behavior) raw data acquired together with HARP/Bonsai-based behavior.

* [aind-fip-qc-raw](https://github.com/AllenNeuralDynamics/aind-fip-qc-raw): QC capsule for fiber photometry (modality:fib, device:fip) raw data acquired together with HARP/Bonsai-based behavior (e.g. Dynamic Foraging).

* [aind-generic-quality-control-evaluation-aggregator](https://github.com/AllenNeuralDynamics/aind-generic-quality-control-evaluation-aggregator): Combines QC outputs into one QC JSON.

# Input

Currently, the pipeline supports the following input data types:

* The input folder must contain a `behavior` subdirectory holding the JSON with behavior timestamps. If an `fib` folder is included, fiber data will also be packaged. The root directory must contain JSON files following v1 [aind-data-schema](https://github.com/AllenNeuralDynamics/aind-data-schema). IMPORTANT: the v1 data schema is no longer supported! The modality-specific fiber and behavior pipelines mentioned above, which will supercede this pipeline, use the new v2 schema standard.

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

### Credentials

The API needs a Code Ocean access token. Generate one in Code Ocean under **Account -> Access Tokens**, then put it in a `.env` file at the repo root (this file is gitignored; never commit a real token):

```bash
# .env
CODEOCEAN_URL=https://codeocean.allenneuraldynamics.org
API_TOKEN=<your-code-ocean-access-token>
```

The example below loads that `.env` with [python-dotenv](https://pypi.org/project/python-dotenv/). Derived from the example on the [Code Ocean API Github](https://github.com/codeocean/codeocean-sdk-python/blob/main/examples/run_pipeline.py).

```python
import os

from dotenv import load_dotenv
from codeocean import CodeOcean
from codeocean.computation import RunParams, NamedRunParam
from codeocean.capsule import CapsuleSearchParams

# Load CODEOCEAN_URL and API_TOKEN from the .env file at the repo root.
load_dotenv()
client = CodeOcean(domain=os.environ["CODEOCEAN_URL"], token=os.environ["API_TOKEN"])

# 1. Resolve the pipeline's UUID from the numeric slug in its capsule URL
#    (.../capsule/1307799). The Code Ocean API is UUID-based and has no slug lookup
#    endpoint (it rejects the numeric slug), so search and match on `.slug`. Matching the
#    slug is required: the pipeline name is NOT unique (an older, stale pipeline shares
#    the same name), and only the slug disambiguates the live one.
PIPELINE_SLUG = "1307799"
pipeline = next(
    p
    for p in client.pipelines.search_pipelines_iterator(
        CapsuleSearchParams(query="Combined Dynamic Foraging + fiber pipeline")
    )
    if p.slug == PIPELINE_SLUG
)
version = max(v["major_version"] for v in pipeline.versions)  # latest released version

# 2. Point the pipeline at the raw session to process. This pipeline reads its input
#    from a Nextflow parameter (an S3 path to the raw session), NOT from an attached
#    data asset: it already has one baked in, so re-attaching errors with "data asset
#    already attached". The session must follow the v1 schema and contain a session.json;
#    v2 assets (acquisition.json instead) are not supported by this legacy pipeline.
#    NOTE: the parameter is named `fip_url` for historical reasons, but its value is the
#    whole raw session (behavior + optional fiber), not a fiber-only path.
SESSION_URL = "s3://aind-open-data/<behavior_subject_date_time>"

run_params = RunParams(
    pipeline_id=pipeline.id,
    version=version,  # a released pipeline must be run against a specific release version
    named_parameters=[NamedRunParam(param_name="fip_url", value=SESSION_URL)],
)

computation = client.computations.run_capsule(run_params)
computation = client.computations.wait_until_completed(computation)
print(computation.state, computation.end_status)
```

Registering the results as a derived data asset (the `<input>_processed_<timestamp>` asset, with correct provenance and metadata) is handled by AIND's automation capsule, not by a hand-written `create_data_asset` call. See [`asset-creation-capsule`](https://github.com/AllenNeuralDynamics/asset-creation-capsule) for the sanctioned registration path.
