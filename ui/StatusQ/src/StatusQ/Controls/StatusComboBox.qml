import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1

Item {
    id: root

    property alias control: comboBox
    property alias model: comboBox.model
    property alias count: comboBox.count
    property alias delegate: comboBox.delegate
    property alias contentItem: comboBox.contentItem
    property alias comboBoxListViewSection: listView.section

    property alias currentIndex: comboBox.currentIndex
    property alias currentValue: comboBox.currentValue
    property alias currentText: comboBox.currentText

    property alias label: labelItem.text
    property alias validationError: validationErrorItem.text
    property bool forceError: false

    property string popupContentItemObjectName: ""
    property string indicatorIcon: "chevron-down"

    property int size: StatusComboBox.Size.Large
    property int type: StatusComboBox.Type.Primary

    enum Size {
        Small,
        Large
    }

    enum Type {
        Primary,
        Secondary
    }

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    opacity: enabled ? 1 : 0.3

    LayoutMirroring.childrenInherit: true

    ColumnLayout {
        id: layout

        anchors.fill: parent
        spacing: 0

        StatusBaseText {
            id: labelItem
            Layout.fillWidth: true
            visible: !!text
            color: root.enabled ? Theme.palette.directColor1 : Theme.palette.baseColor1
        }

        ComboBox {
            id: comboBox

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: labelItem.visible ? 7 : 0

            enabled: root.enabled

            font.family: Theme.palette.baseFont.name
            font.pixelSize: root.size === StatusComboBox.Size.Large ? Theme.secondaryTextFontSize : 13

            padding: 16
            spacing: 16

            background: Rectangle {
                color: root.type === StatusComboBox.Type.Secondary ? "transparent" : Theme.palette.baseColor2
                radius: 8
                border.width: (!!root.validationError || root.forceError
                               || comboBox.hovered || comboBox.down
                               || comboBox.visualFocus
                               || root.type === StatusComboBox.Type.Secondary)
                              ? 1 : 0

                border.color: {
                    if (!!root.validationError || root.forceError)
                        return Theme.palette.dangerColor1

                    if (comboBox.visualFocus || comboBox.popup.opened)
                        return Theme.palette.primaryColor1

                    if (comboBox.hovered)
                        return Theme.palette.primaryColor2

                    if (root.type === StatusComboBox.Type.Secondary)
                        return Theme.palette.directColor7

                    return "transparent"
                }

                HoverHandler {
                    cursorShape: root.enabled ? Qt.PointingHandCursor : undefined
                }
            }

            contentItem: StatusBaseText {
                font: comboBox.font
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                text: comboBox.displayText
                color: root.type === StatusComboBox.Type.Secondary ? Theme.palette.baseColor1 : Theme.palette.directColor1
            }

            indicator: StatusIcon {
                x: comboBox.mirrored ? comboBox.padding : comboBox.width - width - comboBox.padding
                y: comboBox.topPadding + (comboBox.availableHeight - height) / 2
                width: root.size === StatusComboBox.Size.Large ? 24 : 16
                height: width
                icon: root.indicatorIcon
                color: {
                    if (comboBox.visualFocus || comboBox.popup.opened)
                        return Theme.palette.primaryColor1

                    if (comboBox.hovered)
                        return Theme.palette.primaryColor2

                    return Theme.palette.baseColor1
                }
            }

            popup: Popup {
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                y: comboBox.height + 4

                implicitWidth: comboBox.width
                height: Math.min(implicitContentHeight + topPadding + bottomPadding,
                                 comboBox.Window.height - topMargin - bottomMargin)
                margins: 8

                padding: 1
                verticalPadding: 8

                background: Rectangle {
                    color: Theme.palette.statusSelect.menuItemBackgroundColor
                    radius: 8
                    border.color: Theme.palette.baseColor2
                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 4
                        radius: 12
                        samples: 25
                        spread: 0.2
                        color: Theme.palette.dropShadow
                    }
                }

                contentItem: StatusListView {
                    id: listView
                    objectName: root.popupContentItemObjectName
                    implicitWidth: contentWidth
                    implicitHeight: contentHeight

                    model: comboBox.popup.visible ? comboBox.delegateModel : null
                    currentIndex: comboBox.highlightedIndex
                }
            }

            delegate: StatusItemDelegate {
                width: comboBox.width
                highlighted: comboBox.highlightedIndex === index
                font: comboBox.font
                text: control.textRole ? (Array.isArray(control.model)
                                          ? modelData[control.textRole]
                                          : model[control.textRole])
                                       : modelData
            }
        }

        StatusBaseText {
            id: validationErrorItem
            Layout.fillWidth: true
            Layout.topMargin: 11
            visible: !!text
            font.pixelSize: Theme.tertiaryTextFontSize
            color: Theme.palette.dangerColor1
            horizontalAlignment: TextEdit.AlignRight
            wrapMode: Text.WordWrap
        }
    }
}
