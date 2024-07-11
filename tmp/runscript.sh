#!/bin/sh

# Copyright (c) 2020 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

# This file is the script that runs on the gem5 guest. This reads a file from the host via m5 readfile
# which contains the workload and the size to run. Then it resets the stats before running the workload.
# Finally, it exits the simulation after running the workload, then it copies out the result file to be checked.

cd /home/gem5/spec2017
source shrc
m5 readfile > workloads
echo "Done reading workloads"
if [ -s workloads ]; then
    # if the file is not empty, run spec with the parameters
    echo "Workload detected"
    echo "Reset stats"

    # run the commands
    read -r workload size m5filespath < workloads
    go $workload run
    cd ./run_base_refrate_mytest-m64.0000

    ARGS=
    if [ $workload = "500.perlbench_r" ]; then
        ARGS="-I./lib diffmail.pl 4 800 10 17 19 300"
    elif [ $workload = "502.gcc_r" ]; then
        ARGS="ref32.c -O3 -fselective-scheduling -fselective-scheduling2 -o ref32.opts-O3_-fselective-scheduling_-fselective-scheduling2.s"
    elif [ $workload = "503.bwaves_r" ]; then
        ARGS="< bwaves_1.in"
    elif [ $workload = "505.mcf_r" ]; then
        ARGS="inp.in"
    elif [ $workload = "507.cactuBSSN_r" ]; then
        ARGS="spec_ref.par"
    elif [ $workload = "508.namd_r" ]; then
        ARGS="--input apoa1.input --output apoa1.ref.output --iterations 65"
    elif [ $workload = "510.parest_r" ]; then
        ARGS="ref.prm"
    elif [ $workload = "511.povray_r" ]; then
        ARGS="SPEC-benchmark-ref.ini"
    elif [ $workload = "519.lbm_r" ]; then
        ARGS="3000 reference.dat 0 0 100_100_130_ldc.of"
    elif [ $workload = "520.omnetpp_r" ]; then
        ARGS="-c General -r 0"
    elif [ $workload = "521.wrf_r" ]; then
        ARGS="" 
    elif [ $workload = "523.xalancbmk_r" ]; then
        ARGS="-v t5.xml xalanc.xsl"
    elif [ $workload = "525.x264_r" ]; then
        ARGS="--pass 1 --stats x264_stats.log --bitrate 1000 --frames 1000 -o BuckBunny_New.264 BuckBunny.yuv 1280x720"
    elif [ $workload = "526.blender_r" ]; then
        ARGS="sh3_no_char.blend --render-output sh3_no_char_ --threads 1 -b -F RAWTGA -s 849 -e 849 -a"
    elif [ $workload = "527.cam4_r" ]; then
        ARGS=""
    elif [ $workload = "531.deepsjeng_r" ]; then
        ARGS="ref.txt"
    elif [ $workload = "538.imagick_r" ]; then
        ARGS="-limit disk 0 refrate_input.tga -edge 41 -resample 181% -emboss 31 -colorspace YUV -mean-shift 19x19+15% -resize 30% refrate_output.tga"
    elif [ $workload = "541.leela_r" ]; then
        ARGS="ref.sgf"
    elif [ $workload = "544.nab_r" ]; then
        ARGS="1am0 1122214447 122"
    elif [ $workload = "548.exchange2_r" ]; then
        ARGS="6"
    elif [ $workload = "549.fotonik3d_r" ]; then
        ARGS=""
    elif [ $workload = "554.roms_r" ]; then
        ARGS="< ocean_benchmark2.in.x"
    elif [ $workload = "557.xz_r" ]; then
        ARGS="input.combined.xz 250 a841f68f38572a49d86226b7ff5baeb31bd19dc637a922a972b2e6d1257a890f6a544ecab967c313e370478c74f760eb229d4eef8a8d2836d233d3e9dd1430bf 40401484 41217675 7"
    else
        echo "Invalid workload selected. Terminate"
        m5 exit
        m5 exit
        m5 exit
    fi

    workload=$(echo $workload | sed 's/^[0-9.]*//')
    echo "Run workload as: ./$workload $ARGS"
    m5 exit
    ./$workload $ARGS

    m5 exit
    m5 exit
else
    echo "Couldn't find any workload"
    m5 exit
    m5 exit
    m5 exit
fi
# otherwise, drop to the terminal
