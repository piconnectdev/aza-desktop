TARGET = StatusCore
TEMPLATE = lib

CONFIG += c++17
CONFIG += staticlib

QT += core concurrent network qml quick

include(statuscore.pri)

