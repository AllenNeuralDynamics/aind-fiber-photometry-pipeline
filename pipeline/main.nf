#!/usr/bin/env nextflow
// hash:sha256:9dd1892c9e7597015351296387fc4051750cb4ad497a24e3cb370c62d583c4bf

nextflow.enable.dsl = 1

fiber_standard_to_nwb_packaging_subject_1 = channel.fromPath("../data/fiber_standard", type: 'any')
fiber_standard_to_aind_fip_dff_2 = channel.fromPath("../data/fiber_standard", type: 'any')
capsule_standard_fiber_only_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_3 = channel.create()
fiber_standard_to_standard_fiber_only_aind_fip_nwb_base_capsule_4 = channel.fromPath("../data/fiber_standard", type: 'any')
capsule_nwb_packaging_subject_capsule_1_to_capsule_standard_fiber_only_aind_fip_nwb_base_capsule_10_5 = channel.create()
fiber_standard_to_standard_fiber_only_aind_fip_qc_raw_6 = channel.fromPath("../data/fiber_standard", type: 'any')
capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_7 = channel.create()
capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_8 = channel.create()
capsule_standard_fiber_only_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_9 = channel.create()

// capsule - NWB Packaging Subject
process capsule_nwb_packaging_subject_capsule_1 {
	tag 'capsule-8198603'
	container "$REGISTRY_HOST/published/bdc9f09f-0005-4d09-aaf9-7e82abd93f19:v3"

	cpus 1
	memory '15 GB'

	cache 'deep'

	input:
	path 'capsule/data/fiber_session' from fiber_standard_to_nwb_packaging_subject_1.collect()

	output:
	path 'capsule/results/*' into capsule_nwb_packaging_subject_capsule_1_to_capsule_standard_fiber_only_aind_fip_nwb_base_capsule_10_5

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=bdc9f09f-0005-4d09-aaf9-7e82abd93f19
	export CO_CPUS=1
	export CO_MEMORY=16106127360

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
	container "$REGISTRY_HOST/published/603a2149-6281-4a7b-bbd6-ff50ca0e064e:v11"

	cpus 1
	memory '30 GB'

	cache 'deep'

	publishDir "$RESULTS_PATH", saveAs: { filename -> filename.matches("capsule/results/nwb") ? new File(filename).getName() : null }

	input:
	path 'capsule/data/fiber_raw_data' from fiber_standard_to_aind_fip_dff_2.collect()
	path 'capsule/data/' from capsule_standard_fiber_only_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_3

	output:
	path 'capsule/results/nwb'
	path 'capsule/results/*.json' into capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_7
	path 'capsule/results/dff-qc' into capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_8

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
	container "$REGISTRY_HOST/capsule/fd449b5c-c054-4397-a447-3e5d214da68a:ec5622d3035d3ce118065ba4eaef95dc"

	cpus 1
	memory '7.5 GB'

	cache 'deep'

	input:
	path 'capsule/data/fiber_raw_data' from fiber_standard_to_standard_fiber_only_aind_fip_nwb_base_capsule_4.collect()
	path 'capsule/data/nwb/' from capsule_nwb_packaging_subject_capsule_1_to_capsule_standard_fiber_only_aind_fip_nwb_base_capsule_10_5.collect()

	output:
	path 'capsule/results/*' into capsule_standard_fiber_only_aind_fip_nwb_base_capsule_10_to_capsule_aind_fip_dff_9_3

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
	git -C capsule-repo checkout 1ccf098fdf3b36b5f209be4c8440005dc014c6c4 --quiet
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

	cache 'deep'

	input:
	path 'capsule/data/fiber_raw_data' from fiber_standard_to_standard_fiber_only_aind_fip_qc_raw_6.collect()

	output:
	path 'capsule/results/*' into capsule_standard_fiber_only_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_9

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
	path 'capsule/data/' from capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_7.collect()
	path 'capsule/data/dff-qc' from capsule_aind_fip_dff_9_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_8
	path 'capsule/data/' from capsule_standard_fiber_only_aind_fip_qc_raw_11_to_capsule_aind_generic_quality_control_evaluation_aggregator_13_9.collect()

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
