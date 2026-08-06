#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Tell `pixi global` to not set CONDA_PREFIX during activation
# https://pixi.sh/dev/global_tools/introduction/#opt-out-of-conda_prefix
mkdir -p "${PREFIX}/etc/pixi/pi"
touch "${PREFIX}/etc/pixi/pi/global-ignore-conda-prefix"

# Create package archive and install globally from local source
tgz=$(npm pack --ignore-scripts)
npm install -ddd \
    --global \
    ${SRC_DIR}/${tgz}

# Create license report for dependencies. --ignore-scripts avoids pnpm's
# ERR_PNPM_IGNORED_BUILDS failure; dependency build scripts are irrelevant to
# the license scan.
pnpm install --ignore-scripts
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

