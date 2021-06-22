#
# Copyright (c) 2021 Red Hat
#
# SPDX-License-Identifier: Apache-2.0
#

load "${BATS_TEST_DIRNAME}/../../.ci/lib.sh"
load "${BATS_TEST_DIRNAME}/tests_common.sh"

setup() {
	export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}"
	extract_kata_env

	# Ensure setting Seccomp mode is allowed on guest
	sudo sed -i 's/disable_guest_seccomp=true/disable_guest_seccomp=false/' ${RUNTIME_CONFIG_PATH}

	pod_name="seccomp-container"
	get_pod_config_dir
}

@test "Support seccomp runtime/default profile" {
	# Create pod
	kubectl create -f "${pod_config_dir}/pod-seccomp.yaml"

	# Wait it to complete
	cmd="kubectl get pods ${pod_name} | grep Completed"
	waitForProcess "${wait_time}" "${sleep_time}" "${cmd}"

	# Expect Seccomp on mode 2 (filter)
	seccomp_mode="$(kubectl logs ${pod_name} | sed 's/Seccomp:\s*\([0-9]\)/\1/')"
	[ "$seccomp_mode" -eq "2" ]
}

teardown() {
	# For debugging
	echo "Seccomp mode is ${seccomp_mode}"

	kubectl delete -f "${pod_config_dir}/pod-seccomp.yaml"
	sudo sed -i 's/disable_guest_seccomp=false/disable_guest_seccomp=true/' ${RUNTIME_CONFIG_PATH}
}
