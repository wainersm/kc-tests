#!/usr/bin/env bats
#
# Copyright (c) 2019 Intel Corporation
#
# SPDX-License-Identifier: Apache-2.0
#

load "${BATS_TEST_DIRNAME}/../../.ci/lib.sh"
load "${BATS_TEST_DIRNAME}/../../lib/common.bash"

setup() {
	export KUBECONFIG="$HOME/.kube/config"
	pod_name="sharevol-kata"
	get_pod_config_dir
}

@test "Empty dir volumes" {
	# Create the pod
	kubectl create -f "${pod_config_dir}/pod-empty-dir.yaml"

	# Check pod creation
	kubectl wait --for=condition=Ready pod "$pod_name"

	# Check volume mounts
	cmd="mount | grep cache"
	kubectl exec $pod_name -- sh -c "$cmd" | grep "/tmp/cache type tmpfs"

	# Check it can write up to the volume limit (50M)
	cmd="dd if=/dev/zero of=/tmp/cache/file1 bs=1M count=50"
	kubectl exec $pod_name -- sh -c "$cmd"

	# And writing one more byte should fail
	cmd="dd if=/dev/zero of=/tmp/cache/file2 bs=1 count=1"
	kubectl exec $pod_name -- sh -c "$cmd"
}

teardown() {
	kubectl delete pod "$pod_name"
}
