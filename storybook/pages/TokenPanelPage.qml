import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import Qt.labs.settings 1.0

import Models 1.0
import Storybook 1.0
import utils 1.0

import AppLayouts.Communities.controls 1.0

SplitView {
    id: root

    orientation: Qt.Vertical

    ListModel {
        id: networksModel

        readonly property var modelData: [
            {
                name: "Optimism",
                icon: Style.svg(ModelsData.networks.optimism),
                amount: "300",
                multiplierIndex: 0,
                infiniteAmount: false
            },
            {
                name: "Arbitrum",
                icon: Style.svg(ModelsData.networks.arbitrum),
                amount: "400000",
                multiplierIndex: 3,
                infiniteAmount: false
            },
            {
                name: "Hermez",
                icon: Style.svg(ModelsData.networks.hermez),
                amount: "0",
                multiplierIndex: 0,
                infiniteAmount: true
            },
            {
                name: "Ethereum",
                icon: Style.svg(ModelsData.networks.ethereum),
                amount: "12" + "0".repeat(18),
                multiplierIndex: 18,
                infiniteAmount: false
            }
        ]

        Component.onCompleted: append(modelData)
    }

    Item {
        id: container

        SplitView.fillWidth: true
        SplitView.fillHeight: true

        Rectangle {
            anchors.fill: tokenPanel
            border.width: 1
            anchors.margins: -15
        }

        TokenPanel {
            id: tokenPanel

            mode: {
                if (addRadioButton.checked)
                    return HoldingTypes.Mode.Add
                else if (updateRadioButton.checked)
                    return HoldingTypes.Mode.Update
                else
                    return HoldingTypes.Mode.UpdateOrRemove
            }

            tokenCategoryText: "Community asset"
            tokenName: "Token name"
            tokenShortName: "TN"
            tokenAmount: amountTextField.text
            tokenImage: ModelsData.assets.socks

            networksModel: networksModelCheckBox.checked ? networksModel : null

            width: 300
            anchors.centerIn: parent
        }
    }

    LogsAndControlsPanel {
        SplitView.minimumHeight: 100
        SplitView.preferredHeight: 200

        SplitView.fillWidth: true

        ColumnLayout {
            RowLayout {
                RadioButton {
                    id: addRadioButton
                    text: "Add"

                    checked: true
                }
                RadioButton {
                    id: updateRadioButton
                    text: "Update"
                }

                RadioButton {
                    id: updateOrRemoveRadioButton
                    text: "Update or remove"
                }
            }

            CheckBox {
                id: networksModelCheckBox

                text: "Networks model"
            }

            RowLayout {
                Label {
                    text: "Amount:"

                }
                TextField {
                    id: amountTextField

                    text: "∞"
                }
            }

            Label {
                text: "amount: " + tokenPanel.amount
            }
        }
    }

    Settings {
        property alias networksModelCheckBoxChecked:
            networksModelCheckBox.checked
    }
}

// category: Panels
