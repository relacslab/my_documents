
CONFIG_NAME=HKLEE-CPU.cfg
CPU_HOME_DIR=/hdd1/cpu2017
CPU_BASE_DIR=$CPU_HOME_DIR'/benchspec/CPU'
BUILD_BASE_DIR=build/build_base_hklee-cpu-m64.0000
RUN_BASE_DIR=run/run_base_refrate_hklee-cpu-m64.0000
BENCHMARK_NUM=
BENCHMARK_NAME=
BENCHMARK_FULL_NAME=

cd $CPU_HOME_DIR

for i in {1..23..1}
do
    if [ $i -eq 1 ]; then
        BENCHMARK_NUM=500
        BENCHMARK_NAME=perlbench_r
        BENCHMARK_EXEC=perlbench_r
    elif [ $i -eq 2 ]; then
        BENCHMARK_NUM=502
        BENCHMARK_NAME=gcc_r
        BENCHMARK_EXEC=cpugcc_r
    elif [ $i -eq 3 ]; then
        BENCHMARK_NUM=503
        BENCHMARK_NAME=bwaves_r
        BENCHMARK_EXEC=bwaves_r
    elif [ $i -eq 4 ]; then
        BENCHMARK_NUM=505
        BENCHMARK_NAME=mcf_r
        BENCHMARK_EXEC=mcf_r
    elif [ $i -eq 5 ]; then
        BENCHMARK_NUM=507
        BENCHMARK_NAME=cactuBSSN_r
        BENCHMARK_EXEC=cactusBSSN_r
    elif [ $i -eq 6 ]; then
        BENCHMARK_NUM=508
        BENCHMARK_NAME=namd_r
        BENCHMARK_EXEC=namd_r
    elif [ $i -eq 7 ]; then
        BENCHMARK_NUM=510
        BENCHMARK_NAME=parest_r
        BENCHMARK_EXEC=parest_r
    elif [ $i -eq 8 ]; then
        BENCHMARK_NUM=511
        BENCHMARK_NAME=povray_r
        BENCHMARK_EXEC=povray_r
    elif [ $i -eq 9 ]; then
        BENCHMARK_NUM=519
        BENCHMARK_NAME=lbm_r
        BENCHMARK_EXEC=lbm_r
    elif [ $i -eq 10 ]; then
        BENCHMARK_NUM=520
        BENCHMARK_NAME=omnetpp_r
        BENCHMARK_EXEC=omnetpp_r
    elif [ $i -eq 11 ]; then
        BENCHMARK_NUM=521
        BENCHMARK_NAME=wrf_r
        BENCHMARK_EXEC=wrf_r
    elif [ $i -eq 12 ]; then
        BENCHMARK_NUM=523
        BENCHMARK_NAME=xalancbmk_r
        BENCHMARK_EXEC=cpuxalan_r
    elif [ $i -eq 13 ]; then
        BENCHMARK_NUM=525
        BENCHMARK_NAME=x264_r
        BENCHMARK_EXEC=x264_r
    elif [ $i -eq 14 ]; then
        BENCHMARK_NUM=526
        BENCHMARK_NAME=blender_r
        BENCHMARK_EXEC=blender_r
    elif [ $i -eq 15 ]; then
        BENCHMARK_NUM=527
        BENCHMARK_NAME=cam4_r
        BENCHMARK_EXEC=cam4_r
    elif [ $i -eq 16 ]; then
        BENCHMARK_NUM=531
        BENCHMARK_NAME=deepsjeng_r
        BENCHMARK_EXEC=deepsjeng_r
    elif [ $i -eq 17 ]; then
        BENCHMARK_NUM=538
        BENCHMARK_NAME=imagick_r
        BENCHMARK_EXEC=imagick_r
    elif [ $i -eq 18 ]; then
        BENCHMARK_NUM=541
        BENCHMARK_NAME=leela_r
        BENCHMARK_EXEC=leela_r
    elif [ $i -eq 19 ]; then
        BENCHMARK_NUM=544
        BENCHMARK_NAME=nab_r
        BENCHMARK_EXEC=nab_r
    elif [ $i -eq 20 ]; then
        BENCHMARK_NUM=548
        BENCHMARK_NAME=exchange2_r
        BENCHMARK_EXEC=exchange2_r
    elif [ $i -eq 21 ]; then
        BENCHMARK_NUM=549
        BENCHMARK_NAME=fotonik3d_r
        BENCHMARK_EXEC=fotonik3d_r
    elif [ $i -eq 22 ]; then
        BENCHMARK_NUM=554
        BENCHMARK_NAME=roms_r
        BENCHMARK_EXEC=roms_r
    else
        BENCHMARK_NUM=557
        BENCHMARK_NAME=xz_r
        BENCHMARK_EXEC=xz_r
    fi

    BENCHMARK_FULL_NAME=$BENCHMARK_NUM'.'$BENCHMARK_NAME
    cp $CPU_BASE_DIR'/'$BENCHMARK_FULL_NAME'/'$BUILD_BASE_DIR'/'$BENCHMARK_EXEC $CPU_BASE_DIR'/'$BENCHMARK_FULL_NAME'/'$RUN_BASE_DIR'/'$BENCHMARK_NAME
    ls $CPU_BASE_DIR'/'$BENCHMARK_FULL_NAME'/'$RUN_BASE_DIR'/'$BENCHMARK_NAME
done

