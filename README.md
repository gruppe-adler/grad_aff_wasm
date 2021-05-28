# Grad AFF WebAssembly
This repo contains a toolchain to build WebAssembly with [grad_aff](https://github.com/gruppe-adler/grad_aff). It also contains the source code of the WebAssembly used in [paa.gruppe-adler.de](https://github.com/gruppe-adler/paa.gruppe-adler.de).

## Makefile
The makefile can be easily used within the [Docker Image](#docker-image) and does multiple things at once:
1. Compiles `grad_aff_paa.c` to WebAssembly
2. Optimizes WebAssembly with `wasm-opt`
3. Compiles TypeScript glue code (`index.ts`) to JavaScript
4. Copies `index.html` to release (example html code, for quick testing)

## Docker Image
The docker image serves as an "SDK" to build the WebAssembly and the custom JS glue-code. It has all required build tools and libraries installed to build WebAssembly with `grad_aff`.

### Tools
| Name          |   Version   |     Links     |
| ------------- | ----------- | ------------- |
| Emscripten SDK     | 2.0.20 | [GitHub](https://github.com/emscripten-core/emsdk)
| Binaryen's `wasm-opt` | 101 | [GitHub](https://github.com/WebAssembly/binaryen)
| Typescript compiler | 4.2.4 | [GitHub](https://github.com/Microsoft/TypeScript)

### Libraries
All libraries are installed in `/usr/local`.

| Name          |   Version   |     Links     |
| ------------- | ----------- | ------------- |
| lzokay | commit `546a969` | [GitHub](https://github.com/jackoalan/lzokay)
| ordered-map | 1.0.0 | [GitHub](https://github.com/Tessil/ordered-map)
| zlib | 1.2.11 | [Homepage](http://www.zlib.net)
| libpng | 1.6.35 | [GitHub](https://github.com/glennrp/libpng)
| boost | 1.76.0 | [Homepage](https://www.boost.org/)
| libsquish | 1.15 | -
| PEGTL | 3.2.0 | [GitHub](https://github.com/taocpp/PEGTL)
| grad_aff | commit `d6689c0` | [GitHub](https://github.com/gruppe-adler/grad_aff)

### Building
The image can be built like any other docker image:
```
docker build -t grad_aff_wasm_sdk . 2> build.log
```

### Building WASM
Either start a sdk-container with an interactive shell (to run `make` multiple times or write your own Makefile / build script):
```
docker run --rm -it -v ${PWD}:/usr/src/app grad_aff_wasm_sdk /bin/sh
```
or just run `make` once within the sdk-container:
```
docker run --rm -v ${PWD}:/usr/src/app grad_aff_wasm_sdk make
```
