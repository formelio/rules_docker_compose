#! /usr/bin/env bash

set -euo pipefail

echo -n "%{image_files}" | xargs -d',' -n1 %{docker_binary} load --input

%{compose_binary} %{compose_args} up
