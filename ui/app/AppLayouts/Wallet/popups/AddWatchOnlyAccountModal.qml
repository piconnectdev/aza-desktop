import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.3

import utils 1.0

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1
import StatusQ.Controls 0.1

import shared.popups 1.0
import shared.controls 1.0

import "../stores"

// TODO: replace with StatusModal
ModalPopup {
    id: popup
    //% "Add a watch-only account"
    title: qsTrId("add-watch-account")

    property int marginBetweenInputs: 38
    property string addressError: ""
    property string accountNameValidationError: ""
    property bool loading: false

    signal afterAddAccount()

    function validate() {
        if (addressInput.text === "") {
            //% "You need to enter an address"
            addressError = qsTrId("you-need-to-enter-an-address")
        } else if (!Utils.isAddress(addressInput.text)) {
            //% "This needs to be a valid address (starting with 0x)"
            addressError = qsTrId("this-needs-to-be-a-valid-address-(starting-with-0x)")
        } else {
            addressError = ""
        }

        if (accountNameInput.text === "") {
            //% "You need to enter an account name"
            accountNameValidationError = qsTrId("you-need-to-enter-an-account-name")
        } else {
            accountNameValidationError = ""
        }

        return addressError === "" && accountNameValidationError === ""
    }

    onOpened: {
        addressError = "";
        accountNameValidationError = "";
        addressInput.text = "";
        accountNameInput.text = "";
        accountColorInput.selectedColor = Style.current.accountColors[Math.floor(Math.random() * Style.current.accountColors.length)]
        addressInput.forceActiveFocus(Qt.MouseFocusReason)
    }

    Input {
        id: addressInput
        // TODO add QR code reader for the address
        //% "Enter address..."
        placeholderText: qsTrId("enter-address...")
        //% "Account address"
        label: qsTrId("wallet-key-title")
        validationError: popup.addressError
    }

    Input {
        id: accountNameInput
        anchors.top: addressInput.bottom
        anchors.topMargin: marginBetweenInputs
        //% "Enter an account name..."
        placeholderText: qsTrId("enter-an-account-name...")
        //% "Account name"
        label: qsTrId("account-name")
        validationError: popup.accountNameValidationError
    }

    StatusWalletColorSelect {
        id: accountColorInput
        anchors.top: accountNameInput.bottom
        anchors.topMargin: marginBetweenInputs
        anchors.left: parent.left
        anchors.right: parent.right
        model: Theme.palette.accountColors
    }

    footer: StatusButton {
        anchors.top: parent.top
        anchors.right: parent.right
        text: loading ?
        //% "Loading..."
        qsTrId("loading") :
        //% "Add account"
        qsTrId("add-account")

        enabled: !loading && addressInput.text !== "" && accountNameInput.text !== ""

        MessageDialog {
            id: accountError
            title: "Adding the account failed"
            icon: StandardIcon.Critical
            standardButtons: StandardButton.Ok
        }

        onClicked : {
            // TODO the loaidng doesn't work because the function freezes th eview. Might need to use threads
            loading = true
            if (!validate()) {
                Global.playErrorSound();
                return loading = false
            }

            const error = RootStore.addWatchOnlyAccount(addressInput.text, accountNameInput.text, accountColorInput.selectedColor);
            loading = false
            if (error) {
                Global.playErrorSound();
                accountError.text = error
                return accountError.open()
            }
            popup.afterAddAccount()
            popup.close();
        }
    }
}
