TEMPLATE = subdirs

CONFIG += ordered
CONFIG += c++17

THIRDPARTY_DIR=$$PWD/thirdParty

#SUBDIRS += vendor/qzxing/src/QZXing.pro
SUBDIRS += ../ui/StatusQ/statusq.pro
SUBDIRS += ../ui/statusui.pro
SUBDIRS += ../libs/statuscore.pro
SUBDIRS += ../app/status.pro
#SUBDIRS += ../ui/nim-status-client.pro

#StatusQ.depends += QZXing
StatusUI.depends += StatusQ
Status.depends += StatusQ
#Status.depends += StatusCore StatusUI
DEFINES += QT_DISABLE_DEPRECATED_UP_TO=0x050F00
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000


