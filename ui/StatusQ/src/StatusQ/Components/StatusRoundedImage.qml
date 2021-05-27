import QtQuick 2.13
import QtGraphicalEffects 1.0
import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1

Rectangle {
    id: statusRoundImage

    property bool showLoadingIndicator: false

    property alias image: image

    implicitWidth: 40
    implicitHeight: 40
    color: "transparent"
    radius: width / 2
    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            x: statusRoundImage.x; y: statusRoundImage.y
            width: statusRoundImage.width
            height: statusRoundImage.height
            radius: statusRoundImage.radius
        }
    }

    Image {
        id: image
        sourceSize.width: parent.implicitWidth
        sourceSize.height: parent.implicitHeight
        fillMode: Image.PreserveAspectFit
        cache: true
    }

    Loader {
        id: itemSelector
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        active: showLoadingIndicator && image.status === Image.Loading
        sourceComponent: StatusLoadingIndicator {
            color: Theme.palette.directColor6

        }
    }
}
