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
    if [ $workload = "500.perlbench_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="-I./lib diffmail.pl 4 800 10 17 19 300 > diffmail.4.800.10.17.19.300.out 2>> diffmail.4.800.10.17.19.300.err"
        elif [ $size = "test" ]; then
            ARGS="-I. -I./lib test.pl > test.out 2>> test.err"
        fi
    elif [ $workload = "502.gcc_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="ref32.c -O3 -fselective-scheduling -fselective-scheduling2 -o ref32.opts-O3_-fselective-scheduling_-fselective-scheduling2.s > ref32.opts-O3_-fselective-scheduling_-fselective-scheduling2.out 2>> ref32.opts-O3_-fselective-scheduling_-fselective-scheduling2.err"
        elif [ $size = "test" ]; then
            ARGS="t1.c -O3 -finline-limit=50000 -o t1.opts-O3_-finline-limit_50000.s > t1.opts-O3_-finline-limit_50000.out 2>> t1.opts-O3_-finline-limit_50000.err"
        fi
    elif [ $workload = "503.bwaves_r" ]; then
        ARGS="bwaves_1 < bwaves_1.in > bwaves_1.out 2>> bwaves_1.err"
    elif [ $workload = "505.mcf_r" ]; then
        ARGS="inp.in > inp.out 2>> inp.err"
    elif [ $workload = "507.cactuBSSN_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="spec_ref.par > spec_ref.out 2>> spec_ref.err"
        elif [ $size = "test" ]; then
            ARGS="spec_test.par > spec_test.out 2>> spec_ref.err" 
        fi
    elif [ $workload = "508.namd_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="--input apoa1.input --output apoa1.ref.output --iterations 65 > namd_apoa1_iter65.out 2>> namd_apoa1_iter65.err"
        elif [ $size = "test" ]; then
            ARGS="--input apoa1.input --iterations 1 --output apoa1.test.output > namd_apoa1_iter1.out 2>> namd_apoa1_iter1.err" 
        fi
    elif [ $workload = "510.parest_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="ref.prm > parest_ref.out 2>> parest_ref.err"
        elif [ $size = "test" ]; then
            ARGS="test.prm > parest_test.out 2>> parest_test.err"
        fi
    elif [ $workload = "511.povray_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="SPEC-benchmark-ref.ini > SPEC-benchmark-ref.stdout 2>> SPEC-benchmark-ref.stderr"
        elif [ $size = "test" ]; then
            ARGS="SPEC-benchmark-test.ini > SPEC-benchmark-test.stdout 2>> SPEC-benchmark-test.stderr"
        fi
    elif [ $workload = "519.lbm_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="3000 reference.dat 0 0 100_100_130_ldc.of > lbm_ldc.out 2>> lbm_ldc.err"
        elif [ $size = "test" ]; then
            ARGS="20 reference.dat 0 0 100_100_130_cf_a.of > lbm_cf_a.out 2>> lbm_cf_a.err"
        fi
    elif [ $workload = "520.omnetpp_r" ]; then
        ARGS="-c General -r 0 > omentpp.General-0.out 2>> omnetpp.General-0.err"
    elif [ $workload = "521.wrf_r" ]; then
        ARGS="> rsl.out.0000 2>> wrf.err" 
    elif [ $workload = "523.xalancbmk_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="-v t5.xml xalanc.xsl > ref-t5.out 2>> ref-t5.err"
        elif [ $size = "test" ]; then
            ARGS="-v test.xml xalanc.xsl > test-test.out 2>> test-test.err"
        fi
    elif [ $workload = "525.x264_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="--pass 1 --stats x264_stats.log --bitrate 1000 --frames 1000 -o BuckBunny_New.264 BuckBunny.yuv 1280x720 > run_000-1000_x264_pass1.out 2>> run_000-1000_x264_pass1.err"
        elif [ $size = "test" ]; then
            ARGS="--dumpyuv 50 --frames 156 -o BuckBunny_New.264 BuckBunny.yuv 1280x720 > run_000-156_x264.out 2>> run_000-156_x264.err" 
        fi
    elif [ $workload = "526.blender_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="sh3_no_char.blend --render-output sh3_no_char_ --threads 1 -b -F RAWTGA -s 849 -e 849 -a > sh3_no_char.849.spec.out 2>> sh3_no_char.849.spec.err"
        elif [ $size = "test" ]; then
            ARGS="cube.blend --render-output cube_ --threads 1 -b -F RAWTGA -s 1 -e 1 -a > cube.1.spec.out 2>> cube.1.spec.err" 
        fi
    elif [ $workload = "527.cam4_r" ]; then
        ARGS="> cam4.out 2>> cam4.err"
    elif [ $workload = "531.deepsjeng_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="ref.txt > deepsjeng_ref.out 2>> deepsjeng_ref.err"
        elif [ $size = "test" ]; then
            ARGS="test.txt > deepsjeng_test.out 2>> deepsjeng_test.err"
        fi
    elif [ $workload = "538.imagick_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="-limit disk 0 refrate_input.tga -edge 41 -resample 181% -emboss 31 -colorspace YUV -mean-shift 19x19+15% -resize 30% refrate_output.tga > refrate_convert.out 2>> refrate_convert.err"
        elif [ $size = "test" ]; then
            ARGS="-limit disk 0 test_input.tga -shear 25 -resize 640x480 -negate -alpha Off test_output.tga > test_convert.out 2>> test_convert.err" 
        fi
    elif [ $workload = "541.leela_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="ref.sgf > leela_ref.out 2>> leela_ref.err"
        elif [ $size = "test" ]; then
            ARGS="test.sgf > leela_test.out 2>> leela_test.err"
        fi
    elif [ $workload = "544.nab_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="1am0 1122214447 122 > 1am0.out 2>> 1am0.err"
        elif [ $size = "test" ]; then
            ARGS="hkrdenq 1930344093 1000 > hkrdenq.out 2>> hkrdenq.err" 
        fi
    elif [ $workload = "548.exchange2_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="6 > exchange2_6.out 2>> exchange2_6.err"
        elif [ $size = "test" ]; then
            ARGS="0 > exchange2_0.out 2>> exchange2_0.err"
        fi
    elif [ $workload = "549.fotonik3d_r" ]; then
        ARGS="> fotonik3d.out 2>> fotonik3d.err"
    elif [ $workload = "554.roms_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="< ocean_benchmark2.in.x > ocean_benchmark2.log 2>> ocean_benchmark2.err"
        elif [ $size = "test" ]; then
            ARGS="< ocean_benchmark0.in.x > ocean_benchmark0.log 2>> ocean_benchmark0.err"
        fi
    elif [ $workload = "557.xz_r" ]; then
        if [ $size = "ref" ]; then
            ARGS="cpu2006docs.tar.xz 250 055ce243071129412e9dd0b3b69a21654033a9b723d874b2015c774fac1553d9713be561ca86f74e4f16f22e664fc17a79f30caa5ad2c04fbc447549c2810fae 23047774 23513385 6e > cpu2006docs.tar-250-6e.out 2>> cpu2006docs.tar-250-6e.err"
#            ARGS="input.combined.xz 250 a841f68f38572a49d86226b7ff5baeb31bd19dc637a922a972b2e6d1257a890f6a544ecab967c313e370478c74f760eb229d4eef8a8d2836d233d3e9dd1430bf 40401484 41217675 7 > input.combined-250-7.out 2>> input.combined-250-7.err"
        elif [ $size = "test" ]; then
            ARGS="cpu2006docs.tar.xz 4 055ce243071129412e9dd0b3b69a21654033a9b723d874b2015c774fac1553d9713be561ca86f74e4f16f22e664fc17a79f30caa5ad2c04fbc447549c2810fae 1548636 1555348 0 > cpu2006docs.tar-4-0.out 2>> cpu2006docs.tar-4-0.err" 
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
    ./$workload $ARGS

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
