#!/bin/bash
# KNU environment for draw_pico
# AlmaLinux 9 + CMSSW_16_0_2

########################################
# Kernel (used by SConstruct)
########################################
export RUN_KERNEL=$(uname -r | cut -d '-' -f1)

########################################
# Project base directory
########################################
BASE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

########################################
# Tell SConstruct which script to source
########################################
export SET_ENV_PATH="$BASE_DIR/set_env_knu.sh"

########################################
# CMSSW setup (NO OUTPUT!)
########################################
source /cvmfs/cms.cern.ch/cmsset_default.sh >/dev/null 2>&1
cd /u/user/sucho/draw_pico/CMSSW_16_0_2/src
cmsenv >/dev/null 2>&1
cd - >/dev/null 2>&1

########################################
# SCons settings
########################################
export SCONSFLAGS="-j $(nproc --all)"

########################################
# Runtime libraries (kernel dependent)
########################################
export LD_LIBRARY_PATH="$BASE_DIR/lib/$RUN_KERNEL${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

########################################
# Keep python clean for SCons
########################################
export PYTHONPATH=""
unset PYTHONHOME

########################################
# Optional local path
########################################
export LOCAL_PICO_DIR=""

########################################
# Force SCons to use CMSSW python
########################################
scons() { python3 /usr/bin/scons "$@"; }
