#!/usr/bin/env nextflow
// hash:sha256:9adc2de5f9411ef0538cd69273b2723031918991d657b307516e4fda1673f310

nextflow.enable.dsl = 1

params.fip_url = 's3://aind-scratch-data/behavior_700708_2024-06-13_09-06-26'

fip_to_copy_of_nwb_packaging_subject_capsule_1 = channel.fromPath(params.fip_url + "/*", type: 'any')
capsule_copy_of_nwb_packaging_subject_capsule_1_to_capsule_nwb_packaging_fiber_photometry_base_capsule_8_2 = channel.create()
capsule_nwb_packaging_fiber_photometry_base_capsule_8_to_capsule_aind_fip_dff_9_3 = channel.create()

// capsule - Copy of NWB-Packaging-Subject-Capsule
process capsule_copy_of_nwb_packaging_subject_capsule_1 {
	tag 'capsule-9127683'
	container "$REGISTRY_HOST/capsule/fbc2117a-512e-4687-ad90-dc1a67c5bb90"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/' from fip_to_copy_of_nwb_packaging_subject_capsule_1

	output:
	path 'capsule/results/*' into capsule_copy_of_nwb_packaging_subject_capsule_1_to_capsule_nwb_packaging_fiber_photometry_base_capsule_8_2

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=fbc2117a-512e-4687-ad90-dc1a67c5bb90
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9127683.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_copy_of_nwb_packaging_subject_capsule_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - NWB-Packaging-FiberPhotometry-Base-Capsule
process capsule_nwb_packaging_fiber_photometry_base_capsule_8 {
	tag 'capsule-9216710'
	container "$REGISTRY_HOST/capsule/1117b9cd-46d6-4804-95bd-7349051dc910"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/' from capsule_copy_of_nwb_packaging_subject_capsule_1_to_capsule_nwb_packaging_fiber_photometry_base_capsule_8_2

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_fiber_photometry_base_capsule_8_to_capsule_aind_fip_dff_9_3

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=1117b9cd-46d6-4804-95bd-7349051dc910
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9216710.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-fip-dff
process capsule_aind_fip_dff_9 {
	tag 'capsule-3526719'
	container "$REGISTRY_HOST/capsule/26792844-1b2c-400d-8514-42d58028e5e5"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_nwb_packaging_fiber_photometry_base_capsule_8_to_capsule_aind_fip_dff_9_3

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=26792844-1b2c-400d-8514-42d58028e5e5
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3526719.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
