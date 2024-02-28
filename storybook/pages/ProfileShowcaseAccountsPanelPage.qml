import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.15

import StatusQ.Core 0.1
import StatusQ.Core.Utils 0.1 as CoreUtils

import AppLayouts.Profile.panels 1.0
import shared.stores 1.0

import utils 1.0

import Storybook 1.0
import Models 1.0

SplitView {
    id: root

    Logs { id: logs }

    orientation: Qt.Vertical

    readonly property string currentWallet: "0xcdc2ea3b6ba8fed3a3402f8db8b2fab53e7b7420"

    ListModel {
        id: hiddenModelItem
        ListElement {
            name: "My Status Account"
            key: "0xcdc2ea3b6ba8fed3a3402f8db8b2fab53e7b7420"
            colorId: "primary"
            emoji: "🇨🇿"
            walletType: ""
            visibility: 0
        }
        ListElement {
            name: "testing (no emoji, colored, seed)"
            key: "0xcdc2ea3b6ba8fed3a3402f8db8b2fab53e7b7000"
            colorId: ""
            emoji: ""
            walletType: "seed"
            visibility: 0
        }
        ListElement {
            name: "My Bro's Account"
            key: "0xcdc2ea3b6ba8fed3a3402f8db8b2fab53e7b7421"
            colorId: "orange"
            emoji: "🇸🇰"
            walletType: "watch"
            visibility: 0
        }
    }

    ListModel {
        id: inShowcaseModelItem

        ListElement {
            name: "My Status Account"
            key: "0xcdc2ea3b6ba8fed3a3402f8db8b2fab53e7b7420"
            colorId: "primary"
            emoji: "🇨🇿"
            walletType: ""
            visibility: 1
        }
        ListElement {
            name: "testing (no emoji, colored, seed)"
            key: "0xcdc2ea3b6ba8fed3a3402f8db8b2fab53e7b7000"
            colorId: ""
            emoji: ""
            walletType: "seed"
            visibility: 1
        }
        ListElement {
            name: "My Bro's Account"
            key: "0xcdc2ea3b6ba8fed3a3402f8db8b2fab53e7b7421"
            colorId: "orange"
            emoji: "🇸🇰"
            walletType: "watch"
            visibility: 1
        }
    }

    ListModel {
        id: emptyModel
    }

    ProfileShowcaseAccountsPanel {
        id: showcasePanel
        SplitView.fillWidth: true
        SplitView.preferredHeight: 500
        inShowcaseModel: emptyModelChecker.checked ? emptyModel : inShowcaseModelItem
        hiddenModel: emptyModelChecker.checked ? emptyModel : hiddenModelItem
        currentWallet: root.currentWallet
    }

    LogsAndControlsPanel {
        id: logsAndControlsPanel

        SplitView.minimumHeight: 100
        SplitView.preferredHeight: 200

        logsView.logText: logs.logText

        ColumnLayout {
            Label {
                text: "ⓘ Shwcase interaction implemented in ProfileShowcasePanelPage"
            }

            CheckBox {
                id: emptyModelChecker

                text: "Empty model"
                checked: false
            }
        }
    }
}

// category: Panels

// https://www.figma.com/file/ibJOTPlNtIxESwS96vJb06/%F0%9F%91%A4-Profile-%7C-Desktop?type=design&node-id=2460%3A40333&mode=design&t=Zj3tcx9uj05XHYti-1
// https://www.figma.com/file/ibJOTPlNtIxESwS96vJb06/%F0%9F%91%A4-Profile-%7C-Desktop?type=design&node-id=2460%3A40362&mode=design&t=Zj3tcx9uj05XHYti-1
