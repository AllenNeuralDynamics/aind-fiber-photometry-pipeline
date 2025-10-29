#!/usr/bin/env nextflow
// hash:sha256:6cf431442c9de4aaef1a26f7bb4ea7e1890a1af38c39a5ca3ea1cb1340244cef

nextflow.enable.dsl = 1

params.fip_url = 's3://aind-private-data-prod-o5171v/behavior_752703_2024-11-20_13-01-14'

fip_to_nwb_packaging_subject_1 = channel.fromPath(params.fip_url + "/", type: 'any')
capsule_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_2 = channel.create()
fip_to_aind_fip_dff_3 = channel.fromPath(params.fip_url + "/", type: 'any')
capsule_nwb_packaging_subject_capsule_1_to_capsule_aind_fip_nwb_base_capsule_10_4 = channel.create()
fip_to_aind_fip_nwb_base_capsule_5 = channel.fromPath(params.fip_url + "/", type: 'any')
fip_to_aind_fip_qc_raw_6 = channel.fromPath(params.fip_url + "/", type: 'any')
fip_to_aind_dynamic_foraging_qc_7 = channel.fromPath(params.fip_url + "/", type: 'any')
capsule_aind_dynamic_foraging_qc_12_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_8 = channel.create()
capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_9 = channel.create()
capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_10 = channel.create()
capsule_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_11 = channel.create()

// capsule - NWB Packaging Subject
process capsule_nwb_packaging_subject_capsule_1 {
	tag 'capsule-8198603'
	container "$REGISTRY_HOST/published/bdc9f09f-0005-4d09-aaf9-7e82abd93f19:v3"

	cpus 1
	memory '24 GB'

	input:
	path 'capsule/data/fiber_session' from fip_to_nwb_packaging_subject_1.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_subject_capsule_1_to_capsule_aind_fip_nwb_base_capsule_10_4

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=bdc9f09f-0005-4d09-aaf9-7e82abd93f19
	export CO_CPUS=1
	export CO_MEMORY=25769803776

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 --branch v3.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8198603.git" capsule-repo
	else
		git clone --branch v3.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8198603.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
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
	container "$REGISTRY_HOST/published/603a2149-6281-4a7b-bbd6-ff50ca0e064e:v13"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> filename.matches("capsule/results/nwb") ? new File(filename).getName() : null }

	input:
	path 'capsule/data/' from capsule_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_2
	path 'capsule/data/fiber_raw_data' from fip_to_aind_fip_dff_3.collect()

	output:
	path 'capsule/results/nwb'
	path 'capsule/results/*.json' into capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_9
	path 'capsule/results/dff-qc' into capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_10

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=603a2149-6281-4a7b-bbd6-ff50ca0e064e
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 --branch v13.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1001867.git" capsule-repo
	else
		git clone --branch v13.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1001867.git" capsule-repo
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
	tag 'capsule-0550370'
	container "$REGISTRY_HOST/published/e45742e4-7920-4985-ba36-262bc891377a:v19"

	cpus 1
	memory '7.5 GB'

	input:
	path 'capsule/data/nwb/' from capsule_nwb_packaging_subject_capsule_1_to_capsule_aind_fip_nwb_base_capsule_10_4.collect()
	path 'capsule/data/fiber_raw_data' from fip_to_aind_fip_nwb_base_capsule_5.collect()

	output:
	path 'capsule/results/*' into capsule_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_2

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=e45742e4-7920-4985-ba36-262bc891377a
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 --branch v19.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0550370.git" capsule-repo
	else
		git clone --branch v19.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0550370.git" capsule-repo
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

// capsule - aind-fip-qc-raw
process capsule_aind_fip_qc_raw_11 {
	tag 'capsule-8999280'
	container "$REGISTRY_HOST/published/3ae91e80-10b6-4659-814a-8afee9359a40:v8"

	cpus 1
	memory '24 GB'

	input:
	path 'capsule/data/fiber_raw_data' from fip_to_aind_fip_qc_raw_6.collect()

	output:
	path 'capsule/results/*' into capsule_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_11

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=3ae91e80-10b6-4659-814a-8afee9359a40
	export CO_CPUS=1
	export CO_MEMORY=25769803776

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 --branch v8.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8999280.git" capsule-repo
	else
		git clone --branch v8.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8999280.git" capsule-repo
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
	container "$REGISTRY_HOST/published/9110d5cb-2dd4-405d-b6e9-725dd04097f5:v6"

	cpus 1
	memory '50 GB'

	input:
	path 'capsule/data/fiber_raw_data' from fip_to_aind_dynamic_foraging_qc_7.collect()

	output:
	path 'capsule/results/*' into capsule_aind_dynamic_foraging_qc_12_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_8

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=9110d5cb-2dd4-405d-b6e9-725dd04097f5
	export CO_CPUS=1
	export CO_MEMORY=53687091200

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 --branch v6.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6533380.git" capsule-repo
	else
		git clone --branch v6.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6533380.git" capsule-repo
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
	path 'capsule/data/' from capsule_aind_dynamic_foraging_qc_12_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_8.collect()
	path 'capsule/data/' from capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_9.collect()
	path 'capsule/data/dff-qc' from capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_10
	path 'capsule/data/' from capsule_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_11.collect()

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
		git clone --filter=tree:0 --branch v1.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5290719.git" capsule-repo
	else
		git clone --branch v1.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5290719.git" capsule-repo
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
