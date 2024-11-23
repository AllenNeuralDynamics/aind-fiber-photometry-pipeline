#!/usr/bin/env nextflow
// hash:sha256:d069f98a1577553cc2388a0b64856b07e8490374cd4cb6ab23f7326d055b9e58

nextflow.enable.dsl = 1

params.fip_url = 's3://aind-private-data-prod-o5171v/behavior_752703_2024-11-20_13-01-14'

fip_to_nwb_packaging_subject_capsule_1 = channel.fromPath(params.fip_url + "/", type: 'any')
capsule_aind_fiber_photometry_base_nwb_capsule_10_to_capsule_aind_fip_dff_9_2 = channel.create()
fip_to_aind_fip_dff_3 = channel.fromPath(params.fip_url + "/", type: 'any')
capsule_nwb_packaging_subject_capsule_1_to_capsule_aind_fiber_photometry_base_nwb_capsule_10_4 = channel.create()
fip_to_aind_fiberphotometry_base_nwb_capsule_5 = channel.fromPath(params.fip_url + "/", type: 'any')

// capsule - NWB-Packaging-Subject-Capsule
process capsule_nwb_packaging_subject_capsule_1 {
	tag 'capsule-1748641'
	container "$REGISTRY_HOST/capsule/dde17e00-2bad-4ceb-a00e-699ec25aca64"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/fiber_session' from fip_to_nwb_packaging_subject_capsule_1.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_subject_capsule_1_to_capsule_aind_fiber_photometry_base_nwb_capsule_10_4

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

// capsule - aind-fip-dff
process capsule_aind_fip_dff_9 {
	tag 'capsule-1001867'
	container "$REGISTRY_HOST/published/603a2149-6281-4a7b-bbd6-ff50ca0e064e:v2"

	cpus 1
	memory '8 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_fiber_photometry_base_nwb_capsule_10_to_capsule_aind_fip_dff_9_2
	path 'capsule/data/fiber_raw_data' from fip_to_aind_fip_dff_3.collect()

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
	git clone --branch v2.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1001867.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-FiberPhotometry-Base-NWB-Capsule
process capsule_aind_fiber_photometry_base_nwb_capsule_10 {
	tag 'capsule-0550370'
	container "$REGISTRY_HOST/published/e45742e4-7920-4985-ba36-262bc891377a:v6"

	cpus 1
	memory '8 GB'

	input:
	path 'capsule/data/nwb/' from capsule_nwb_packaging_subject_capsule_1_to_capsule_aind_fiber_photometry_base_nwb_capsule_10_4.collect()
	path 'capsule/data/fiber_raw_data' from fip_to_aind_fiberphotometry_base_nwb_capsule_5.collect()

	output:
	path 'capsule/results/*' into capsule_aind_fiber_photometry_base_nwb_capsule_10_to_capsule_aind_fip_dff_9_2

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
	git clone --branch v6.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0550370.git" capsule-repo
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
