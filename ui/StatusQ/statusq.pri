#VERSION = 3.3
CONFIG += \
          enable_decoder_1d_barcodes \
          enable_decoder_qr_code \
          enable_decoder_data_matrix \
          enable_decoder_aztec \
          enable_decoder_pdf17 \
          enable_encoder_qr_code \
          #staticlib \
          qzxing_qml \
          qzxing_multimedia \

DEFINES+=QZXING_QML
DEFINES+=QZXING_USE_QML
DEFINES+=QZXING_MULTIMEDIA
DEFINES+=QZXING_USE_ENCODER
DEFINES+=QZXING_USE_DECODER_QR_CODE
#DEFINES -= DISABLE_LIBRARY_FEATURES

INCLUDEPATH+=$$PWD/../../vendor/qzxing/src
#include($$PWD/../../vendor/qzxing/src/QZXing.pri)
include($$PWD/../../vendor/qzxing/src/QZXing-components.pri)

INCLUDEPATH+=$$PWD/../../vendor/SortFilterProxyModel
include($$PWD/../../vendor/SortFilterProxyModel/SortFilterProxyModel.pri)


INCLUDEPATH+=$$PWD/include
HEADERS += $$files("$$PWD/include/*h", true)
SOURCES += $$files("$$PWD/src/*.cpp", true)

OTHER_FILES += $$files("$$PWD/*qmldir", true)
OTHER_FILES += $$files("$$PWD/src/*.qml", true)
#OTHER_FILES += $$files("$$PWD/*.js", true)

OTHER_FILES += $$PWD/CMakeLists.txt

RESOURCES+=$$PWD/src/assets.qrc
RESOURCES+=$$PWD/src/statusq.qrc
