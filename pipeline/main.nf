#!/usr/bin/env nextflow
// hash:sha256:26299adc54dd60ed57cbc0a9ae7e5704ad1babc0ca2cf9ee1143d789fbd6efe4

nextflow.enable.dsl = 1

params.fip_url = 's3://aind-scratch-data/behavior_700708_2024-06-13_09-06-26'

fip_to_nwb_packaging_subject_capsule_1 = channel.fromPath(params.fip_url + "/", type: 'any')
capsule_nwb_packaging_subject_capsule_1_to_capsule_nwb_packaging_fiber_photometry_base_capsule_8_2 = channel.create()
fip_to_aind_fiberphotometry_base_nwb_capsule_3 = channel.fromPath(params.fip_url + "/", type: 'any')
capsule_nwb_packaging_fiber_photometry_base_capsule_8_to_capsule_aind_fip_dff_9_4 = channel.create()
fip_to_aind_fip_dff_5 = channel.fromPath(params.fip_url + "/", type: 'any')

// capsule - NWB-Packaging-Subject-Capsule
process capsule_nwb_packaging_subject_capsule_1 {
	tag 'capsule-1748641'
	container "$REGISTRY_HOST/capsule/dde17e00-2bad-4ceb-a00e-699ec25aca64:cfac593fe3228c6ee40d14cd2f3509e0"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/fiber_session' from fip_to_nwb_packaging_subject_capsule_1.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_subject_capsule_1_to_capsule_nwb_packaging_fiber_photometry_base_capsule_8_2

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=dde17e00-2bad-4ceb-a00e-699ec25aca64
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1748641.git" capsule-repo
	git -C capsule-repo checkout 0817b7aa432c788d00c49aab0fa5da19a5199d07 --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_nwb_packaging_subject_capsule_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-FiberPhotometry-Base-NWB-Capsule
process capsule_nwb_packaging_fiber_photometry_base_capsule_8 {
	tag 'capsule-0550370'
	container "$REGISTRY_HOST/published/e45742e4-7920-4985-ba36-262bc891377a:v3"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/nwb/' from capsule_nwb_packaging_subject_capsule_1_to_capsule_nwb_packaging_fiber_photometry_base_capsule_8_2.collect()
	path 'capsule/data/fiber_raw_data' from fip_to_aind_fiberphotometry_base_nwb_capsule_3.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_fiber_photometry_base_capsule_8_to_capsule_aind_fip_dff_9_4

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=e45742e4-7920-4985-ba36-262bc891377a
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v3.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0550370.git" capsule-repo
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
	tag 'capsule-1001867'
	container "$REGISTRY_HOST/published/603a2149-6281-4a7b-bbd6-ff50ca0e064e:v1"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_nwb_packaging_fiber_photometry_base_capsule_8_to_capsule_aind_fip_dff_9_4.collect()
	path 'capsule/data/fiber_raw_data' from fip_to_aind_fip_dff_5.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=603a2149-6281-4a7b-bbd6-ff50ca0e064e
	export CO_CPUS=1
	export CO_MEMORY=8589934592

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	git clone --branch v1.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1001867.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
