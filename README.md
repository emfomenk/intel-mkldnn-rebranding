Re-branding Intel MKL-DNN to DNNL (implementation)
==================================================

1. Copy the content of the repo to the root directory of Intel MKL-DNN
   (except for the README.md)
2. Checkout the latest master [1]
3. Call `bash _rename.sh`

It is also worth mentioning that DNNL team finally switched to the mandatory
code formatting based on `_clang-format` file in the root of the DNNL
repository. The corresponding changes were done by
[this](https://github.com/intel/mkl-dnn/commit/56ef626d6627e93da039c15e032603e1a4bc8af4)
and neighbor commits. Hence, at commit stage the resulting patches were further
formatted by the clang-format.

---

[1]. The renaming happen around commit 518a316a8cd6deb82dc7866bc04bd0355a25c3a4
     2019-08-18.
