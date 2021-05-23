FROM emscripten/emsdk:2.0.20

# Install wasm-opt
WORKDIR /tmp
RUN curl -L  https://github.com/WebAssembly/binaryen/releases/download/version_101/binaryen-version_101-x86_64-linux.tar.gz | tar xz
WORKDIR binaryen-version_101
RUN chmod +x bin/*
RUN find * -mindepth 0 -maxdepth 0 -type d -exec sh -c 'mkdir -p /usr/local/{} && mv $PWD/{}/* /usr/local/{}/' \;
RUN wasm-opt --version

# Install typescript compiler
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install -y nodejs
RUN npm i -g typescript@4.2.4
RUN tsc -v

##############################################################################################################################

# Install lzokay
WORKDIR /tmp
RUN curl -L https://github.com/jackoalan/lzokay/archive/546a9695271e8a8b4711383f828172754fd825f2.tar.gz | tar xz
WORKDIR lzokay-546a9695271e8a8b4711383f828172754fd825f2/build
RUN emcmake cmake .. && emmake make && emmake make install

# Install ordered-map
WORKDIR /tmp
RUN curl -L https://github.com/Tessil/ordered-map/archive/refs/tags/v1.0.0.tar.gz | tar xz
WORKDIR ordered-map-1.0.0/build
RUN emcmake cmake .. && emmake make && emmake make install

# Install zlib
WORKDIR /tmp
RUN curl -L wget http://www.zlib.net/zlib-1.2.11.tar.gz | tar xz
WORKDIR zlib-1.2.11
RUN ./configure && emmake make install

# Install libpng
WORKDIR /tmp
RUN curl -L https://github.com/glennrp/libpng/archive/refs/tags/v1.6.35.tar.gz | tar xz
WORKDIR libpng-1.6.35
RUN ./configure && emmake make check && emmake make install

# Install boost
WORKDIR /tmp
RUN curl -L http://sourceforge.net/projects/boost/files/boost/1.76.0/boost_1_76_0.tar.gz | tar xz
RUN mv boost_1_76_0 boost

# Install libsquish
WORKDIR /tmp/libsquish
RUN curl -L https://sourceforge.net/projects/libsquish/files/libsquish-1.15.tgz/download | tar xz
WORKDIR build
RUN emcmake cmake .. -DBUILD_SQUISH_WITH_SSE2=OFF -DBUILD_SQUISH_WITH_OPENMP=OFF && emmake make && emmake make install

# Install PEGTL
WORKDIR /tmp
RUN curl -L https://github.com/taocpp/PEGTL/archive/refs/tags/3.2.0.tar.gz | tar xz
WORKDIR PEGTL-3.2.0/build
RUN emcmake cmake .. -DPEGTL_BUILD_TESTS=OFF -DPEGTL_BUILD_EXAMPLES=OFF && emmake make && emmake make install

##############################################################################################################################

# Build grad_aff
WORKDIR /tmp
RUN curl -L https://github.com/gruppe-adler/grad_aff/archive/f1625f6676636516d8e4945c07989f61ff4810d2.tar.gz | tar xz
WORKDIR grad_aff-f1625f6676636516d8e4945c07989f61ff4810d2/build
RUN emcmake cmake .. \
    -DBUILD_TESTS=OFF \
    -DDYNAMIC_LIB=OFF \
    -DGRAD_AFF_ENABLE_PARALLELISM=OFF \
    -Dlzokay_DIR="/usr/local/lib/cmake/lzokay/" \
    -Dpegtl_DIR="/usr/local/share/pegtl/cmake" \
    -Dtsl-ordered-map_DIR="/usr/local/share/cmake/tsl-ordered-map" \
    -DBoost_INCLUDE_DIR="/tmp/boost" \
    -DSQUISH_INCLUDE_DIR="/usr/local/include" \
    -DSQUISH_LIBRARY="/usr/local/lib/libsquish.a"
RUN emmake make
RUN emmake make install

WORKDIR /usr/src/app
