#!/bin/bash

# exit on failure
set -e

alias b=buildah

# Create scratch container, mount it and boostrap
c=$( b from scratch )
echo "Container: ${c}"

mnt=$( b mount $c )
echo "Mount: ${mnt}"

dnf install --installroot $mnt --release 28 buildah podman skopeo --setopt install_weak_deps=false -y  --setopt tsflags=nodocs
dnf clean all --installroot $mnt --release 28
#b umount $mnt

# Set some config
b config --author "Nicolas L." $c
b config --entrypoint "/bin/bash" $c
b run $c mkdir /work
b config --workdir "/work" $c
#b config --volume "/var/lib/containers" $c

# Now is time to create the layer
b commit $c containers-tools:slim3
b rm $c

# Push it to docker.io
#b push --authfile /run/containers/0/auth.json localhost/containers-tools:slim docker://docker.io/nicolaznk/containers-tools:slim
