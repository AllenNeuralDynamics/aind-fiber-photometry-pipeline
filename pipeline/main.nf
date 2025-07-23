#!/usr/bin/env nextflow
// hash:sha256:384153adc405e1915c02284bd01122b62189f26d4581ef9521396cf2271a7c10

nextflow.enable.dsl = 1

params.fip_url = 's3://aind-private-data-prod-o5171v/behavior_752703_2024-11-20_13-01-14'

capsule_standard_fiber_only_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_1 = channel.create()
fip_to_aind_fip_dff_2 = channel.fromPath(params.fip_url + "/", type: 'any')
fip_to_standard_fiber_only_aind_fip_nwb_base_capsule_3 = channel.fromPath(params.fip_url + "/", type: 'any')
fip_to_standard_fiber_only_aind_fip_qc_raw_4 = channel.fromPath(params.fip_url + "/", type: 'any')
capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_5 = channel.create()
capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_6 = channel.create()
capsule_standard_fiber_only_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_7 = channel.create()

// capsule - aind-fip-dff
process capsule_aind_fip_dff_9 {
	tag 'capsule-1001867'
	container "$REGISTRY_HOST/published/603a2149-6281-4a7b-bbd6-ff50ca0e064e:v11"

	cpus 1
	memory '30 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> filename.matches("capsule/results/nwb") ? new File(filename).getName() : null }

	input:
	path 'capsule/data/' from capsule_standard_fiber_only_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_1.collect()
	path 'capsule/data/fiber_raw_data' from fip_to_aind_fip_dff_2.collect()

	output:
	path 'capsule/results/nwb'
	path 'capsule/results/*.json' into capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_5
	path 'capsule/results/dff-qc' into capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_6

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=603a2149-6281-4a7b-bbd6-ff50ca0e064e
	export CO_CPUS=1
	export CO_MEMORY=32212254720

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 --branch v11.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1001867.git" capsule-repo
	else
		git clone --branch v11.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1001867.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Standard Fiber Only - aind-fip-nwb-base-capsule
process capsule_standard_fiber_only_aind_fip_nwb_base_capsule_10 {
	tag 'capsule-3598308'
	container "$REGISTRY_HOST/capsule/fd449b5c-c054-4397-a447-3e5d214da68a:44a4598d0c9de825c735e6e2950962a0"

	cpus 1
	memory '7.5 GB'

	input:
	path 'capsule/data/fiber_raw_data' from fip_to_standard_fiber_only_aind_fip_nwb_base_capsule_3.collect()

	output:
	path 'capsule/results/*' into capsule_standard_fiber_only_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_1

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=fd449b5c-c054-4397-a447-3e5d214da68a
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3598308.git" capsule-repo
	else
		git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3598308.git" capsule-repo
	fi
	git -C capsule-repo checkout 837e6c2350eb53d1201b6f220357f7d6c396ca9b --quiet
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - Standard Fiber Only - aind-fip-qc-raw
process capsule_standard_fiber_only_aind_fip_qc_raw_11 {
	tag 'capsule-8112489'
	container "$REGISTRY_HOST/capsule/85c81ec9-d55c-43c2-8004-8fb86537d23e:3a7c1489bdef9b6340c1c29fc9b116a4"

	cpus 1
	memory '7.5 GB'

	input:
	path 'capsule/data/fiber_raw_data' from fip_to_standard_fiber_only_aind_fip_qc_raw_4.collect()

	output:
	path 'capsule/results/*' into capsule_standard_fiber_only_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_7

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=85c81ec9-d55c-43c2-8004-8fb86537d23e
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8112489.git" capsule-repo
	else
		git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8112489.git" capsule-repo
	fi
	git -C capsule-repo checkout 01da8e4e45a759c78dbed5ab58dc341b1eaf08cb --quiet
	mv capsule-repo/code capsule/code
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
	path 'capsule/data/' from capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_5.collect()
	path 'capsule/data/dff-qc' from capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_6
	path 'capsule/data/' from capsule_standard_fiber_only_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_7.collect()

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
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
