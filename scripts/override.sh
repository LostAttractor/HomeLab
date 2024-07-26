#!/bin/sh

nix flake update \
 --override-input router path:./Router \
 --override-input metrics path:./Metrics \
 --override-input nas path:./NAS \
 --override-input kubernetes path:./Kubernetes \
 --override-input hydra path:./Hydra