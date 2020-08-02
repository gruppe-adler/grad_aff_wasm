#!/bin/bash

cd ./deps
rm -R ./install
mkdir ./install

echo "Building boost"
wget https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.gz -q --show-progress -nc
echo "Extracting boost..."
tar -xzf boost_1_73_0.tar.gz --keep-newer-files 2>/dev/null

echo "Building libsquish"
wget https://netcologne.dl.sourceforge.net/project/libsquish/libsquish-1.15.tgz -q --show-progress -nc
mkdir ./libsquish-1.15/
tar -xzf libsquish-1.15.tgz -C ./libsquish-1.15/

mkdir ./libsquish-1.15/build
cd ./libsquish-1.15/build
emcmake cmake -DBUILD_SQUISH_WITH_OPENMP=OFF -DBUILD_SQUISH_WITH_SSE2=OFF -DCMAKE_INSTALL_PREFIX=./../../install/ ..
emmake make -j
emmake make install
cd ./../..

echo "Downloading lzokay"
wget https://github.com/jackoalan/lzokay/archive/master.tar.gz -q --show-progress -nc
mv master.tar.gz lzokay-master.tar.gz
tar -xzf lzokay-master.tar.gz

echo "Building lzokay"
mkdir ./lzokay-master/build
cd ./lzokay-master/build
emcmake cmake -DCMAKE_INSTALL_PREFIX=./../../install/ ..
emmake make -j
emmake make install
cd ./../..

echo "Downloading ordered-map"
wget https://github.com/Tessil/ordered-map/archive/v1.0.0.tar.gz -q --show-progress -nc
mv v1.0.0.tar.gz ordered-map.tar.gz
tar -xzf ordered-map.tar.gz

echo "Building ordered-map"
mkdir ./ordered-map-1.0.0/build
cd ./ordered-map-1.0.0/build
emcmake cmake -DCMAKE_INSTALL_PREFIX=./../../install/ ..
emmake make -j
emmake make install
cd ./../..

echo "Download PEGTL"
wget https://github.com/taocpp/PEGTL/archive/master.tar.gz -q --show-progress
mv master.tar.gz PEGTL-master.tar.gz
tar -xzf PEGTL-master.tar.gz

echo "Building PEGTL"
mkdir ./PEGTL-master/build
cd ./PEGTL-master/build
emcmake cmake -DPEGTL_BUILD_TESTS=OFF -DPEGTL_BUILD_EXAMPLES=OFF -DCMAKE_INSTALL_PREFIX=./../../install/ ..
emmake make -j
emmake make install
cd ./../..

echo "Download grad_aff"
wget https://github.com/gruppe-adler/grad_aff/archive/dev.tar.gz -q --show-progress
mv dev.tar.gz grad_aff-dev.tar.gz
tar -xzf grad_aff-dev.tar.gz

echo "Building grad_aff"

installPath="$(pwd)/install"
boostDir="$(pwd)/boost_1_73_0"

mkdir ./grad_aff-dev/build
cd ./grad_aff-dev/build
emcmake cmake \
    -DCMAKE_PREFIX_PATH="$installPath" \
    -Dpegtl_DIR="$installPath/share/pegtl/cmake" \
    -Dtsl-ordered-map_DIR="$installPath/share/cmake/tsl-ordered-map" \
    -DBoost_INCLUDE_DIR="$boostDir" \
    -Dlzokay_DIR="$installPath/lib/cmake/lzokay" \
    -DSQUISH_INCLUDE_DIR="$installPath/include" \
    -DSQUISH_LIBRARY="$installPath/lib/libsquish.a" \
    -DBUILD_TESTS=OFF \
    -DBUILD_WITH_OIIO=OFF \
    -DBUILD_WITH_OPENSSL=OFF \
    -DGRAD_AFF_ENABLE_PARALLELISM=OFF \
    -DCMAKE_INSTALL_PREFIX=./../../install/ \
    ..
emmake make -j
emmake make install
cd ./../..

echo "Done."