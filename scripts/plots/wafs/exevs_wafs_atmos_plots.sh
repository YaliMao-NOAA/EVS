#!/bin/bash

set -x

export DATAplot=$DATA/plot
mkdir -p $DATAplot

export MPIRUN=${MPIRUN:-"mpiexec"}

OBSERVATIONS="GCIP GFS"

rm -f wafs_plots.cmdfile

ic=0
export VX_MASK_ALL="GLB ASIA AUNZ EAST NAMER NATL_AR2 NHEM NPO SHEM TROPICS"
for observation in $OBSERVATIONS ; do
    for ndays in $DAYS_LIST ; do
	for subregion in $VX_MASK_ALL ; do
	    if [ `echo $MPIRUN | cut -d " " -f1` = 'srun' ] ; then
		echo $ic $USHevs/evs_wafs_atmos_plots.sh $observation $ndays $subregion >> wafs_plots.cmdfile
	    else
		echo $USHevs/evs_wafs_atmos_plots.sh $observation $ndays $subregion >> wafs_plots.cmdfile
		export MP_PGMMODEL=mpmd
	    fi
	    ic=$(( ic + 1 ))
	done
    done
done
export MPIRUN="$MPIRUN -np $ic -cpu-bind verbose,core cfp"
$MPIRUN wafs_plots.cmdfile

export err=$?; err_chk

cd $DATAplot
for ndays in $DAYS_LIST ; do
    eval_period="last${ndays}days"
    tar -cvf $COMOUT/$NET.$STEP.${COMPONENT}.${RUN}.${VERIF_CASE}.$eval_period.v${VDATE}.tar *${eval_period}*png
done

#########################################
#Cat'ing errfiles to stdout
#########################################

log_dir=$DATA/logs
log_file_count=$(find $log_dir -type f |wc -l)
if [[ $log_file_count -ne 0 ]]; then
	for log_file in $log_dir/*; do                                  
		echo "Start: $log_file"
		cat $log_file                                                                   
		echo "End: $log_file"
	done
fi

echo "********SCRIPT exevs_wafs_atmos_plots.sh COMPLETED NORMALLY on `$NDATE`"
