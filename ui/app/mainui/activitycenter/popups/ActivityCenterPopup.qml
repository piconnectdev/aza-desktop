import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

import StatusQ.Core 0.1
import StatusQ.Controls 0.1

import shared 1.0
import shared.popups 1.0
import shared.views.chat 1.0

import utils 1.0

import "../views"
import "../panels"
import "../stores"

Popup {
    id: root

    property ActivityCenterStore activityCenterStore
    property var store

    onOpened: {
        Global.popupOpened = true
    }
    onClosed: {
        Global.popupOpened = false
        activityCenterStore.markAsSeenActivityCenterNotifications()
    }

    x: Global.applicationWindow.width - root.width - Style.current.halfPadding
    width: 560
    padding: 0
    modal: false
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    parent: Overlay.overlay

    Overlay.modeless: null

    background: Rectangle {
        color: Style.current.background
        radius: Style.current.radius
        layer.enabled: true
        layer.effect: DropShadow {
            verticalOffset: 3
            radius: Style.current.radius
            samples: 15
            fast: true
            cached: true
            color: Style.current.dropShadow
        }
    }

    ActivityCenterPopupTopBarPanel {
        id: activityCenterTopBar
        width: parent.width
        unreadNotificationsCount: activityCenterStore.unreadNotificationsCount
        hasAdmin: activityCenterStore.adminCount > 0
        hasReplies: activityCenterStore.repliesCount > 0
        hasMentions: activityCenterStore.mentionsCount > 0
        hasContactRequests: activityCenterStore.contactRequestsCount > 0
        hasIdentityRequests: activityCenterStore.identityRequestsCount > 0
        hasMembership: activityCenterStore.membershipCount > 0
        hideReadNotifications: activityCenterStore.activityCenterReadType === ActivityCenterStore.ActivityCenterReadType.Unread
        activeGroup: activityCenterStore.activeNotificationGroup
        onGroupTriggered: activityCenterStore.setActiveNotificationGroup(group)
        onMarkAllReadClicked: activityCenterStore.markAllActivityCenterNotificationsRead()
        onShowHideReadNotifications: activityCenterStore.setActivityCenterReadType(hideReadNotifications ?
                                                                                        ActivityCenterStore.ActivityCenterReadType.Unread :
                                                                                        ActivityCenterStore.ActivityCenterReadType.All)
    }

    StatusListView {
        id: listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: activityCenterTopBar.bottom
        anchors.bottom: parent.bottom
        anchors.margins: Style.current.smallPadding
        spacing: 1

        model: root.activityCenterStore.activityCenterNotifications

        delegate: Loader {
            width: listView.availableWidth

            property int filteredIndex: index
            property var notification: model

            sourceComponent: {
                switch (model.notificationType) {
                    case ActivityCenterStore.ActivityCenterNotificationType.Mention:
                        return mentionNotificationComponent
                    case ActivityCenterStore.ActivityCenterNotificationType.Reply:
                        return replyNotificationComponent
                    case ActivityCenterStore.ActivityCenterNotificationType.ContactRequest:
                        return contactRequestNotificationComponent
                    case ActivityCenterStore.ActivityCenterNotificationType.ContactVerification:
                        return verificationRequestNotificationComponent
                    case ActivityCenterStore.ActivityCenterNotificationType.CommunityInvitation:
                        return communityInvitationNotificationComponent
                    case ActivityCenterStore.ActivityCenterNotificationType.MembershipRequest:
                        return membershipRequestNotificationComponent
                    case ActivityCenterStore.ActivityCenterNotificationType.CommunityRequest:
                        return communityRequestNotificationComponent
                    case ActivityCenterStore.ActivityCenterNotificationType.CommunityKicked:
                        return communityKickedNotificationComponent
                    default:
                        return null
                }
            }
        }
    }

    Component {
        id: mentionNotificationComponent

        ActivityNotificationMention {
            filteredIndex: parent.filteredIndex
            notification: parent.notification
            store: root.store
            activityCenterStore: root.activityCenterStore
            onCloseActivityCenter: root.close()
        }
    }
    Component {
        id: replyNotificationComponent

        ActivityNotificationReply {
            filteredIndex: parent.filteredIndex
            notification: parent.notification
            store: root.store
            activityCenterStore: root.activityCenterStore
            onCloseActivityCenter: root.close()
        }
    }
    Component {
        id: contactRequestNotificationComponent

        ActivityNotificationContactRequest {
            filteredIndex: parent.filteredIndex
            notification: parent.notification
            store: root.store
            activityCenterStore: root.activityCenterStore
            onCloseActivityCenter: root.close()
        }
    }
    Component {
        id: verificationRequestNotificationComponent

        ActivityNotificationContactVerification {
            filteredIndex: parent.filteredIndex
            notification: parent.notification
            store: root.store
            activityCenterStore: root.activityCenterStore
            onCloseActivityCenter: root.close()
        }
    }
    Component {
        id: communityInvitationNotificationComponent

        ActivityNotificationCommunityInvitation {
            filteredIndex: parent.filteredIndex
            notification: parent.notification
            store: root.store
            activityCenterStore: root.activityCenterStore
            onCloseActivityCenter: root.close()
        }
    }
    Component {
        id: membershipRequestNotificationComponent

        ActivityNotificationCommunityMembershipRequest {
            filteredIndex: parent.filteredIndex
            notification: parent.notification
            store: root.store
            activityCenterStore: root.activityCenterStore
            onCloseActivityCenter: root.close()
        }
    }
    Component {
        id: communityRequestNotificationComponent

        ActivityNotificationCommunityRequest {
            filteredIndex: parent.filteredIndex
            notification: parent.notification
            store: root.store
            activityCenterStore: root.activityCenterStore
            onCloseActivityCenter: root.close()
        }
    }
    Component {
        id: communityKickedNotificationComponent

        ActivityNotificationCommunityKicked {
            filteredIndex: parent.filteredIndex
            notification: parent.notification
            store: root.store
            activityCenterStore: root.activityCenterStore
            onCloseActivityCenter: root.close()
        }
    }
}
