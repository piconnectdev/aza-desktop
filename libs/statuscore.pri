
DEFINES+=QZXING_QML
DEFINES+=QZXING_USE_QML
DEFINES+=QZXING_MULTIMEDIA
DEFINES+=QZXING_USE_ENCODER
DEFINES+=QZXING_USE_DECODER_QR_CODE
INCLUDEPATH+=$$PWD/../vendor/qzxing/src
INCLUDEPATH+=$$PWD/../vendor/SortFilterProxyModel
INCLUDEPATH+=$$PWD/../vendor/json/include
INCLUDEPATH+=$$PWD/../vendor/multiprecision/include

INCLUDEPATH+=$$PWD/include
INCLUDEPATH+=$$PWD/ui/include
INCLUDEPATH+=$$PWD/ApplicationCore/src
INCLUDEPATH+=$$PWD/ChatSection/include
INCLUDEPATH+=$$PWD/ChatSection/include/Status/ChatSection
INCLUDEPATH+=$$PWD/Helpers/src
INCLUDEPATH+=$$PWD/Helpers/src/Helpers
INCLUDEPATH+=$$PWD/Onboarding/src
INCLUDEPATH+=$$PWD/Onboarding/src/Onboarding
INCLUDEPATH+=$$PWD/StatusGoQt/src
INCLUDEPATH+=$$PWD/StatusGoQt/src/StatusGo
INCLUDEPATH+=$$PWD/StatusGoQt/src/StatusGo/Accounts
INCLUDEPATH+=$$PWD/StatusGoQt/src/StatusGo/Chat
INCLUDEPATH+=$$PWD/StatusGoQt/src/StatusGo/Messages
INCLUDEPATH+=$$PWD/StatusGoQt/src/StatusGo/Messenger
INCLUDEPATH+=$$PWD/StatusGoQt/src/StatusGo/Metadata
INCLUDEPATH+=$$PWD/StatusGoQt/src/StatusGo/Settings
INCLUDEPATH+=$$PWD/StatusGoQt/src/StatusGo/Wallet
INCLUDEPATH+=$$PWD/StatusGoQt/src/StatusGo/Wallet/Transfer
INCLUDEPATH+=$$PWD/Wallet/include
INCLUDEPATH+=$$PWD/Wallet/include/Status/Wallet

HEADERS += $$files("$$PWD/ApplicationCore/*.h", true)
HEADERS += $$files("$$PWD/ChatSection/include/*.h", true)
HEADERS += $$files("$$PWD/Helpers/*.h", true)
HEADERS += $$files("$$PWD/Onboarding/src/*.h", true)
HEADERS += $$files("$$PWD/StatusGoQt/src/*.h", true)
HEADERS += $$files("$$PWD/Wallet/*.h", true)

SOURCES += $$files("$$PWD/ApplicationCore/*.cpp", true)
SOURCES += $$files("$$PWD/ChatSection/*.cpp", true)
SOURCES += $$files("$$PWD/Onboarding/src/Onboarding/*.cpp", true)
SOURCES += $$files("$$PWD/Helpers/*.cpp", true)
SOURCES += $$files("$$PWD/StatusGoQt/src/*.cpp", true)
SOURCES += $$files("$$PWD/Wallet/src/*.cpp", true)

QML_IMPORT_PATH += $$PWD/ApplicationCore \
                  $$PWD/ChatSection \
                  $$PWD/Helpers \
                  $$PWD/Onboarding \
                  $$PWD/StatusGoQt \
                  $$PWD/Wallet

OTHER_FILES += $$files("$$PWD/*qmldir", true)
OTHER_FILES += $$files("$$PWD/*.qml", true)
OTHER_FILES += $$files("$$PWD/*.js", true)

#OTHER_FILES += $$files("$$PWD/Assets/qml/*.qml", true)
#OTHER_FILES += $$files("$$PWD/ApplicationCore/*qmldir", true)
#OTHER_FILES += $$files("$$PWD/ApplicationCore/*.qml", true)
#OTHER_FILES += $$files("$$PWD/ApplicationCore/*.js", true)

#OTHER_FILES += $$files("$$PWD/ChatSection/*qmldir", true)
#OTHER_FILES += $$files("$$PWD/ChatSection/*.qml", true)
#OTHER_FILES += $$files("$$PWD/ChatSection/*.js", true)

#OTHER_FILES += $$files("$$PWD/Helpers/*qmldir", true)
#OTHER_FILES += $$files("$$PWD/Helpers/*.qml", true)
#OTHER_FILES += $$files("$$PWD/Helpers/*.js", true)

#OTHER_FILES += $$files("$$PWD/Onboarding/*qmldir", true)
#OTHER_FILES += $$files("$$PWD/Onboarding/*.qml", true)
#OTHER_FILES += $$files("$$PWD/Onboarding/*.js", true)

#OTHER_FILES += $$files("$$PWD/StatusGoQt/*qmldir", true)
#OTHER_FILES += $$files("$$PWD/StatusGoQt/*.qml", true)
#OTHER_FILES += $$files("$$PWD/StatusGoQt/*.js", true)

#OTHER_FILES += $$files("$$PWD/Wallet/*qmldir", true)
#OTHER_FILES += $$files("$$PWD/Wallet/*.qml", true)
#OTHER_FILES += $$files("$$PWD/Wallet/*.js", true)

OTHER_FILES += $$PWD/ApplicationCore/CMakeLists.txt
OTHER_FILES += $$PWD/ChatSection/CMakeLists.txt
OTHER_FILES += $$PWD/Helpers/CMakeLists.txt
OTHER_FILES += $$PWD/Onboarding/CMakeLists.txt
OTHER_FILES += $$PWD/StatusGoQt/CMakeLists.txt
OTHER_FILES += $$PWD/Wallet/CMakeLists.txt
