#include <grad_aff/paa/Paa.h>
#include <stdlib.h>

/*
* Function: encode
* ----------------------------
*   Encode image data (width, height, data) to PAA.
*
*   width:  width of image data
*   height: height of image data
*   data:   pointer to image data
*   size:   pointer to write output data size
*
*   returns: pointer to byte encoded paa
*/
uint8_t* encode (uint16_t width, uint16_t height, uint8_t* data, size_t* size) {
    bool success;

    Paa* paa = PaaCreateFromData(width, height, data, width * height * 4);
    if (paa == NULL) return NULL;

    success = PaaCalcMipmapsAndTaggs(paa);
    if (!success) return NULL;

    uint8_t* ptr = PaaWriteData(paa, size);
    if (ptr == NULL) return NULL;

    success = PaaDestroy(paa);
    if (!success) return NULL;

    return ptr;
}

/*
* Function: free_encoded_data
* ----------------------------
*   Free data written by encode
*
*   ptr: pointer to data
*
*   returns: 0 = fail / 1 = success
*/
bool free_encoded_data(uint8_t* ptr) {
    return PaaDestroyWrittenData(ptr);
}

/*
* Function: decode
* ----------------------------
*   Decode paa bytes to image data (width, height, data)
*
*   data:      pointer to paa bytes
*   data_size: size of paa data in bytes
*   width:     pointer to write image data width
*   height:    pointer to write image data height
*   size:      pointer to write image data size
*
*   returns: pointer to image data
*/
uint8_t* decode (uint8_t* data, size_t data_size, uint16_t* width, uint16_t* height, size_t* size) {
    bool success;

    Paa* paa = PaaCreate();
    if (paa == NULL) return NULL;

    success = PaaReadData(paa, data, data_size, true);
    if (!success) return NULL;

    Mipmap* mipmap = PaaGetMipmap(paa, 0);
    if (mipmap == NULL) return NULL;

    uint16_t w = MipmapGetWidth(mipmap);
    if (w == 0) return NULL;
    uint16_t h = MipmapGetHeight(mipmap);
    if (h == 0) return NULL;
    size_t s = MipmapGetDataSize(mipmap);
    if (s == 0) return NULL;

    uint8_t* ptr = (uint8_t*) malloc(s);

    success = MipmapGetData(mipmap, ptr, s);
    if (!success) return NULL;

    *width = w;
    *height = h;
    *size = s;

    success = MipmapDestroy(mipmap);
    if (!success) return NULL;

    success = PaaDestroy(paa);
    if (!success) return NULL;

    return ptr;
}

/*
* Function: get_last_aff_exception
* ----------------------------
*   Get last grad_aff exception.
*
*   returns: exception code
*/
int8_t get_last_aff_exception() {
    // TODO
    return -1;
}