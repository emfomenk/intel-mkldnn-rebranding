# 0
git am .rename_patches/0001-src-add-few-missing-headers.patch

# 1
bash _rename_part1.sh && git add . && git commit -m "dnnl: grand rename. part 1: general"

# 2
bash _rename_part2.sh && git add . && git commit -m "dnnl: grand rename. part 2: src"

# 3
bash _rename_part3.sh && git add . && git commit -m "dnnl: grand rename. part 3: tests"

# 4
bash _rename_part4.sh && git add . && git commit -m "dnnl: grand rename. part 4: examples"
git am .rename_patches/0006-src-mkldnn-compat-support-MKLDNN_JIT_DUMP-and-MKLDNN.patch
git am .rename_patches/0007-build-mkldnn-compat-support-cmake-options.patch

# 5
bash _rename_part5.sh && git add . && git commit -m "dnnl: grand rename. part 5: doc"
git am .rename_patches/0009-doc-fix-links-in-transition-guide.patch
