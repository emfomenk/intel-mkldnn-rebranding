#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")

rm -rf .tmp1
mkdir -p .tmp1
d=".tmp1"

extra_words=(
    MKLDNN_CPU_RUNTIME
    MKLDNN_GPU_RUNTIME
    MKLDNN_RUNTIME_NONE
    MKLDNN_RUNTIME_OCL
    MKLDNN_RUNTIME_OMP
    MKLDNN_RUNTIME_SEQ
    MKLDNN_RUNTIME_TBB
    MKLDNN_VERSION_HASH
    MKLDNN_VERSION_MAJOR
    MKLDNN_VERSION_MINOR
    MKLDNN_VERSION_PATCH
)

find include -type f \( -name *.h -o -name *.hpp \) \
    | xargs /usr/bin/grep -h -o -i -w "mkldnn\w*\|const_mkldnn\w*" 2>/dev/null > $d/list_
echo ${extra_words[@]} | tr ' ' '\n' >> $d/list_
cat $d/list_ \
    | LC_COLLATE=C sort -u \
    | /usr/bin/grep -v "_H\>\|_HPP\>" > $d/list
rm $d/list_

legal_header=\
"/*******************************************************************************
* Copyright 2019 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the \"License\");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an \"AS IS\" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/
"

m=$d/mkldnn_dnnl_mangling.h

cat > $m << EOM
$legal_header
// Mangle mkldnn entities to dnnl ones to preserve source-code level backwards
// compatibility. The compatibility will be dropped at DNNL 2.0.
// Please switch to the new names as soon as possible.

#ifndef MKLDNN_DNNL_MANGLING_H
#define MKLDNN_DNNL_MANGLING_H

EOM

sed 's/\(.*\)mkldnn\(.*\)/#define \1mkldnn\2 \1dnnl\2/g' $d/list | \
    sed 's/MKLDNN\(.*\)/#define MKLDNN\1 DNNL\1/g' >> $m
rm $d/list

echo -e "\n#endif /* MKLDNN_DNNL_MANGLING_H */" >> $m


#
# generating headers (maps)
#

fix_headers=(
    .h .hpp _debug.h _types.h _config.h _version.h
)

for hp in ${fix_headers[@]}; do
    h=$d/mkldnn${hp}

    guard=${hp^^}
    guard="MKLDNN${guard/./_}"

    cat > $h << EOM
$legal_header
// Header file ensures the backwards compatibility with previous namings.

#ifndef $guard
#define $guard

#include "mkldnn_dnnl_mangling.h"

#include "dnnl$hp"

#endif /* $guard */
EOM
done

#
# Changes to .github
#

sed -i 's/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g' .github/issue_template.md

#
# Changes to /cmake
#

sed -i 's/MKLDNN/DNNL/g' cmake/Doxygen.cmake
sed -i 's/MKLDNN/DNNL/g' cmake/MKL.cmake
sed -i 's/MKLDNN/DNNL/g' cmake/OpenCL.cmake
sed -i 's/MKLDNN/DNNL/g' cmake/OpenMP.cmake
sed -i 's/MKLDNN/DNNL/g' cmake/TBB.cmake
sed -i 's/MKLDNN/DNNL/g' cmake/Threading.cmake
sed -i 's/MKLDNN/DNNL/g' cmake/config.cmake.in
sed -i 's/MKLDNN/DNNL/g' cmake/options.cmake
sed -i 's/MKLDNN/DNNL/g' cmake/platform.cmake
sed -i 's/MKLDNN/DNNL/g' cmake/utils.cmake
sed -i 's/MKLDNN/DNNL/g' cmake/version.cmake

find cmake/lnx cmake/win/ cmake/mac/ -type f | xargs sed -i 's/Intel MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g'
sed -i 's/MKL-DNN/DNNL/g' cmake/Threading.cmake
sed -i 's/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g' cmake/options.cmake

sed -i 's/mkldnn/dnnl/g' cmake/version.cmake

#
# Examples (cmake only)
#

sed -i 's/MKLDNN/DNNL/g' examples/CMakeLists.txt
sed -i 's/MKLDNN/DNNL/g' examples/CMakeLists.txt.in && \
    sed -i 's/DNNL::mkldnn/MKLDNN::mkldnn/g' examples/CMakeLists.txt.in

#
# Scripts
#

sed -i 's/MKLDNN/DNNL/g' scripts/generate_mkldnn_debug.py
sed -i 's/mkldnn/dnnl/g' scripts/generate_mkldnn_debug.py
sed -i 's/MKL-DNN/DNNL/g' scripts/generate_mkldnn_debug.py

#
# Top Level
#

sed -i 's/Intel(R) Math Kernel Library for Deep Neural Networks/Deep Neural Network Library/g' CMakeLists.txt
sed -i 's/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g' CMakeLists.txt
sed -i 's/MKLDNN/DNNL/g' CMakeLists.txt
sed -i 's/mkldnn/dnnl/g' CMakeLists.txt

sed -i 's/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g' CONTRIBUTING.md
sed -i 's/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g' LICENSE

sed -i 's/Intel(R) Math Kernel Library for Deep Neural Networks/Deep Neural Network Library/g' README.md
sed -i 's/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g' README.md
sed -i 's/MKLDNN/DNNL/g' README.md
sed -i 's/mkldnn/dnnl/g' README.md

#
# include
#

headers=(
    mkldnn.h
    mkldnn_debug.h
    mkldnn_types.h
    mkldnn.hpp
    mkldnn_config.h.in
    mkldnn_version.h.in
)

for h in ${headers[@]}; do
    t=include/${h/mkldnn/dnnl}

    mv include/$h $t

    sed -i 's/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g' $t
    sed -i 's/MKLDNN/DNNL/g' $t
    sed -i 's/mkldnn/dnnl/g' $t
done

cp .tmp1/*.* include/

#
# src
#

sed -i 's/MKLDNN/DNNL/g' src/CMakeLists.txt
sed -i 's/mkldnn/dnnl/g' src/CMakeLists.txt

#
# Disable tests for a while
#
sed -i 's/add_subdirectory(tests)/# add_subdirectory(tests)/g' CMakeLists.txt

