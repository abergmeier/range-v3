#!/usr/bin/env bash

set -e

# Install a newer CMake version
# curl -sSL https://cmake.org/files/v3.6/cmake-3.6.1-Linux-x86_64.sh -o install-cmake.sh
# chmod +x install-cmake.sh
# sudo ./install-cmake.sh --prefix=/usr/local --skip-license

# Checkout LLVM sources
git clone --depth=1 https://github.com/llvm-mirror/llvm.git llvm-source
git clone --depth=1 https://github.com/llvm-mirror/libcxx.git llvm-source/projects/libcxx
git clone --depth=1 https://github.com/llvm-mirror/libcxxabi.git llvm-source/projects/libcxxabi

# Build and install libc++ (Use unstable ABI for better sanitizer coverage)
mkdir llvm-build && cd llvm-build
cmake -DCMAKE_C_COMPILER=${C_COMPILER} -DCMAKE_CXX_COMPILER=${COMPILER} \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/usr \
      -DLIBCXX_ABI_UNSTABLE=ON \
      -DLLVM_USE_SANITIZER=${SANITIZER} \
      ../llvm-source
make cxx -j2
sudo make install-cxxabi install-cxx
