#!/bin/bash
#PBS -N jevs_nam_firewxnest_grid2obs_plots_00
#PBS -j oe
#PBS -S /bin/bash
#PBS -q "dev"
#PBS -A EVS-DEV
#PBS -l walltime=02:00:00
#PBS -l select=1:ncpus=1:mem=2GB
#PBS -l debug=true

export model=evs

export HOMEevs=/lfs/h2/emc/vpppg/noscrub/$USER/EVS

source $HOMEevs/versions/run.ver

###%include <head.h>
###%include <envir-p1.h>

############################################################
# Load modules
############################################################
set -x

module reset
export HPC_OPT=/apps/ops/para/libs
module use /apps/ops/para/libs/modulefiles/compiler/intel/${intel_ver}
module use /apps/dev/modulefiles
module load ve/evs/${ve_evs_ver}
module load cray-mpich/${craympich_ver}
module load cray-pals/${craypals_ver}
module load grib_util/${grib_util_ver}
module load wgrib2/${wgrib2_ver}
module load gsl/${gsl_ver}
module load met/${met_ver}
module load metplus/${metplus_ver}
module load prod_util/${produtil_ver}
module load prod_envir/${prodenvir_ver}
module load imagemagick/${imagemagick_ver}

module list

export FIXevs=/lfs/h2/emc/vpppg/noscrub/emc.vpppg/verification/EVS_fix
export DATAROOT=/lfs/h2/emc/stmp/${USER}/evs_test/$envir/tmp
export KEEPDATA=NO

export cyc=00
export envir=prod
export NET=evs
export STEP=plots
export COMPONENT=cam
export RUN=atmos
export VERIF_CASE=grid2obs
export MODELNAME=nam_firewxnest
export modsys=nam
export mod_ver=${nam_ver}

export job=${PBS_JOBNAME:-jevs_${MODELNAME}_${VERIF_CASE}_${STEP}}
export jobid=$job.${PBS_JOBID:-$$}

export config=$HOMEevs/parm/evs_config/cam/config.evs.cam_nam_firewxnest.prod
source $config

export COMIN=/lfs/h2/emc/vpppg/noscrub/$USER/${NET}/${evs_ver}
export COMOUT=/lfs/h2/emc/ptmp/$USER/${NET}/${evs_ver}
export COMINnam=${COMIN}/stats/${COMPONENT}/${MODELNAME}

# CALL executable job script here
$HOMEevs/jobs/cam/plots/JEVS_CAM_PLOTS

######################################################################
## Purpose: This job will generate the grid2obs statistics for the NAM_FIREWXNEST
##          model and generate stat files.
#######################################################################
#
exit

