TARGET = StatusUI
TEMPLATE = lib

CONFIG += c++17
CONFIG += staticlib

QT += core network qml quick

#include(statusq/statusq.pri)
include(statusui.pri)

