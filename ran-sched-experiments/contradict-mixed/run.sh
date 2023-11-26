#!/bin/bash

TRACE_PATH="../../cqi-traces-noise0"

VALID_ENTERPRISE_ALGS=("mt" "pf" "mlwdf")

run_onecase() {
  local inter_sched=$1
  local enterprise_alg=$2
  local seed=$3

  # Determine interslice scheduling objective name
  local inter_sched_name=""
  if [ $inter_sched -eq 9 ]; then
    inter_sched_name="mt"
  elif [ $inter_sched -eq 91 ]; then
    inter_sched_name="pf"
  elif [ $inter_sched -eq 92 ]; then
    inter_sched_name="mlwdf"
  else
    echo -n "Invalid argument: inter_sched must be one of 9/91/92; "
    echo "got ${inter_sched}"
    return 1
  fi

  # Validate enterprise scheduling algorithm
  if [[ ! ${VALID_ENTERPRISE_ALGS[*]} =~ ${enterprise_alg} ]]; then
    echo -n "Invalid argument: enterprise_alg must be one of mt/pf/mlwdf; "
    echo "got ${enterprise_alg}"
    return 1
  fi

  ../../LTE-Sim SingleCellWithI \
  1 ${inter_sched} 1 30 ${seed} 12 \
  ./configs/config.json \
  2> ./logs/${enterprise_alg}-${inter_sched_name}-${seed}.log \
  > /dev/null &
}

run_experiments() {
  local enterprise_alg=$1

  for seed in $(seq 0 2); do
    cp ${TRACE_PATH}/mapping${seed}.config ${TRACE_PATH}/mapping.config
    run_onecase 9 ${enterprise_alg} ${seed}
    run_onecase 91 ${enterprise_alg} ${seed}
    run_onecase 92 ${enterprise_alg} ${seed}
    sleep 1
  done
}

if [ ! -d "./logs" ]; then
  mkdir ./logs
fi

for enterprise_alg in ${VALID_ENTERPRISE_ALGS[@]}; do
  echo "Running: enterprise ${enterprise_alg}"
  run_experiments ${enterprise_alg}
done
