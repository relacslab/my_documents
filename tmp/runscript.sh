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

    RUN_PATH=
    if [ $size = "ref" ]; then
        RUN_PATH="run_base_refrate_mytest-m64.0000"
    elif [ $size = "test" ]; then
        RUN_PATH="run_base_test_mytest-m64.0000"
    elif [ $size = "train" ]; then
        RUN_PATH="run_base_train_mytest-m64.0000"
        echo "Currently sole-run mode does not support train arguments"
        m5 exit
        m5 exit
        m5 exit
    fi

    ARGS=
    OFILE_PREFIX=
    if [ $workload = "500.perlbench_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="-I./lib diffmail.pl 4 800 10 17 19 300"
            OFILE_PREFIX="diffmail.4.800.10.17.19.300"
        elif [ $size = "test" ]; then
            ARGS="-I. -I./lib test.pl"
            OFILE_PREFIX="perl_test"
        fi
    elif [ $workload = "502.gcc_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="ref32.c -O3 -fselective-scheduling -fselective-scheduling2 -o ref32.opts-O3_-fselective-scheduling_-fselective-scheduling2.s"
            OFILE_PREFIX="ref32.opts-O3_-fselective-scheduling_-fselective-scheduling2"
        elif [ $size = "test" ]; then
            ARGS="t1.c -O3 -finline-limit=50000 -o t1.opts-O3_-finline-limit_50000.s"
            OFILE_PREFIX="t1.opts-O3_-finline-limit_50000"
        fi
    elif [ $workload = "503.bwaves_r" ]; then
        ARGS="bwaves_1 < bwaves_1.in"
        OFILE_PREFIX="bwaves_1"
    elif [ $workload = "505.mcf_r" ]; then
        ARGS="inp.in"
        OFILE_PREFIX="inp"
    elif [ $workload = "507.cactuBSSN_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="spec_ref.par"
            OFILE_PREFIX="spec_ref"
        elif [ $size = "test" ]; then
            ARGS="spec_test.par"
           OFILE_PREFIX="spec_test" 
        fi
    elif [ $workload = "508.namd_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="--input apoa1.input --output apoa1.ref.output --iterations 65"
            OFILE_PREFIX="namd_apoa1_iter65"
        elif [ $size = "test" ]; then
            ARGS="--input apoa1.input --iterations 1 --output apoa1.test.output > namd_apoa1_iter1.out 2>> namd_apoa1_iter1.err" 
            OFILE_PREFIX="namd_apoa1_iter1"
        fi
    elif [ $workload = "510.parest_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="ref.prm"
            OFILE_PREFIX="parest_ref"
        elif [ $size = "test" ]; then
            ARGS="test.prm"
            OFILE_PREFIX="parest_test"
        fi
    elif [ $workload = "511.povray_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="SPEC-benchmark-ref.ini"
            OFILE_PREFIX="SPEC-benchmark-ref"
        elif [ $size = "test" ]; then
            ARGS="SPEC-benchmark-test.ini > SPEC-benchmark-test.stdout 2>> SPEC-benchmark-test.stderr"
            OFILE_PREFIX="SPEC-benchmark-test"
        fi
    elif [ $workload = "519.lbm_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="3000 reference.dat 0 0 100_100_130_ldc.of"
            OFILE_PREFIX="lbm_ldc"
        elif [ $size = "test" ]; then
            ARGS="20 reference.dat 0 0 100_100_130_cf_a.of"
            OFILE_PREFIX="lbm_cf_a"
        fi
    elif [ $workload = "520.omnetpp_r" ]; then
        ARGS="-c General -r 0"
        OFILE_PREFIX="omentpp.General-0"
    elif [ $workload = "521.wrf_r" ]; then
        ARGS="" 
        OFILE_PREFIX="wrf"
    elif [ $workload = "523.xalancbmk_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="-v t5.xml xalanc.xsl"
            OFILE_PREFIX="ref-t5"
        elif [ $size = "test" ]; then
            ARGS="-v test.xml xalanc.xsl > test-test.out 2>> test-test.err"
            OFILE_PREFIX="test-test"
        fi
    elif [ $workload = "525.x264_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="--pass 1 --stats x264_stats.log --bitrate 1000 --frames 1000 -o BuckBunny_New.264 BuckBunny.yuv 1280x720"
            OFILE_PREFIX="run_000-1000_x264_pass1"
        elif [ $size = "test" ]; then
            ARGS="--dumpyuv 50 --frames 156 -o BuckBunny_New.264 BuckBunny.yuv 1280x720" 
            OFILE_PREFIX="run_000-156_x264_pass1"
        fi
    elif [ $workload = "526.blender_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="sh3_no_char.blend --render-output sh3_no_char_ --threads 1 -b -F RAWTGA -s 849 -e 849 -a"
            OFILE_PREFIX="sh3_no_char.849.spec"
        elif [ $size = "test" ]; then
            ARGS="cube.blend --render-output cube_ --threads 1 -b -F RAWTGA -s 1 -e 1 -a"
           OFILE_PREFIX="cube.1.spec" 
        fi
    elif [ $workload = "527.cam4_r" ]; then
        ARGS=""
        OFILE_PREFIX="cam4"
    elif [ $workload = "531.deepsjeng_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="ref.txt"
            OFILE_PREFIX="deepsjeng_ref"
        elif [ $size = "test" ]; then
            ARGS="test.txt > deepsjeng_test.out 2>> deepsjeng_test.err"
            OFILE_PREFIX="deepsjeng_test"
        fi
    elif [ $workload = "538.imagick_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="-limit disk 0 refrate_input.tga -edge 41 -resample 181% -emboss 31 -colorspace YUV -mean-shift 19x19+15% -resize 30% refrate_output.tga"
            OFILE_PREFIX="refrate_convert"
        elif [ $size = "test" ]; then
            ARGS="-limit disk 0 test_input.tga -shear 25 -resize 640x480 -negate -alpha Off test_output.tga" 
            OFILE_PREFIX="test_convert"
        fi
    elif [ $workload = "541.leela_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="ref.sgf"
            OFILE_PREFIX="leela_ref"
        elif [ $size = "test" ]; then
            ARGS="test.sgf"
            OFILE_PREFIX="leela_test"
        fi
    elif [ $workload = "544.nab_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="1am0 1122214447 122"
            OFILE_PREFIX="1am0"
        elif [ $size = "test" ]; then
            ARGS="hkrdenq 1930344093 1000" 
            OFILE_PREFIX="hkrdenq"
        fi
    elif [ $workload = "548.exchange2_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="6"
            OFILE_PREFIX="exchange2_6"
        elif [ $size = "test" ]; then
            ARGS="0"
            OFILE_PREFIX="exchange2_0"
        fi
    elif [ $workload = "549.fotonik3d_r" ]; then
        ARGS=""
        OFILE_PREFIX="fotonik3d"
    elif [ $workload = "554.roms_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="< ocean_benchmark2.in.x"
            OFILE_PREFIX="ocean_benchmark2"
        elif [ $size = "test" ]; then
            ARGS="< ocean_benchmark0.in.x"
            OFILE_PREFIX="ocean_benchmark0"
        fi
    elif [ $workload = "557.xz_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="cpu2006docs.tar.xz 250 055ce243071129412e9dd0b3b69a21654033a9b723d874b2015c774fac1553d9713be561ca86f74e4f16f22e664fc17a79f30caa5ad2c04fbc447549c2810fae 23047774 23513385 6e"
            OFILE_PREFIX="cpu2006docs.tar-250-6e"
#            ARGS="input.combined.xz 250 a841f68f38572a49d86226b7ff5baeb31bd19dc637a922a972b2e6d1257a890f6a544ecab967c313e370478c74f760eb229d4eef8a8d2836d233d3e9dd1430bf 40401484 41217675 7 > input.combined-250-7.out 2>> input.combined-250-7.err"
#            OFILE_PREFIX="input.combined.tar-250-7"
        elif [ $size = "test" ]; then
            ARGS="cpu2006docs.tar.xz 4 055ce243071129412e9dd0b3b69a21654033a9b723d874b2015c774fac1553d9713be561ca86f74e4f16f22e664fc17a79f30caa5ad2c04fbc447549c2810fae 1548636 1555348 0 > cpu2006docs.tar-4-0.out 2>> cpu2006docs.tar-4-0.err" 
            OFILE_PREFIX="cpu2006docs.tar-4-0"
        fi
    else
        echo "Invalid workload selected. Terminate"
        m5 exit
        m5 exit
        m5 exit
    fi

    echo "Enter root run directory of $workload"
    go $workload run
    echo "Enter $RUN_PATH to run $workload"
    cd $RUN_PATH

    workload=$(echo $workload | sed 's/^[0-9.]*//')
    echo "Run workload as: ./$workload $ARGS"

    m5 exit
    ./$workload $ARGS > $OFILE_PREFIX".out" 2> $OFILE_PREFIX".err"

    m5 exit
    for filepath in $(pwd)/*; do
        filename=$(basename $filepath)
        m5 writefile $filepath $m5filespath/$filename
    done 
    m5 exit
else
    echo "Couldn't find any workload"
    m5 exit
    m5 exit
    m5 exit
fi
# otherwise, drop to the terminal
