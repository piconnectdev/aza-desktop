DEFINES+=QZXING_QML
DEFINES+=QZXING_USE_QML
DEFINES+=QZXING_MULTIMEDIA
DEFINES+=QZXING_USE_ENCODER
DEFINES+=QZXING_USE_DECODER_QR_CODE
INCLUDEPATH+=$$PWD/../vendor/qzxing/src
INCLUDEPATH+=$$PWD/../vendor/SortFilterProxyModel
#INCLUDEPATH+=$$PWD/../vendor/json/include

INCLUDEPATH+=$$PWD/include
INCLUDEPATH+=$$PWD/include/StatusDesktop

HEADERS += $$files("$$PWD/include/StatusDesktop/*.h", true)
#HEADERS += $$PWD/include/StatusDesktop/Monitoring/ContextPropertiesModel.h
#HEADERS += $$PWD/include/StatusDesktop/Monitoring/Monitor.h

SOURCES += $$files("$$PWD/src/StatusDesktop/*.cpp", true)
#SOURCES += $$PWD/src/StatusDesktop/Monitoring/ContextPropertiesModel.cpp
#SOURCES += $$PWD/src/StatusDesktop/Monitoring/Monitor.cpp
RESOURCES += $$PWD/resources.qrc

QML_IMPORT_PATH = $$PWD/imports \
                  $$PWD/StatusQ/src \
                  $$PWD/app

OTHER_FILES += $$files("$$PWD/imports/*qmldir", true)
OTHER_FILES += $$files("$$PWD/imports/*.qml", true)
OTHER_FILES += $$files("$$PWD/imports/*.js", true)
OTHER_FILES += $$files("$$PWD/app/*qmldir", true)
OTHER_FILES += $$files("$$PWD/app/*.qml", true)
OTHER_FILES += $$files("$$PWD/app/*.js", true)
OTHER_FILES += $$PWD/main.qml
OTHER_FILES += $$files("$$PWD/../monitoring/*.qml", true)

OTHER_FILES += $$PWD/StatusQ/CMakeLists.txt
