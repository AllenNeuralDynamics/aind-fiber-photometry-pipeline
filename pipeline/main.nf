#!/usr/bin/env nextflow
// hash:sha256:fd86f6410b802e686bc07d63121875379a1f9f8bd83bebc38194c7bb2f60f7f6

nextflow.enable.dsl = 1

params.behavior_819169_2026_03_11_09_31_48_url = 's3://aind-open-data/behavior_819169_2026-03-11_09-31-48'

capsule_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_1 = channel.create()
behavior_819169_2026_03_11_09_31_48_to_aind_fip_dff_2 = channel.fromPath(params.behavior_819169_2026_03_11_09_31_48_url + "/", type: 'any')
behavior_819169_2026_03_11_09_31_48_to_aind_fip_nwb_base_capsule_3 = channel.fromPath(params.behavior_819169_2026_03_11_09_31_48_url + "/", type: 'any')
behavior_819169_2026_03_11_09_31_48_to_aind_fip_qc_raw_4 = channel.fromPath(params.behavior_819169_2026_03_11_09_31_48_url + "/", type: 'any')
behavior_819169_2026_03_11_09_31_48_to_aind_dynamic_foraging_qc_5 = channel.fromPath(params.behavior_819169_2026_03_11_09_31_48_url + "/", type: 'any')
capsule_aind_fip_nwb_base_capsule_10_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_6 = channel.create()
capsule_aind_dynamic_foraging_qc_12_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_7 = channel.create()
capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_8 = channel.create()
capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_9 = channel.create()
capsule_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_10 = channel.create()

// capsule - aind-fip-dff
process capsule_aind_fip_dff_9 {
	tag 'capsule-3526719'
	container "$REGISTRY_HOST/capsule/26792844-1b2c-400d-8514-42d58028e5e5"

	cpus 2
	memory '15 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> filename.matches("capsule/results/nwb") ? new File(filename).getName() : null }

	input:
	path 'capsule/data/fib_raw_nwb/' from capsule_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_1.collect()
	path 'capsule/data/fiber_raw_data' from behavior_819169_2026_03_11_09_31_48_to_aind_fip_dff_2.collect()

	output:
	path 'capsule/results/nwb'
	path 'capsule/results/*.json' into capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_8
	path 'capsule/results/dff-qc' into capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_9

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=26792844-1b2c-400d-8514-42d58028e5e5
	export CO_CPUS=2
	export CO_MEMORY=16106127360

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3526719.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3526719.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-fip-nwb-base-capsule
process capsule_aind_fip_nwb_base_capsule_10 {
	tag 'capsule-9216710'
	container "$REGISTRY_HOST/capsule/1117b9cd-46d6-4804-95bd-7349051dc910:e41ab74963e526b11be044d3866d3a6a"

	cpus 1
	memory '7.5 GB'

	input:
	path 'capsule/data/fiber_raw_data' from behavior_819169_2026_03_11_09_31_48_to_aind_fip_nwb_base_capsule_3.collect()

	output:
	path 'capsule/results/*' into capsule_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_1
	path 'capsule/results/alignment-qc' into capsule_aind_fip_nwb_base_capsule_10_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_6

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=1117b9cd-46d6-4804-95bd-7349051dc910
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9216710.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-9216710.git" capsule-repo
	fi
	git -C capsule-repo checkout 65cb519e44002a85d8fe2175ef5cdcc176f35821 --quiet
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-fip-qc-raw
process capsule_aind_fip_qc_raw_11 {
	tag 'capsule-8999280'
	container "$REGISTRY_HOST/published/3ae91e80-10b6-4659-814a-8afee9359a40:v10"

	cpus 1
	memory '7.5 GB'

	input:
	path 'capsule/data/fiber_raw_data' from behavior_819169_2026_03_11_09_31_48_to_aind_fip_qc_raw_4.collect()

	output:
	path 'capsule/results/*' into capsule_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_10

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=3ae91e80-10b6-4659-814a-8afee9359a40
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v10.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8999280.git" capsule-repo
	else
		git -c credential.helper= clone --branch v10.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8999280.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-dynamic-foraging-qc
process capsule_aind_dynamic_foraging_qc_12 {
	tag 'capsule-6533380'
	container "$REGISTRY_HOST/published/9110d5cb-2dd4-405d-b6e9-725dd04097f5:v8"

	cpus 1
	memory '7.5 GB'

	input:
	path 'capsule/data/fiber_raw_data' from behavior_819169_2026_03_11_09_31_48_to_aind_dynamic_foraging_qc_5.collect()

	output:
	path 'capsule/results/*' into capsule_aind_dynamic_foraging_qc_12_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_7

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=9110d5cb-2dd4-405d-b6e9-725dd04097f5
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v8.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6533380.git" capsule-repo
	else
		git -c credential.helper= clone --branch v8.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6533380.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-generic-quality-control-evaluation-aggregator
process capsule_aind_generic_quality_control_evaluation_aggregator_13 {
	tag 'capsule-5290719'
	container "$REGISTRY_HOST/published/03b3acfd-fdef-46b0-ad80-50e9d4e00827:v1"

	cpus 1
	memory '12 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/alignment-qc' from capsule_aind_fip_nwb_base_capsule_10_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_6
	path 'capsule/data/' from capsule_aind_dynamic_foraging_qc_12_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_7.collect()
	path 'capsule/data/' from capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_8.collect()
	path 'capsule/data/dff-qc' from capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_9
	path 'capsule/data/' from capsule_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_10.collect()

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=03b3acfd-fdef-46b0-ad80-50e9d4e00827
	export CO_CPUS=1
	export CO_MEMORY=12884901888

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 --branch v1.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5290719.git" capsule-repo
	else
		git -c credential.helper= clone --branch v1.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5290719.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
