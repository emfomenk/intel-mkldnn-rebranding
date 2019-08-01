#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")

compat=tests/mkldnn_compat

rm -rf $compat
mkdir -p $compat

#
# Examples
#

cp -r examples $compat/
e=$compat/examples

sed -i '/NOT DNNL_BUILD_EXAMPLES/,+3d' $e/CMakeLists.txt
sed -i '/BUNDLE/,+100d' $e/CMakeLists.txt
# sed -i 's/DNNL/MKLDNN/g' $e/CMakeLists.txt # postpone till part5
sed -i 's/register_exe(/register_exe(mkldnn-compat-/g' $e/CMakeLists.txt
sed -i 's/add_test("\([cg]\)pu.*/add_test("mkldnn-compat-\1pu-${example_name}" "mkldnn-compat-${example_name}" \1pu)/g' $e/CMakeLists.txt
sed -i 's/maybe_configure_windows_test("/maybe_configure_windows_test("mkldnn-compat-/g' $e/CMakeLists.txt


rm -f $e/CMakeLists.txt.in

# reduce testing time
sed -i 's/int times = 100/int times = 1/g' $e/cnn_inference_f32.cpp
sed -i 's/const int batch = [0-9]\+/const int batch = 1/g;s/BATCH 8/BATCH 1/g;s/BATCH 32/BATCH 1/g' \
    $e/cnn_inference_f32.c \
    $e/cpu_cnn_training_f32.c \
    $e/cnn_inference_int8.cpp \
    $e/cpu_cnn_training_bf16.cpp \
    $e/cnn_training_f32.cpp

sed -i 's/BATCH = [0-9]\+/BATCH = 1/g' $e/performance_profiling.cpp

sed -i 's/1024/64/g' \
    $e/cpu_rnn_inference_int8.cpp \
    $e/cpu_rnn_inference_f32.cpp \
    $e/rnn_training_f32.cpp

#
# Add CMakeLists.txt
#

cat > $compat/CMakeLists.txt << EOC
#===============================================================================
# Copyright 2019 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#===============================================================================

add_subdirectory(examples)

EOC

#
# Add compat directory to tests/CMakeLists.txt
#
echo "add_subdirectory(mkldnn_compat)" >> tests/CMakeLists.txt

#
# Change examples to dnnl
#
sed -i 's/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g;s/Intel Mkl-DNN/DNNL/g' \
    examples/*.c* examples/*.h*
sed -i 's/mkldnn/dnnl/g;s/MKLDNN/DNNL/g' examples/*.c* examples/*.h*

sed -i 's/MKLDNN/DNNL/g;s/mkldnn/dnnl/g' examples/CMakeLists.txt.in
