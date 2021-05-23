SOURCES = grad_aff.c
OUT_NAME = grad_aff
OUT_DIR := release
COMPILERFLAGS :=
LDFLAGS :=
LIBS := grad_aff squish lzokay
EXPORTS = free malloc encode decode free_encoded_data get_last_exception

# ###################################################################################################################

# Add default include dir if none was specified
ifeq ($(filter -I%,$(COMPILERFLAGS)),)
    COMPILERFLAGS += -I/usr/local/include
endif

# Add default ibrary search path if none was specified
ifeq ($(filter -L%,$(COMPILERFLAGS)),)
    COMPILERFLAGS += -L/usr/local/lib
endif

# General compiler flags
COMPILERFLAGS += -s STANDALONE_WASM
COMPILERFLAGS += -s ALLOW_MEMORY_GROWTH
COMPILERFLAGS += -Os

# General linker flags
LDFLAGS += --import-memory
LDFLAGS += --no-entry

# ###################################################################################################################

# Add ibraries to compiler flags
COMPILERFLAGS += $(addprefix -l, $(LIBS))

# Add expots to linker flags
LDFLAGS += $(addprefix --export=, $(EXPORTS))

# Add linker flags to clang flags with prefix "-Wl,"; clang will automatically pass them to the linker
comma := ,
COMPILERFLAGS += $(addprefix -Wl$(comma), $(LDFLAGS))

OUT_PATH := $(OUT_DIR)/$(OUT_NAME)

# ###################################################################################################################

all: $(OUT_DIR) $(OUT_PATH).wasm $(OUT_DIR)/index.html $(OUT_DIR)/index.js

clean:
	rm -rf $(OUT_DIR)

# release directory
$(OUT_DIR): 
	mkdir -p $(OUT_DIR)

# optimized wasm
$(OUT_PATH).wasm : $(OUT_PATH)_unoptimized.wasm
	wasm-opt -Oz $(OUT_PATH)_unoptimized.wasm -o $(OUT_PATH).wasm

# unoptimized wasm
$(OUT_PATH)_unoptimized.wasm : $(SOURCES)
	emcc $(SOURCES) -o $(OUT_PATH)_unoptimized.wasm $(COMPILERFLAGS);

# index.html
$(OUT_DIR)/index.html: index.html
	rm -f $(OUT_DIR)/index.html
	cp index.html $(OUT_DIR)

# javascript
$(OUT_DIR)/index.js: index.ts tsconfig.json
	tsc
