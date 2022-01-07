run_onecase() {
    ue=$1
    for i in $(seq 0 2); do
        let "allue=10*$ue"
        ../../LTE-Sim SingleCellWithI 3 1 $allue 0 0 1 0 7 1 30 0.1 128 $i ${ue}ues/config 2> ${ue}ues/nvs_pf$i.log > /dev/null &
        ../../LTE-Sim SingleCellWithI 3 1 $allue 0 0 1 0 8 1 30 0.1 128 $i ${ue}ues/config 2> ${ue}ues/greedy_pf$i.log > /dev/null &
        ../../LTE-Sim SingleCellWithI 3 1 $allue 0 0 1 0 9 1 30 0.1 128 $i ${ue}ues/config 2> ${ue}ues/subopt_pf$i.log > /dev/null
        #../../LTE-Sim SingleCellWithI 3 1 $allue 0 0 1 0 10 1 30 0.1 128 $i ${ue}ues/config 2> ${ue}ues/maxcell_pf$i.log > /dev/null
        #../../LTE-Sim SingleCellWithI 3 1 $allue 0 0 1 0 11 1 30 0.1 128 $i ${ue}ues/config 2> ${ue}ues/vogel_pf$i.log > /dev/null
    done
}

for ue in "20" "40"; do
  run_onecase $ue &
done

