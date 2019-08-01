#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")

# change brand (rough)
sed -i 's/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g;s/mkl-dnn/DNNL/g' \
    src/common/nstl.hpp \
    src/common/primitive.hpp \
    src/common/utils.hpp \
    src/common/verbose.cpp \
    src/cpu/gemm/os_blas.hpp \
    src/cpu/jit_avx512_core_x8s8s32x_conv_kernel.cpp

# mkldnn -> dnnl
find src -type f -exec \
    sed -i 's/mkldnn/dnnl/g;s/MKLDNN/DNNL/g' {} \;

# move files
fs=$(find src -type f -name mkldnn\*)
for f in ${fs[@]}; do
    t=${f/mkldnn/dnnl}
    mv $f $t
done

