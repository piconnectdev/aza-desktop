
INCLUDEPATH+=$$PWD/src
INCLUDEPATH+=$$PWD/src/Application

HEADERS += $$files("$$PWD/src/*.h", true)
SOURCES += $$files("$$PWD/src/*.cpp", true)

RESOURCES += res/app.qrc

QML_IMPORT_PATH += $$PWD/qml \
                  $$PWD/qml/Status \
                  $$PWD/qml/Status/Application

OTHER_FILES += $$files("$$PWD/qml/*qmldir", true)
OTHER_FILES += $$files("$$PWD/qml/*.qml", true)
OTHER_FILES += $$files("$$PWD/qml/*.js", true)

OTHER_FILES += CMakeLists.txt
OTHER_FILES += $$PWD/src/CMakeLists.txt



