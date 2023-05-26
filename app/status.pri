
INCLUDEPATH+=$$PWD/src
INCLUDEPATH+=$$PWD/src/Application

HEADERS += $$files("$$PWD/src/*.h", true)
SOURCES += $$files("$$PWD/src/*.cpp", true)

RESOURCES += res/app.qrc
RESOURCES += $$files("$$PWD/qrc/*.qrc", true)

QML_IMPORT_PATH += $$PWD/qml \
                  $$PWD/qml/Status \
                  $$PWD/qml/Status/Application

ENABLE_CMAKE_IMPORT_QML {
    #QML_IMPORT_PATH += $$PWD/../build/Status
    #QML_IMPORT_PATH += $$PWD/../build/Status/Application
    #RESOURCES += $$files("$$PWD/../build/Status/*.qrc", true)
    ##OTHER_FILES += $$files("$$PWD/qml/*qmldir", true)
    ##OTHER_FILES += $$files("$$PWD/qml/*.qml", true)
    ##OTHER_FILES += $$files("$$PWD/qml/*.js", true)

    #OTHER_FILES += $$files("$$PWD/../build/Status/*qmldir", true)
    #OTHER_FILES += $$files("$$PWD/../build/Status/*.qml", true)
    #OTHER_FILES += $$files("$$PWD/../build/Status/*.js", true)
} else {
QML_IMPORT_PATH += $$PWD
#QML_IMPORT_PATH += $$PWD/Status
#QML_IMPORT_PATH += $$PWD/Status/Application
#RESOURCES += $$files("$$PWD/Status/*.qrc", true)
#OTHER_FILES += $$files("$$PWD/qml/*qmldir", true)
#OTHER_FILES += $$files("$$PWD/qml/*.qml", true)
#OTHER_FILES += $$files("$$PWD/qml/*.js", true)

OTHER_FILES += $$files("$$PWD/Status/*qmldir", true)
OTHER_FILES += $$files("$$PWD/Status/*.qml", true)
OTHER_FILES += $$files("$$PWD/Status/*.js", true)
}
OTHER_FILES += CMakeLists.txt
OTHER_FILES += $$PWD/src/CMakeLists.txt



