#!/bin/bash

# exit on failure
set -e

alias b=buildah

# Create initial container
c=$( b from fedora:28 )

# Set some config
b config --author "Nicolas L." $c
b config --entrypoint "/bin/bash" $c
#b config --volume "/var/lib/containers" $c

# Install packages, updates and clean all stuff
b run $c dnf install -y buildah podman skopeo
b run $c dnf -y update
b run $c dnf clean all

# Now is time to create the layer
b commit $c containers-tools:latest

