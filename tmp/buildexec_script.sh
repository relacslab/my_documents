CONFIG_NAME=myconfig.x86.cfg
CPU_HOME_DIR=/home/gem5/spec2017
CPU_BASE_DIR=$CPU_HOME_DIR'/benchspec/CPU'
BUILD_BASE_DIR=build/build_base_myconfig-cpu-m64.0000
RUN_BASE_DIR=run/run_base_refrate_hklee-cpu-m64.0000
BUILD_CPU_ARG=
BENCHMARK_NAME=

cd $CPU_HOME_DIR
source ./shrc

for i in {1..23..1}
do
    if [ $i -eq 1 ]; then
        BENCHMARK_NAME=500.perlbench_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 2 ]; then
        BENCHMARK_NAME=502.gcc_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 3 ]; then
        BENCHMARK_NAME=503.bwaves_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 4 ]; then
        BENCHMARK_NAME=505.mcf_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 5 ]; then
        BENCHMARK_NAME=507.cactuBSSN_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 6 ]; then
        BENCHMARK_NAME=508.namd_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 7 ]; then
        BENCHMARK_NAME=510.parest_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 8 ]; then
        BENCHMARK_NAME=511.povray_r
        BUILD_CPU_ARG='TARGET=povray_r'
    elif [ $i -eq 9 ]; then
        BENCHMARK_NAME=519.lbm_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 10 ]; then
        BENCHMARK_NAME=520.omnetpp_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 11 ]; then
        BENCHMARK_NAME=521.wrf_r
        BUILD_CPU_ARG='TARGET=wrf_r'
    elif [ $i -eq 12 ]; then
        BENCHMARK_NAME=523.xalancbmk_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 13 ]; then
        BENCHMARK_NAME=525.x264_r
        BUILD_CPU_ARG='TARGET=x264_r'
    elif [ $i -eq 14 ]; then
        BENCHMARK_NAME=526.blender_r
        BUILD_CPU_ARG='TARGET=blender_r'
    elif [ $i -eq 15 ]; then
        BENCHMARK_NAME=527.cam4_r
        BUILD_CPU_ARG='TARGET=cam4_r'
    elif [ $i -eq 16 ]; then
        BENCHMARK_NAME=531.deepsjeng_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 17 ]; then
        BENCHMARK_NAME=538.imagick_r
        BUILD_CPU_ARG='TARGET=imagick_r'
    elif [ $i -eq 18 ]; then
        BENCHMARK_NAME=541.leela_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 19 ]; then
        BENCHMARK_NAME=544.nab_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 20 ]; then
        BENCHMARK_NAME=548.exchange2_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 21 ]; then
        BENCHMARK_NAME=549.fotonik3d_r
        BUILD_CPU_ARG=''
    elif [ $i -eq 22 ]; then
        BENCHMARK_NAME=554.roms_r
        BUILD_CPU_ARG=''
    else
        BENCHMARK_NAME=557.xz_r
        BUILD_CPU_ARG=''
    fi

    runcpu --fake --loose --size ref --tune base --config $CONFIG_NAME $BENCHMARK_NAME
    cd $CPU_BASE_DIR'/'$BENCHMARK_NAME'/'$BUILD_BASE_DIR
    specmake $BUILD_CPU_ARG clean
    specmake $BUILD_CPU_ARG -j4
    
    if [ $BENCHMARK_NAME == "525.x264_r" ]; then
        BUILD_CPU_ARG='TARGET=ldecod_r'
        specmake $BUILD_CPU_ARG clean
        specmake $BUILD_CPU_ARG -j4
        ./ldecod_r -i $CPU_BASE_DIR'/'$BENCHMARK_NAME'/data/refrate/input/BuckBunny.264' -o $CPU_BASE_DIR'/'$BENCHMARK_NAME'/'$RUN_BASE_DIR'/BuckBunny.yuv'
    elif [ $BENCHMARK_NAME == "549.fotonik3d_r" ]; then
        cd $CPU_BASE_DIR'/'$BENCHMARK_NAME'/'$RUN_BASE_DIR
        xz OBJ.dat.xz
    fi
    
    cd $CPU_HOME_DIR
done

