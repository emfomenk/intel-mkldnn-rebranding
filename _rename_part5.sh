#!/bin/bash

cd $(dirname "${BASH_SOURCE[0]}")

mkdir -p .tmp1

# preserve the transition guide
cp doc/advanced/transition-to-v1.md .tmp1/

# brand
find doc -type f -not -path doc/assets/\* \
    | xargs sed -i 's/Intel(R) Math Kernel Library for Deep Neural Networks/Deep Neural Network Library/g;s/Intel MKL-DNN/DNNL/g;s/Intel(R) MKL-DNN/DNNL/g;s/MKL-DNN/DNNL/g'

# Intel\nMKL-DNN --> Intel\nDNNL --> \nDNNL
sed -i 's/ Intel$//g' \
    doc/usage_models/inference.md \
    doc/usage_models/inference_int8.md

# code
find doc -type f -not -path doc/assets/\* \
    | xargs sed -i 's/MKLDNN/DNNL/g;s/mkldnn/dnnl/g'

# file rename
mv doc/programming_model/images/img_mkldnn_object_snapshot.jpg doc/programming_model/images/img_dnnl_object_snapshot.jpg
mv doc/programming_model/images/img_mkldnn_programming_flow.jpg doc/programming_model/images/img_dnnl_programming_flow.jpg

# restore transition guide
mv .tmp1/transition-to-v1.md doc/advanced/transition-to-v1.md
