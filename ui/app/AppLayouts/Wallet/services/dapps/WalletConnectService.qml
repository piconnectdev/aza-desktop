import QtQuick 2.15

import StatusQ.Core.Theme 0.1
import StatusQ.Core.Utils 0.1

import AppLayouts.Wallet.services.dapps 1.0
import AppLayouts.Profile.stores 1.0
import shared.stores 1.0
import shared.popups.walletconnect 1.0

import SortFilterProxyModel 0.2
import utils 1.0

QObject {
    id: root

    required property WalletConnectSDK wcSDK
    required property DAppsStore store
    required property WalletStore walletStore

    readonly property alias dappsModel: d.dappsProvider.dappsModel

    readonly property var validAccounts: SortFilterProxyModel {
        sourceModel: walletStore.accounts
        filters: ValueFilter {
            roleName: "walletType"
            value: Constants.watchWalletType
            inverted: true
        }
    }
    readonly property var flatNetworks: walletStore.flatNetworks

    function pair(uri) {
        d.acceptedSessionProposal = null
        wcSDK.pair(uri)
    }

    function approvePairSession(sessionProposal, approvedChainIds, approvedAccount) {
        d.acceptedSessionProposal = sessionProposal
        let approvedNamespaces = JSON.parse(Helpers.buildSupportedNamespaces(approvedChainIds, [approvedAccount.address]))
        wcSDK.buildApprovedNamespaces(sessionProposal.params, approvedNamespaces)
    }

    function rejectPairSession(id) {
        wcSDK.rejectSession(id)
    }

    function disconnectDapp(sessionTopic) {
        wcSDK.disconnectSession(sessionTopic)
    }

    signal connectDApp(var dappChains, var sessionProposal, var approvedNamespaces)
    signal approveSessionResult(var session, var error)

    readonly property Connections sdkConnections: Connections {
        target: wcSDK

        function onSessionProposal(sessionProposal) {
            d.currentSessionProposal = sessionProposal

            let supportedNamespacesStr = Helpers.buildSupportedNamespacesFromModels(root.flatNetworks, root.validAccounts)
            wcSDK.buildApprovedNamespaces(sessionProposal.params, JSON.parse(supportedNamespacesStr))
        }

        function onBuildApprovedNamespacesResult(approvedNamespaces, error) {
            if(error) {
                // TODO: error reporting
                return
            }

            if (d.acceptedSessionProposal) {
                wcSDK.approveSession(d.acceptedSessionProposal, approvedNamespaces)
            } else {
                let res = Helpers.extractChainsAndAccountsFromApprovedNamespaces(approvedNamespaces)

                root.connectDApp(res.chains, d.currentSessionProposal, approvedNamespaces)
            }
        }

        function onApproveSessionResult(session, err) {
            // Notify client
            root.approveSessionResult(session, err)

            if (err) {
                // TODO #14676: handle the error
                console.error("Failed to approve session", err)
                return
            }

            // TODO #14754: implement custom dApp notification
            let app_url = d.currentSessionProposal ? d.currentSessionProposal.params.proposer.metadata.url : "-"
            Global.displayToastMessage(qsTr("Connected to %1 via WalletConnect").arg(app_url), "", "checkmark-circle", false, Constants.ephemeralNotificationType.success, "")

            // Persist session
            store.addWalletConnectSession(JSON.stringify(session))

            d.dappsProvider.updateDapps()
        }

        function onRejectSessionResult(err) {
            let app_url = d.currentSessionProposal ? d.currentSessionProposal.params.proposer.metadata.url : "-"
            if(err) {
                Global.displayToastMessage(qsTr("Failed to reject connection request for %1").arg(app_url), "", "warning", false, Constants.ephemeralNotificationType.danger, "")
            } else {
                Global.displayToastMessage(qsTr("Connection request for %1 was rejected").arg(app_url), "", "checkmark-circle", false, Constants.ephemeralNotificationType.success, "")
            }
        }

        function onSessionDelete(topic, err) {
            let app_url = d.currentSessionProposal ? d.currentSessionProposal.params.proposer.metadata.url : "-"
            if(err) {
                Global.displayToastMessage(qsTr("Failed to disconnect from %1").arg(app_url), "", "warning", false, Constants.ephemeralNotificationType.danger, "")
            } else {
                Global.displayToastMessage(qsTr("Disconnected from %1").arg(app_url), "", "checkmark-circle", false, Constants.ephemeralNotificationType.success, "")
            }
        }
    }

    QtObject {
        id: d

        property var currentSessionProposal: null
        property var acceptedSessionProposal: null

        readonly property DAppsListProvider dappsProvider: DAppsListProvider {
            sdk: root.wcSDK
            store: root.store
        }

        // TODO #14676: use it to check if already paired
        function getPairingTopicFromPairingUrl(url)
        {
            if (!url.startsWith("wc:"))
            {
                return null;
            }

            const atIndex = url.indexOf("@");
            if (atIndex < 0)
            {
                return null;
            }

            return url.slice(3, atIndex);
        }
    }

    Component.onCompleted: {
        d.dappsProvider.updateDapps()
    }
}