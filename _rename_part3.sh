#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")

# change brand (rough)
sed -i 's/Intel(R) Math Kernel Library for Deep Neural Networks/Deep Neural Network Library/g' tests/benchdnn/README.md

sed -i 's/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g' tests/benchdnn/README.md

sed -i 's/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g;s/mkl-dnn/DNNL/g' \
    tests/benchdnn/conv/cfg.cpp \
    tests/benchdnn/doc/driver_conv.md \
    tests/benchdnn/ip/cfg.cpp \
    tests/benchdnn/mkldnn_common.cpp \
    tests/benchdnn/reorder/reorder.cpp \
    tests/gtests/main.cpp \
    tests/gtests/test_eltwise.cpp \
    tests/gtests/test_lrn_backward.cpp \
    tests/gtests/test_lrn_forward.cpp \
    tests/other/subproject/CMakeLists.txt

sed -i 's/DNNL 0.14/MKL-DNN 0.14/g' \
    tests/gtests/test_lrn_backward.cpp \
    tests/gtests/test_lrn_forward.cpp

# mkldnn -> dnnl
find tests -type f -exec \
    sed -i 's/mkldnn/dnnl/g;s/MKLDNN/DNNL/g' {} \;

# move files
fs=$(find tests -type f -name \*mkldnn\*)
for f in ${fs[@]}; do
    t=${f/mkldnn/dnnl}
    mv $f $t
done

#
# Re-enable tests
#
sed -i 's/# add_subdirectory(tests)/add_subdirectory(tests)/g' CMakeLists.txt
