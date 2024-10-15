import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import utils 1.0

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1
import StatusQ.Controls 0.1
import StatusQ.Components 0.1

Item {
    property string ensUsername: ""
    signal okBtnClicked()

    StatusBaseText {
        id: sectionTitle
        text: qsTr("ENS usernames")
        anchors.left: parent.left
        anchors.leftMargin: Theme.bigPadding
        anchors.top: parent.top
        anchors.topMargin: Theme.bigPadding
        font.weight: Font.Bold
        font.pixelSize: 20
        color: Theme.palette.directColor1

        StatusBetaTag {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 7
        }
    }


    // Replace with StatusQ component
    Rectangle {
        id: circle
        anchors.top: sectionTitle.bottom
        anchors.topMargin: Theme.bigPadding
        anchors.horizontalCenter: parent.horizontalCenter
        width: 60
        height: 60
        radius: 120
        color: Theme.palette.primaryColor1

        StatusBaseText {
            text: "✓"
            opacity: 0.7
            font.weight: Font.Bold
            font.pixelSize: 18
            color: Theme.palette.indirectColor1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    StatusBaseText {
        id: title
        text: qsTr("Username added")
        anchors.top: circle.bottom
        anchors.topMargin: Theme.bigPadding
        font.weight: Font.Bold
        font.pixelSize: 24
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: Theme.palette.directColor1
    }

    StatusBaseText {
        id: subtitle
        text: qsTr("Nice! You own %1.stateofus.eth once the transaction is complete.").arg(ensUsername)
        anchors.top: title.bottom
        anchors.topMargin: 24
        font.pixelSize: 14
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: Theme.palette.directColor1
    }

    StatusBaseText {
        id: progress
        text: qsTr("You can follow the progress in the Transaction History section of your wallet.")
        anchors.top: subtitle.bottom
        anchors.topMargin: 24
        font.pixelSize: 12
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: Theme.palette.baseColor1

    }

    StatusButton {
        id: startBtn
        anchors.top: progress.bottom
        anchors.topMargin: Theme.padding
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Ok, got it")
        onClicked: okBtnClicked()
    }
}
