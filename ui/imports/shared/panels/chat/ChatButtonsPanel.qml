import QtQuick 2.13
import QtGraphicalEffects 1.13

import StatusQ.Controls 0.1

import utils 1.0

Rectangle {
    id: buttonsContainer
    property bool parentIsHovered: false
    property bool isChatBlocked: false
    property int containerMargin: 2
    property int contentType: 2
    property bool isCurrentUser: false
    property bool isMessageActive: false
    property var messageContextMenu
    property bool showMoreButton: true
    property bool isInPinnedPopup: false
    property bool activityCenterMsg
    property bool placeholderMsg
    property string fromAuthor
    property bool editBtnActive: false
    signal replyClicked(string messageId, string author)
    signal hoverChanged(bool hovered)
    signal setMessageActive(string messageId, bool active)
    signal clickMessage(bool isProfileClick, bool isSticker, bool isImage, var image, bool isEmoji, bool hideEmojiPicker)

    visible: !buttonsContainer.isChatBlocked &&
             !buttonsContainer.placeholderMsg && !buttonsContainer.activityCenterMsg &&
             (buttonsContainer.parentIsHovered || isMessageActive)
             && contentType !== Constants.messageContentType.transactionType
    width: buttonRow.width + buttonsContainer.containerMargin * 2
    height: 36
    radius: Style.current.radius
    color: Style.current.modalBackground
    z: 52

    layer.enabled: true
    layer.effect: DropShadow {
        width: buttonsContainer.width
        height: buttonsContainer.height
        x: buttonsContainer.x
        y: buttonsContainer.y + 10
        visible: buttonsContainer.visible
        source: buttonsContainer
        horizontalOffset: 0
        verticalOffset: 2
        radius: 10
        samples: 15
        color: "#22000000"
    }

    MouseArea {
        anchors.fill: buttonsContainer
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
        onEntered: {
            buttonsContainer.hoverChanged(true)
        }
        onExited: {
            buttonsContainer.hoverChanged(false)
        }
    }

    Row {
        id: buttonRow
        spacing: buttonsContainer.containerMargin
        anchors.left: parent.left
        anchors.leftMargin: buttonsContainer.containerMargin
        anchors.verticalCenter: buttonsContainer.verticalCenter
        height: parent.height - 2 * buttonsContainer.containerMargin

        Loader {
            active: !buttonsContainer.isInPinnedPopup
            sourceComponent: StatusFlatRoundButton {
                id: emojiBtn
                width: 32
                height: 32
                icon.name: "reaction-b"
                type: StatusFlatRoundButton.Type.Tertiary
                //% "Add reaction"
                tooltip.text: qsTrId("add-reaction")
                onClicked: {
                    setMessageActive(messageId, true)
                    // Set parent, X & Y positions for the messageContextMenu
                    buttonsContainer.messageContextMenu.parent = buttonsContainer
                    buttonsContainer.messageContextMenu.setXPosition = function() { return (-Math.abs(buttonsContainer.width - buttonsContainer.messageContextMenu.emojiContainer.width))}
                    buttonsContainer.messageContextMenu.setYPosition = function() { return (-buttonsContainer.messageContextMenu.height - 4)}
                    buttonsContainer.clickMessage(false, false, false, null, true, false)
                }
                onHoveredChanged: buttonsContainer.hoverChanged(this.hovered)
            }
        }

        Loader {
            active: !buttonsContainer.isInPinnedPopup
            sourceComponent: StatusFlatRoundButton {
                id: replyBtn
                width: 32
                height: 32
                icon.name: "reply"
                type: StatusFlatRoundButton.Type.Tertiary
                //% "Reply"
                tooltip.text: qsTrId("message-reply")
                onClicked: {
                    buttonsContainer.replyClicked(messageId, fromAuthor);
                    if (messageContextMenu.closeParentPopup) {
                        messageContextMenu.closeParentPopup()
                    }
                }
                onHoveredChanged: buttonsContainer.hoverChanged(this.hovered)
            }
        }


        Loader {
            id: editBtn
            active: buttonsContainer.editBtnActive && !buttonsContainer.isInPinnedPopup
            sourceComponent: StatusFlatRoundButton {
                id: btn
                width: 32
                height: 32
                icon.source: Style.svg("edit-message")
                type: StatusFlatRoundButton.Type.Tertiary
                //% "Edit"
                tooltip.text: qsTrId("edit")
                onClicked: messageStore.setEditModeOn(messageId)
                onHoveredChanged: buttonsContainer.hoverChanged(btn.hovered)
            }
        }

        StatusFlatRoundButton {
            id: otherBtn
            width: 32
            height: 32
            visible: buttonsContainer.showMoreButton
            icon.name: "more"
            type: StatusFlatRoundButton.Type.Tertiary
            //% "More"
            tooltip.text: qsTrId("more")
            onClicked: {
                if (typeof isMessageActive !== "undefined") {
                    setMessageActive(messageId, true)
                }
                // Set parent, X & Y positions for the messageContextMenu
                buttonsContainer.messageContextMenu.parent = buttonsContainer
                buttonsContainer.messageContextMenu.setXPosition = function() { return (-Math.abs(buttonsContainer.width - 176))}
                buttonsContainer.messageContextMenu.setYPosition = function() { return (-buttonsContainer.messageContextMenu.height - 4)}
                buttonsContainer.clickMessage(false, isSticker, false, null, false, true);
            }
            onHoveredChanged: buttonsContainer.hoverChanged(this.hovered)
        }
    }
}
