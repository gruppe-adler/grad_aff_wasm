#include <grad_aff/paa/paa.h>

#include <emscripten/bind.h>

using namespace emscripten;

std::string getExceptionMessage(intptr_t exceptionPtr) {
  return std::string(reinterpret_cast<std::exception *>(exceptionPtr)->what());
}

EMSCRIPTEN_BINDINGS(grad_aff_paa) {

    register_vector<uint8_t>("pixelVector");

    value_object<MipMap>("MipMap")
        .field("width", &MipMap::width)
        .field("height", &MipMap::height)
        .field("dataLength", &MipMap::dataLength)
        .field("data", &MipMap::data)
        .field("lzoCompressed", &MipMap::lzoCompressed);

    register_vector<MipMap>("MipMaps");

    enum_<grad_aff::Paa::TypeOfPaX>("TypeOfPaX")
        .value("UNKNOWN", grad_aff::Paa::TypeOfPaX::UNKNOWN)
        .value("DXT1", grad_aff::Paa::TypeOfPaX::DXT1)
        .value("DXT2", grad_aff::Paa::TypeOfPaX::DXT2)
        .value("DXT3", grad_aff::Paa::TypeOfPaX::DXT3)
        .value("DXT4", grad_aff::Paa::TypeOfPaX::DXT4)
        .value("DXT5", grad_aff::Paa::TypeOfPaX::DXT5)
        .value("RGBA4444", grad_aff::Paa::TypeOfPaX::RGBA4444)
        .value("RGBA5551", grad_aff::Paa::TypeOfPaX::RGBA5551)
        .value("RGBA8888", grad_aff::Paa::TypeOfPaX::RGBA8888)
        .value("GRAYwAlpha", grad_aff::Paa::TypeOfPaX::GRAYwAlpha)
        ;

    class_<grad_aff::Paa>("Paa")
        .constructor()
        .function("calculateMipmapsAndTaggs", &grad_aff::Paa::calculateMipmapsAndTaggs)
        .function("readPaa", emscripten::select_overload<void(std::string, bool)>(&grad_aff::Paa::readPaa))
        .function("readPaaData", emscripten::select_overload<void(std::vector<uint8_t>, bool)>(&grad_aff::Paa::readPaa))
        .function("writePaa", emscripten::select_overload<void(std::string, grad_aff::Paa::TypeOfPaX)>(&grad_aff::Paa::writePaa))
        .function("writePaaData", emscripten::select_overload<std::vector<uint8_t>(grad_aff::Paa::TypeOfPaX)>(&grad_aff::Paa::writePaa))
        .property("mipMaps", &grad_aff::Paa::getMipMaps, &grad_aff::Paa::setMipMaps)
        .property("hasTransparency", &grad_aff::Paa::getHasTransparency);
    emscripten::function("getExceptionMessage", &getExceptionMessage);

}
