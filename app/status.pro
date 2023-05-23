
# https://github.com/boostorg/multiprecision/releases: Use standalone version
# INCLUDEPATH+=$$PWD/vendor/multiprecision/include

#VERSION = 3.3
TARGET = Status
TEMPLATE = app

CONFIG += c++17
QT += core network concurrent websockets xml positioning
QT += gui qml quick
QT += quick quickcontrols2
QT += widgets gui opengl multimedia
#QMAKE_CXXFLAGS += -fpermissive

DEFINES+=QML_XHR_ALLOW_FILE_READ=1
static {
    QT += svg
}

# https://github.com/define-private-public/PSRayTracing
# https://develop.kde.org/frameworks/kirigami/
# https://github.com/oKcerG/SortFilterProxyModel

CONFIG(release, debug|release):DEFINES += QT_NO_DEBUG_OUTPUT

!win32{
    QT += bluetooth
    DEFINES+=HAVE_BTLE=1
}

win32{
    #QT += winextras
    #QT += printer
    LIBS+=-lRpcrt4
}else:ios{
    QMAKE_INFO_PLIST = ios/Info.plist
    #QT += purchasing
}else:macos{
    #QT += macextras
    #QT += purchasing
}else:android{
    QT += androidextras
    #QT += purchasing
    QT += nfc
    #QML_IMPORT_PATH+=/Users/ha/usr/Qt5.15.0/5.15.0/android/qml
    QML_IMPORT_PATH+=/home/ha/usr/Qt5.15.0/5.15.0/android/qml
    #include(/home/ha/usr/android_openssl/openssl.pri)
    SSL_PATH=/home/ha/usr/android_openssl
    INCLUDEPATH+=/home/ha/usr/android_openssl/openssl
    equals(ANDROID_TARGET_ARCH, arm64-v8a) {
        ANDROID_EXTRA_LIBS += \
            $$SSL_PATH/latest/arm64/libcrypto_1_1.so \
            $$SSL_PATH/latest/arm64/libssl_1_1.so
    }

}else:unix{
    #QT += x11extras
    #QT += nfc
    #LIBS += -L"/usr/lib/x86_64-linux-gnu/mesa"
    #LIBS += -L"/usr/lib/x86_64-linux-gnu"
    QTPLUGIN += qtvirtualkeyboardplugin
}

include(../libs/statuscore.pri)
include(../ui/statusui.pri)
include(status.pri)
#DEFINES -= DISABLE_LIBRARY_FEATURES
#SOURCES += src/main.cpp

#RESOURCES += res/app.qrc

win32{
}else:ios{
    QMAKE_INFO_PLIST = ios/Info.plist
}else:macos{
    LIBS += -framework AppKit
    LIBS += -framework CoreAudio
    LIBS += -framework AudioToolbox
    LIBS += -framework IOKit
    #LIBS += -lssl -lcrypto
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 11.0
}else:android{
#    DISTFILES += \
#        android/AndroidManifest.xml \
#        android/build.gradle \
#        android/gradle/wrapper/gradle-wrapper.jar \
#        android/gradle/wrapper/gradle-wrapper.properties \
#        android/gradlew \
#        android/gradlew.bat \
#        android/res/values/libs.xml

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    #LIBS += -lusb-1.0 -ludev
    #LIBS += -lssl -lcrypto
    LIBS += $$ANDROID_EXTRA_LIBS
}else:unix{
    #LIBS += -L"/usr/lib/x86_64-linux-gnu/mesa"
    #LIBS += -L"/usr/lib/x86_64-linux-gnu"
    contains(QT_ARCH,arm64){
        LIBS += -lusb-1.0
    }
    contains(QT_ARCH,x86_64){
        LIBS += -lusb-1.0
    }
    LIBS += -ludev
    LIBS += -lssl -lcrypto -ludev -lz
    #QMAKE_CXXFLAGS += -fPIC
    #QMAKE_CXXFLAGS += -ggdb
}

message("BUILD STATUS WITH LIBS $$LIBS")
