#!/bin/bash


# ./pddlGen numLlibres numPreds numParals numWants

MAXNBOOKS=$1
FPRED=$2
FPARAL=$3
FWANT=$4

echo $MAXNBOOKS,$FPRED,$FPARAL,$FPARAL,$FWANT

for (( N = 1; N <= MAXNBOOKS; N++ ))
do
	NPREDS=$(  echo "$N * $FPRED"  | bc | awk '{print int($1)}' )
	NPARALS=$( echo "$N * $FPARAL" | bc | awk '{print int($1)}' )
	NWANTS=$(  echo "$N * $FWANT"  | bc | awk '{print int($1)}' )
	
	>&2 echo $N $NPREDS $NPARALS $NWANTS
	
	./pddlGen $N $NPREDS $NPARALS $NWANTS > tmp$N
	TIME=$( ./ff -o reading_plan.pddl -f tmp$N 2> error.log | tail -2 | head -1 | cut -c16-19 )
	if [[ $( cat error.log ) == "" ]]
	then
		if [[ $TIME == " sim" ]] 
		then
			echo -n 0.0,
		else
			echo -n $TIME,
		fi
	else
		echo ""
		echo "Wrong parameters"
		exit
	fi
done
