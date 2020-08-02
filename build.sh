mkdir -p ./build
includePath="$(pwd)/deps/install/include"
em++ \
    -c \
    -I$includePath \
    grad_aff_wasm.cpp \
    -o ./build/grad_aff_wasm.bc
em++ \
    ./deps/install/lib/libgrad_aff.a \
    ./deps/install/lib/liblzokay.a \
    ./deps/install/lib/libsquish.a \
    --bind \
    --noentry \
    ./build/grad_aff_wasm.bc \
    -s DISABLE_EXCEPTION_CATCHING=2 \
    -s MODULARIZE=1 \
    -s EXPORT_NAME="gradAffFactory" \
    -s ENVIRONMENT=web \
    -s EXPORT_ES6=1 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -o ./build/grad_aff.js
