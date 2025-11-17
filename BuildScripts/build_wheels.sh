#!/bin/bash
#
# This script builds the 32-bit and 64-bit Windows wheels for pywinsparkle.
#
# Prerequisites:
# 1. Python 3.x
# 2. 'wheel' and 'setuptools' packages: pip install wheel setuptools
# 3. An environment that can run bash scripts (like Git Bash on Windows).
#
# Run this script from the project root or from within the BuildScripts directory.
#

# Exit immediately if a command exits with a non-zero status.
set -e

# Navigate to the project root (one level up from this script's directory)
cd "$(dirname "$0")/.."

echo "Navigated to project root: $(pwd)"

echo "Cleaning up old build artifacts..."
rm -rf build dist pywinsparkle.egg-info

echo ""
echo "Building 64-bit wheel (win_amd64)..."
python setup.py bdist_wheel --plat-name=win_amd64

#echo ""
#echo "Building 32-bit wheel (win32)..."
#python setup.py bdist_wheel --plat-name=win32

echo ""
echo "Build complete. Generated wheels are in the 'dist' directory:"
ls -l dist/

echo "Done."
