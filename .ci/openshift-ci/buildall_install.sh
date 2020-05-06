#!/bin/bash
#
# Copyright (c) 2020 Red Hat, Inc.
#
# SPDX-License-Identifier: Apache-2.0
#
# Build kata-containers and install into a given destination directory
#

set -e

if [ -z "$1" ];then
	echo "Usage: $0 path/to/install/dir"
	exit 1
fi

export DESTDIR=$1
echo "Build and install kata-containers at: ${DESTDIR}"

export PATH=${GOPATH}/bin:$PATH

cidir=$(dirname "$0")/..
source /etc/os-release || source /usr/lib/os-release
source "${cidir}/lib.sh"

# The scripts rely on sudo which is not installed in the build environment.
yum install -y sudo
"${cidir}/setup_env_centos.sh" default

# The build root container has already golang installed, let's remove it
# so that it will use the version required by kata.
yum remove -y golang
"${cidir}/install_go.sh" -p -f

# Let's ensure scripts don't try things with Podman.
export TEST_CGROUPSV2=false

# Use the QEMU experimental (QEMU with virtiofs).
export experimental_qemu=true
export experimental_kernel=true

# Install rootfs image which is supported with QEMU experimental.
export TEST_INITRD=no

# Configure to use vsock.
# TODO: install_runtime.sh will try to load the vsock module and the script
#       fail. Need to patch the script to skip this if on openshift-ci.
#export USE_VSOCK=yes

# Configure the QEMU machine type.
export MACHINETYPE=q35

# Disable SELinux.
export FEATURE_SELINUX=no

# The default /usr prefix makes the deployment on Red Hat CoreOS (rhcos) more
# complex because that directory is read-only by design. Another prefix than
# /opt/kata is problematic too because QEMU experimental eventually got from
# kata's Jenkins is uncompressed in that directory.
export PREFIX=/opt/kata

RUN_KATA_CHECK=false "${cidir}/install_kata.sh"

# The resulting kata installation will be merged in rhcos filesystem, and
# symlinks are troublesome. So instead let's convert them to in-place files.
for ltarget in `find $DESTDIR -type l`; do
	lsource=`readlink -f $ltarget`
	if [ -e $lsource ]; then
		unlink $ltarget
		cp -fr $lsource $ltarget
	fi
done
