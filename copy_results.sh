#!/bin/bash

## Copy HSPICE results from the ssh server to the host machine

source "./.secrets.sh"

destination_folder="/home/cotti/Desktop/VLSI/matlab"
source_folder="/home/users/alumnos_VLSI/alumnos_VLSI_02/Proyecto_VLSI/results/LAB_cotti,LAB01_cotti,schematic/history_1/simulation/state_a/PrimeSimHSPICE"

## Script
rm -r "PrimeSimHSPICE"
sshpass -p "${pass}" scp -r "${user}@${ip}":"${source_folder}" "${destination_folder}"
