﻿import QtQuick 2.15
import QtTest 1.15

import StatusQ 0.1 // See #10218
import StatusQ.Core 0.1
import StatusQ.Core.Utils 0.1 as SQUtils
import StatusQ.Core.Theme 0.1
import StatusQ.Controls 0.1

import QtQuick.Controls 2.15

import Models 1.0
import Storybook 1.0

import utils 1.0
import shared.stores 1.0
import AppLayouts.Wallet.popups.swap 1.0
import AppLayouts.Wallet.stores 1.0
import AppLayouts.Wallet 1.0
import AppLayouts.Wallet.adaptors 1.0

Item {
    id: root
    width: 800
    height: 600

    readonly property var dummySwapTransactionRoutes: SwapTransactionRoutes {}

    readonly property var swapStore: SwapStore {
        signal suggestedRoutesReady(var txRoutes)
        signal transactionSent(var chainId,var txHash, var uuid, var error)
        signal transactionSendingComplete(var txHash,  var success)

        readonly property var accounts: WalletAccountsModel {}
        readonly property var flatNetworks: NetworksModel.flatNetworks
        readonly property bool areTestNetworksEnabled: true
        function getWei2Eth(wei, decimals) {
            return wei/(10**decimals)
        }
        function fetchSuggestedRoutes(uuid, accountFrom, accountTo, amount, tokenFrom, tokenTo,
                                      disabledFromChainIDs, disabledToChainIDs, preferredChainIDs, sendType, lockedInAmounts) {
                    swapStore.fetchSuggestedRoutesCalled()
        }
        function authenticateAndTransfer(uuid, accountFrom, accountTo, tokenFrom,
                                         tokenTo, sendType, tokenName, tokenIsOwnerToken, paths) {}
        // local signals for testing function calls
        signal fetchSuggestedRoutesCalled()
    }

    readonly property var swapAdaptor: SwapModalAdaptor {
        currencyStore: CurrenciesStore {}
        walletAssetsStore: WalletAssetsStore {
            id: thisWalletAssetStore
            walletTokensStore: TokensStore {
                plainTokensBySymbolModel: TokensBySymbolModel {}
                getDisplayAssetsBelowBalanceThresholdDisplayAmount: () => 0
            }
            readonly property var baseGroupedAccountAssetModel: GroupedAccountsAssetsModel {}
            assetsWithFilteredBalances: thisWalletAssetStore.groupedAccountsAssetsModel
        }
        swapStore: root.swapStore
        swapFormData: root.swapFormData
        swapOutputData: SwapOutputData{}
    }

    readonly property var tokenSelectorAdaptor: TokenSelectorViewAdaptor {
        assetsModel: swapAdaptor.walletAssetsStore.groupedAccountAssetsModel
        flatNetworksModel: swapStore.flatNetworks
        currentCurrency: swapAdaptor.currencyStore.currentCurrency
        plainTokensBySymbolModel: root.swapAdaptor.walletAssetsStore.walletTokensStore.plainTokensBySymbolModel

        enabledChainIds: !!root.swapFormData && root.swapFormData.selectedNetworkChainId !== - 1 ? [root.swapFormData.selectedNetworkChainId] : []
        accountAddress: !!root.swapFormData && root.swapFormData.selectedAccountAddress
    }

    property SwapInputParamsForm swapFormData: SwapInputParamsForm {
        defaultToTokenKey: Constants.swap.testStatusTokenKey
    }

    Component {
        id: componentUnderTest
        SwapModal {
            swapInputParamsForm: root.swapFormData
            swapAdaptor: root.swapAdaptor
            loginType: Constants.LoginType.Password
        }
    }

    SignalSpy {
        id: formValuesChanged
        target: swapFormData
        signalName: "formValuesChanged"
    }

    SignalSpy {
        id: fetchSuggestedRoutesCalled
        target: swapStore
        signalName: "fetchSuggestedRoutesCalled"
    }

    TestCase {
        name: "SwapModal"
        when: windowShown

        property SwapModal controlUnderTest: null

        // helper functions -------------------------------------------------------------

        function init() {
            swapAdaptor.swapFormData = root.swapFormData
            controlUnderTest = createTemporaryObject(componentUnderTest, root, { swapInputParamsForm: root.swapFormData})
        }

        function cleanup() {
            root.swapFormData.resetFormData()
            formValuesChanged.clear()
        }

        function launchAndVerfyModal() {
            formValuesChanged.clear()
            verify(!!controlUnderTest)
            controlUnderTest.open()
            verify(!!controlUnderTest.opened)
        }

        function closeAndVerfyModal() {
            verify(!!controlUnderTest)
            controlUnderTest.close()
            verify(!controlUnderTest.opened)
            formValuesChanged.clear()
            root.swapFormData.resetFormData()
        }

        function getAndVerifyAccountsModalHeader() {
            const accountsModalHeader = findChild(controlUnderTest, "accountSelector")
            verify(!!accountsModalHeader)
            return accountsModalHeader
        }

        function launchAccountSelectionPopup(accountsModalHeader) {
            // Launch account selection popup
            verify(!accountsModalHeader.control.popup.opened)
            mouseClick(accountsModalHeader)
            waitForRendering(accountsModalHeader)
            verify(!!accountsModalHeader.control.popup.opened)
            mouseMove(accountsModalHeader)
            return accountsModalHeader
        }

        function verifyLoadingAndNoErrorsState(payPanel, receivePanel) {
            // verify loading state was set and no errors currently
            verify(!root.swapAdaptor.validSwapProposalReceived)
            verify(root.swapAdaptor.swapProposalLoading)
            compare(root.swapAdaptor.swapOutputData.rawPaths, [])
            compare(root.swapAdaptor.swapOutputData.hasError, false)

            // verfy input and output panels
            verify(!payPanel.mainInputLoading)
            verify(!payPanel.bottomTextLoading)
            compare(payPanel.selectedHoldingId, root.swapFormData.fromTokensKey)
            compare(payPanel.value, Number(root.swapFormData.fromTokenAmount))
            compare(payPanel.rawValue, SQUtils.AmountsArithmetic.fromNumber(root.swapFormData.fromTokenAmount, root.swapAdaptor.fromToken.decimals).toString())
            verify(payPanel.valueValid)
            verify(receivePanel.mainInputLoading)
            verify(receivePanel.bottomTextLoading)
            verify(!receivePanel.interactive)
            compare(receivePanel.selectedHoldingId, root.swapFormData.toTokenKey)
            compare(receivePanel.value, 0)
            compare(receivePanel.rawValue, "0")
        }
        // end helper functions -------------------------------------------------------------

        function test_floating_header_default_account() {
            verify(!!controlUnderTest)
            /* using a for loop set different accounts as default index and
            check if the correct values are displayed in the floating header*/
            for (let i = 0; i< swapAdaptor.nonWatchAccounts.count; i++) {
                const nonWatchAccount = swapAdaptor.nonWatchAccounts.get(i)
                root.swapFormData.selectedAccountAddress = nonWatchAccount.address

                // Launch popup
                launchAndVerfyModal()

                const floatingHeaderBackground = findChild(controlUnderTest, "headerBackground")
                verify(!!floatingHeaderBackground)
                compare(floatingHeaderBackground.color.toString().toUpperCase(), Utils.getColorForId(nonWatchAccount.colorId).toString().toUpperCase())

                const headerContentItemText = findChild(controlUnderTest, "textContent")
                verify(!!headerContentItemText)
                compare(headerContentItemText.text, nonWatchAccount.name)

                const headerContentItemEmoji = findChild(controlUnderTest, "assetContent")
                verify(!!headerContentItemEmoji)
                compare(headerContentItemEmoji.asset.emoji, nonWatchAccount.emoji)
            }
            closeAndVerfyModal()
        }

        function test_floating_header_doesnt_contain_watch_accounts() {
            // main input list from store should contian watch accounts
            let hasWatchAccount = false
            for(let i =0; i< swapStore.accounts.count; i++) {
                if(swapStore.accounts.get(i).walletType === Constants.watchWalletType) {
                    hasWatchAccount = true
                    break
                }
            }
            verify(!!hasWatchAccount)

            // launch modal and get the account selection header
            launchAndVerfyModal()
            const accountsModalHeader = getAndVerifyAccountsModalHeader()

            // header model should not contain watch accounts
            let floatingHeaderHasWatchAccount = false
            for(let i =0; i< accountsModalHeader.model.count; i++) {
                if(accountsModalHeader.model.get(i).walletType === Constants.watchWalletType) {
                    floatingHeaderHasWatchAccount = true
                    break
                }
            }
            verify(!floatingHeaderHasWatchAccount)

            closeAndVerfyModal()
        }

        function test_floating_header_list_items() {
            // Launch popup and account selection modal
            launchAndVerfyModal()
            const accountsModalHeader = getAndVerifyAccountsModalHeader()
            launchAccountSelectionPopup(accountsModalHeader)

            const comboBoxList = findChild(controlUnderTest, "accountSelectorList")
            verify(!!comboBoxList)
            waitForRendering(comboBoxList)

            for(let i =0; i< comboBoxList.model.count; i++) {
                let delegateUnderTest = comboBoxList.itemAtIndex(i)
                compare(delegateUnderTest.title, swapAdaptor.nonWatchAccounts.get(i).name)
                compare(delegateUnderTest.subTitle, SQUtils.Utils.elideAndFormatWalletAddress(swapAdaptor.nonWatchAccounts.get(i).address))
                compare(delegateUnderTest.asset.color.toString().toUpperCase(), swapAdaptor.nonWatchAccounts.get(i).color.toString().toUpperCase())
                compare(delegateUnderTest.asset.emoji, swapAdaptor.nonWatchAccounts.get(i).emoji)

                const walletAccountCurrencyBalance = findChild(delegateUnderTest, "walletAccountCurrencyBalance")
                verify(!!walletAccountCurrencyBalance)
                verify(walletAccountCurrencyBalance.text, LocaleUtils.currencyAmountToLocaleString(swapAdaptor.nonWatchAccounts.get(i).currencyBalance))

                // check if selected item in combo box is highlighted with the right color
                if(comboBoxList.currentIndex === i) {
                    verify(delegateUnderTest.color, Theme.palette.statusListItem.highlightColor)
                }
                else {
                    verify(delegateUnderTest.color, Theme.palette.transparent)
                }

                // TODO: always null not sure why
                // const walletAccountTypeIcon = findChild(delegateUnderTest, "walletAccountTypeIcon")
                // verify(!!walletAccountTypeIcon)
                // compare(walletAccountTypeIcon.icon, swapAdaptor.nonWatchAccounts.get(i).walletType === Constants.watchWalletType ? "show" : delegateUnderTest.model.migratedToKeycard ? "keycard": "")

                // Hover over the item and check hovered state
                mouseMove(delegateUnderTest, delegateUnderTest.width/2, delegateUnderTest.height/2)
                verify(delegateUnderTest.sensor.containsMouse)
                compare(delegateUnderTest.title, swapAdaptor.nonWatchAccounts.get(i).name)
                compare(delegateUnderTest.subTitle, WalletUtils.colorizedChainPrefix(WalletUtils.getNetworkShortNames(swapAdaptor.nonWatchAccounts.get(i).preferredSharingChainIds, root.swapStore.flatNetworks)), "Randomly failing locally. Add a bug if you see this failing in CI")
                verify(delegateUnderTest.color, Theme.palette.baseColor2)

            }
            controlUnderTest.close()
        }

        function test_floating_header_after_setting_fromAsset() {
            // Launch popup
            launchAndVerfyModal()

            // launch account selection dropdown
            const accountsModalHeader = getAndVerifyAccountsModalHeader()
            launchAccountSelectionPopup(accountsModalHeader)

            const comboBoxList = findChild(accountsModalHeader, "accountSelectorList")
            verify(!!comboBoxList)

            // before setting network chainId and fromTokensKey the header should not have balances
            for(let i =0; i< comboBoxList.model.count; i++) {
                let delegateUnderTest = comboBoxList.itemAtIndex(i)
                verify(!delegateUnderTest.model.accountBalance)
            }

            // close account selection dropdown
            accountsModalHeader.control.popup.close()

            // set network chainId and fromTokensKey and verify balances in account selection dropdown
            root.swapFormData.selectedNetworkChainId = root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId
            root.swapFormData.fromTokensKey = root.swapAdaptor.walletAssetsStore.walletTokensStore.plainTokensBySymbolModel.get(0).key
            compare(controlUnderTest.swapInputParamsForm.selectedNetworkChainId, root.swapFormData.selectedNetworkChainId)
            compare(controlUnderTest.swapInputParamsForm.fromTokensKey, root.swapFormData.fromTokensKey)

            // launch account selection dropdown
            launchAccountSelectionPopup(accountsModalHeader)
            verify(!!comboBoxList)

            for(let i =0; i< comboBoxList.model.count; i++) {
                let delegateUnderTest = comboBoxList.itemAtIndex(i)
                verify(!!delegateUnderTest.model.fromToken)
                verify(!!delegateUnderTest.model.accountBalance)
                compare(delegateUnderTest.inlineTagModel, 1)

                const inlineTagDelegate_0 = findChild(delegateUnderTest, "inlineTagDelegate_0")
                verify(!!inlineTagDelegate_0)

                const balance = delegateUnderTest.model.accountBalance.balance

                compare(inlineTagDelegate_0.asset.name, Style.svg("tiny/%1".arg(delegateUnderTest.model.accountBalance.iconUrl)))
                compare(inlineTagDelegate_0.asset.color.toString().toUpperCase(), delegateUnderTest.model.accountBalance.chainColor.toString().toUpperCase())
                compare(inlineTagDelegate_0.titleText.color, balance === "0" ? Theme.palette.baseColor1 : Theme.palette.directColor1)

                let bigIntBalance = SQUtils.AmountsArithmetic.toNumber(balance, delegateUnderTest.model.fromToken.decimals)
                compare(inlineTagDelegate_0.title, balance === "0" ? "0 %1".arg(delegateUnderTest.model.fromToken.symbol)
                                                                   : root.swapAdaptor.formatCurrencyAmount(bigIntBalance, delegateUnderTest.model.fromToken.symbol))
            }

            closeAndVerfyModal()
        }

        function test_floating_header_selection() {
            // Launch popup
            launchAndVerfyModal()

            const payPanel = findChild(controlUnderTest, "payPanel")
            verify(!!payPanel)
            const amountToSendInput = findChild(payPanel, "amountToSendInput")
            verify(!!amountToSendInput)
            verify(amountToSendInput.input.input.edit.activeFocus)
            verify(amountToSendInput.input.input.edit.cursorVisible)

            for(let i =0; i< swapAdaptor.nonWatchAccounts.count; i++) {
                // launch account selection dropdown
                const accountsModalHeader = getAndVerifyAccountsModalHeader()
                launchAccountSelectionPopup(accountsModalHeader)

                const comboBoxList = findChild(accountsModalHeader, "accountSelectorList")
                verify(!!comboBoxList)

                let delegateUnderTest = comboBoxList.itemAtIndex(i)

                mouseClick(delegateUnderTest)
                waitForRendering(delegateUnderTest)
                verify(accountsModalHeader.control.popup.closed)

                // The input params form's slected Index should be updated  as per this selection
                compare(root.swapFormData.selectedAccountAddress, swapAdaptor.nonWatchAccounts.get(i).address)

                // The comboBox item should  reflect chosen account
                const floatingHeaderBackground = findChild(accountsModalHeader, "headerBackground")
                verify(!!floatingHeaderBackground)
                compare(floatingHeaderBackground.color.toString().toUpperCase(), swapAdaptor.nonWatchAccounts.get(i).color.toString().toUpperCase())

                const headerContentItemText = findChild(accountsModalHeader, "textContent")
                verify(!!headerContentItemText)
                compare(headerContentItemText.text, swapAdaptor.nonWatchAccounts.get(i).name)

                const headerContentItemEmoji = findChild(accountsModalHeader, "assetContent")
                verify(!!headerContentItemEmoji)
                compare(headerContentItemEmoji.asset.emoji, swapAdaptor.nonWatchAccounts.get(i).emoji)

                verify(amountToSendInput.input.input.edit.activeFocus)
                verify(amountToSendInput.input.input.edit.cursorVisible)
            }
            closeAndVerfyModal()
        }

        function test_network_default_and_selection() {
            // Launch popup
            launchAndVerfyModal()

            const payPanel = findChild(controlUnderTest, "payPanel")
            verify(!!payPanel)
            const amountToSendInput = findChild(payPanel, "amountToSendInput")
            verify(!!amountToSendInput)
            verify(amountToSendInput.input.input.edit.activeFocus)
            verify(amountToSendInput.input.input.edit.cursorVisible)

            // get network comboBox
            const networkComboBox = findChild(controlUnderTest, "networkFilter")
            verify(!!networkComboBox)

            // check default value of network comboBox, should be mainnet
            compare(root.swapFormData.selectedNetworkChainId, -1)
            compare(root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId, 11155111 /*Sepolia Mainnet*/)

            // lets ensure that the selected one is correctly set
            for (let i=0; i<networkComboBox.control.popup.contentItem.count; i++) {
                // launch network selection popup
                verify(!networkComboBox.control.popup.opened)
                mouseClick(networkComboBox)
                verify(networkComboBox.control.popup.opened)

                let delegateUnderTest = networkComboBox.control.popup.contentItem.itemAtIndex(i)
                verify(!!delegateUnderTest)

                // if you try selecting an item already selected it doesnt do anything
                if(networkComboBox.control.popup.contentItem.currentIndex === i) {
                    mouseClick(networkComboBox)
                } else {
                    // select item
                    mouseClick(delegateUnderTest)

                    // verify values set
                    verify(!networkComboBox.control.popup.opened)
                    compare(root.swapFormData.selectedNetworkChainId, networkComboBox.control.popup.contentItem.model.get(i).chainId)

                    const networkComboIcon = findChild(networkComboBox.control.contentItem, "contentItemIcon")
                    verify(!!networkComboIcon)
                    verify(networkComboIcon.asset.name.includes(root.swapAdaptor.filteredFlatNetworksModel.get(i).iconUrl))

                    verify(amountToSendInput.input.input.edit.activeFocus)
                    verify(amountToSendInput.input.input.edit.cursorVisible)
                }
            }
            networkComboBox.control.popup.close()
            closeAndVerfyModal()
        }

        function test_network_and_account_header_items() {
            // Launch popup
            launchAndVerfyModal()

            // get network comboBox
            const networkComboBox = findChild(controlUnderTest, "networkFilter")
            verify(!!networkComboBox)

            for (let i=0; i<networkComboBox.control.popup.contentItem.count; i++) {
                // launch network selection popup
                verify(!networkComboBox.control.popup.opened)
                mouseClick(networkComboBox)
                verify(networkComboBox.control.popup.opened)

                let delegateUnderTest = networkComboBox.control.popup.contentItem.itemAtIndex(i)
                verify(!!delegateUnderTest)

                let networkModelItem = networkComboBox.control.popup.contentItem.model.get(i)

                // if you try selecting an item already selected it doesnt do anything
                if(networkComboBox.control.popup.contentItem.currentIndex === i) {
                    mouseClick(networkComboBox)
                    root.swapFormData.selectedNetworkChainId = networkModelItem.chainId
                } else {
                    // select item
                    mouseClick(delegateUnderTest)
                }

                root.swapFormData.fromTokensKey = root.swapAdaptor.walletAssetsStore.walletTokensStore.plainTokensBySymbolModel.get(0).key

                // verify values in accouns modal header dropdown
                const accountsModalHeader = getAndVerifyAccountsModalHeader()
                launchAccountSelectionPopup(accountsModalHeader)

                const comboBoxList = findChild(accountsModalHeader, "accountSelectorList")
                verify(!!comboBoxList)

                for(let j =0; j< comboBoxList.model.count; j++) {
                    let accountDelegateUnderTest = comboBoxList.itemAtIndex(j)
                    verify(!!accountDelegateUnderTest)
                    waitForItemPolished(accountDelegateUnderTest)
                    const inlineTagDelegate_0 = findChild(accountDelegateUnderTest, "inlineTagDelegate_0")
                    verify(!!inlineTagDelegate_0)

                    compare(inlineTagDelegate_0.asset.name, Style.svg("tiny/%1".arg(networkModelItem.iconUrl)))
                    compare(inlineTagDelegate_0.asset.color.toString().toUpperCase(), networkModelItem.chainColor.toString().toUpperCase())

                    let balancesModel = SQUtils.ModelUtils.getByKey(root.swapAdaptor.walletAssetsStore.baseGroupedAccountAssetModel, "tokensKey", root.swapFormData.fromTokensKey).balances
                    verify(!!balancesModel)
                    let filteredBalances = SQUtils.ModelUtils.modelToArray(balancesModel).filter(balances => balances.chainId === root.swapFormData.selectedNetworkChainId).filter(balances => balances.account === accountDelegateUnderTest.model.address)
                    verify(!!filteredBalances)
                    let accountBalance = filteredBalances.length > 0 ? filteredBalances[0]: { balance: "0", iconUrl: networkModelItem.iconUrl, chainColor: networkModelItem.chainColor}
                    verify(!!accountBalance)
                    let fromToken = SQUtils.ModelUtils.getByKey(root.swapAdaptor.walletAssetsStore.walletTokensStore.plainTokensBySymbolModel, "key", root.swapFormData.fromTokensKey)
                    verify(!!fromToken)
                    let bigIntBalance = SQUtils.AmountsArithmetic.toNumber(accountBalance.balance, fromToken.decimals)
                    compare(inlineTagDelegate_0.title, bigIntBalance === 0 ? "0 %1".arg(fromToken.symbol)
                                                                           : root.swapAdaptor.formatCurrencyAmount(bigIntBalance, fromToken.symbol))
                }
                // close account selection dropdown
                accountsModalHeader.control.popup.close()
            }
            root.swapFormData.selectedNetworkChainId = -1
            networkComboBox.control.popup.close()
            closeAndVerfyModal()
        }

        function test_edit_slippage() {
            // Launch popup
            launchAndVerfyModal()

            // test default values for the various footer items for slippage
            const maxSlippageText = findChild(controlUnderTest, "maxSlippageText")
            verify(!!maxSlippageText)
            compare(maxSlippageText.text, qsTr("Max slippage:"))

            const maxSlippageValue = findChild(controlUnderTest, "maxSlippageValue")
            verify(!!maxSlippageValue)

            const editSlippageButton = findChild(controlUnderTest, "editSlippageButton")
            verify(!!editSlippageButton)

            const editSlippagePanel = findChild(controlUnderTest, "editSlippagePanel")
            verify(!!editSlippagePanel)
            verify(!editSlippagePanel.visible)

            // set swap proposal to ready and check state of the edit slippage buttons and max slippage values
            root.swapAdaptor.validSwapProposalReceived = true
            compare(maxSlippageValue.text, "%1%".arg(0.5))
            verify(editSlippageButton.visible)

            // clicking on editSlippageButton should show the edit slippage panel
            mouseClick(editSlippageButton)
            verify(!editSlippageButton.visible)
            verify(editSlippagePanel.visible)

            const slippageSelector = findChild(editSlippagePanel, "slippageSelector")
            verify(!!slippageSelector)

            verify(slippageSelector.valid)
            compare(slippageSelector.value, 0.5)

            const buttonsRepeater = findChild(slippageSelector, "buttonsRepeater")
            verify(!!buttonsRepeater)
            waitForRendering(buttonsRepeater)

            for(let i =0; i< buttonsRepeater.count; i++) {
                let buttonUnderTest = buttonsRepeater.itemAt(i)
                verify(!!buttonUnderTest)

                // the mouseClick(buttonUnderTest) doesnt seem to work
                buttonUnderTest.clicked()

                verify(slippageSelector.valid)
                compare(slippageSelector.value, buttonUnderTest.value)

                compare(maxSlippageValue.text, "%1%".arg(buttonUnderTest.value))
            }

            const signButton = findChild(controlUnderTest, "signButton")
            verify(!!signButton)
            verify(signButton.enabled)
        }

        function test_modal_swap_proposal_setup() {
            skip("Flaky test relying on wait()")
            root.swapAdaptor.reset()

            // Launch popup
            launchAndVerfyModal()

            waitForItemPolished(controlUnderTest.contentItem)

            const maxFeesText = findChild(controlUnderTest, "maxFeesText")
            verify(!!maxFeesText)

            const maxFeesValue = findChild(controlUnderTest, "maxFeesValue")
            verify(!!maxFeesValue)

            const signButton = findChild(controlUnderTest, "signButton")
            verify(!!signButton)

            const errorTag = findChild(controlUnderTest, "errorTag")
            verify(!!errorTag)

            const payPanel = findChild(controlUnderTest, "payPanel")
            verify(!!payPanel)

            const receivePanel = findChild(controlUnderTest, "receivePanel")
            verify(!!receivePanel)

            // Check max fees values and sign button state when nothing is set
            compare(maxFeesText.text, qsTr("Max fees:"))
            compare(maxFeesValue.text, "--")
            verify(!signButton.enabled)
            verify(!errorTag.visible)

            // set input values in the form correctly
            root.swapFormData.fromTokensKey = root.swapAdaptor.walletAssetsStore.walletTokensStore.plainTokensBySymbolModel.get(0).key
            formValuesChanged.wait()
            root.swapFormData.toTokenKey = root.swapAdaptor.walletAssetsStore.walletTokensStore.plainTokensBySymbolModel.get(1).key
            root.swapFormData.fromTokenAmount = "0.001"
            waitForRendering(receivePanel)
            formValuesChanged.wait()
            root.swapFormData.selectedNetworkChainId = root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId
            formValuesChanged.wait()
            root.swapFormData.selectedAccountAddress = root.swapAdaptor.nonWatchAccounts.get(0).address
            formValuesChanged.wait()

            // wait for fetchSuggestedRoutes function to be called
            fetchSuggestedRoutesCalled.wait()

            // verify loading state was set and no errors currently
            verifyLoadingAndNoErrorsState(payPanel, receivePanel)

            // emit event that no routes were found
            root.swapStore.suggestedRoutesReady(root.dummySwapTransactionRoutes.txNoRoutes)

            // verify loading state was removed and that error was displayed
            verify(!root.swapAdaptor.validSwapProposalReceived)
            verify(!root.swapAdaptor.swapProposalLoading)
            compare(root.swapAdaptor.swapOutputData.fromTokenAmount, "")
            compare(root.swapAdaptor.swapOutputData.toTokenAmount, "")
            compare(root.swapAdaptor.swapOutputData.totalFees, 0)
            compare(root.swapAdaptor.swapOutputData.approvalNeeded, false)
            compare(root.swapAdaptor.swapOutputData.hasError, true)
            verify(errorTag.visible)
            verify(errorTag.text, qsTr("An error has occured, please try again"))
            verify(!signButton.enabled)
            compare(signButton.text, qsTr("Swap"))

            // verfy input and output panels
            verify(!payPanel.mainInputLoading)
            verify(!payPanel.bottomTextLoading)
            verify(!receivePanel.mainInputLoading)
            verify(!receivePanel.bottomTextLoading)
            verify(!receivePanel.interactive)
            compare(receivePanel.selectedHoldingId, root.swapFormData.toTokenKey)
            compare(receivePanel.value, 0)
            compare(receivePanel.rawValue, "0")

            // edit some params to retry swap
            root.swapFormData.fromTokenAmount = "0.00011"
            waitForRendering(receivePanel)
            formValuesChanged.wait()

            // wait for fetchSuggestedRoutes function to be called
            fetchSuggestedRoutesCalled.wait()

            // verify loading state was set and no errors currently
            verifyLoadingAndNoErrorsState(payPanel, receivePanel)

            // emit event with route that needs no approval
            let txRoutes = root.dummySwapTransactionRoutes.txHasRouteNoApproval
            root.swapStore.suggestedRoutesReady(txRoutes)

            // verify loading state removed and data is displayed as expected on the Modal
            verify(root.swapAdaptor.validSwapProposalReceived)
            verify(!root.swapAdaptor.swapProposalLoading)
            compare(root.swapAdaptor.swapOutputData.fromTokenAmount, "")
            compare(root.swapAdaptor.swapOutputData.toTokenAmount,
                    SQUtils.AmountsArithmetic.div(
                        SQUtils.AmountsArithmetic.fromString(txRoutes.amountToReceive),
                        SQUtils.AmountsArithmetic.fromNumber(1, root.swapAdaptor.toToken.decimals)
                        ).toString())

            // calculation needed for total fees
            let gasTimeEstimate = txRoutes.gasTimeEstimate
            let totalTokenFeesInFiat = gasTimeEstimate.totalTokenFees * root.swapAdaptor.fromToken.marketDetails.currencyPrice.amount
            let totalFees = root.swapAdaptor.currencyStore.getFiatValue(gasTimeEstimate.totalFeesInEth, Constants.ethToken) + totalTokenFeesInFiat

            compare(root.swapAdaptor.swapOutputData.totalFees, totalFees)
            compare(root.swapAdaptor.swapOutputData.approvalNeeded, false)
            compare(root.swapAdaptor.swapOutputData.hasError, false)
            verify(!errorTag.visible)
            verify(signButton.enabled)
            compare(signButton.text, qsTr("Swap"))

            // verfy input and output panels
            waitForRendering(receivePanel)
            verify(payPanel.valueValid)
            verify(!receivePanel.mainInputLoading)
            verify(!receivePanel.bottomTextLoading)
            verify(!receivePanel.interactive)
            compare(receivePanel.selectedHoldingId, root.swapFormData.toTokenKey)
            compare(receivePanel.value, root.swapStore.getWei2Eth(txRoutes.amountToReceive, root.swapAdaptor.toToken.decimals))
            compare(receivePanel.rawValue, SQUtils.AmountsArithmetic.fromNumber(
                        LocaleUtils.numberFromLocaleString(root.swapAdaptor.swapOutputData.toTokenAmount, Qt.locale()),
                        root.swapAdaptor.toToken.decimals).toString())

            // edit some params to retry swap
            root.swapFormData.fromTokenAmount = "0.012"
            waitForRendering(receivePanel)
            formValuesChanged.wait()

            // wait for fetchSuggestedRoutes function to be called
            fetchSuggestedRoutesCalled.wait()

            // verify loading state was set and no errors currently
            verifyLoadingAndNoErrorsState(payPanel, receivePanel)

            // emit event with route that needs no approval
            let txRoutes2 = root.dummySwapTransactionRoutes.txHasRoutesApprovalNeeded
            root.swapStore.suggestedRoutesReady(txRoutes2)

            // verify loading state removed and data ius displayed as expected on the Modal
            verify(root.swapAdaptor.validSwapProposalReceived)
            verify(!root.swapAdaptor.swapProposalLoading)
            compare(root.swapAdaptor.swapOutputData.fromTokenAmount, "")
            compare(root.swapAdaptor.swapOutputData.toTokenAmount, SQUtils.AmountsArithmetic.div(
                        SQUtils.AmountsArithmetic.fromString(txRoutes.amountToReceive),
                        SQUtils.AmountsArithmetic.fromNumber(1, root.swapAdaptor.toToken.decimals)).toString())

            // calculation needed for total fees
            gasTimeEstimate = txRoutes2.gasTimeEstimate
            totalTokenFeesInFiat = gasTimeEstimate.totalTokenFees * root.swapAdaptor.fromToken.marketDetails.currencyPrice.amount
            totalFees = root.swapAdaptor.currencyStore.getFiatValue(gasTimeEstimate.totalFeesInEth, Constants.ethToken) + totalTokenFeesInFiat

            compare(root.swapAdaptor.swapOutputData.totalFees, totalFees)
            compare(root.swapAdaptor.swapOutputData.approvalNeeded, true)
            compare(root.swapAdaptor.swapOutputData.hasError, false)
            verify(!errorTag.visible)
            verify(signButton.enabled)
            compare(signButton.text, qsTr("Approve %1").arg(root.swapAdaptor.fromToken.symbol))

            // verfy input and output panels
            waitForRendering(receivePanel)
            verify(payPanel.valueValid)
            verify(!receivePanel.mainInputLoading)
            verify(!receivePanel.bottomTextLoading)
            verify(!receivePanel.interactive)
            compare(receivePanel.selectedHoldingId, root.swapFormData.toTokenKey)
            compare(receivePanel.value, root.swapStore.getWei2Eth(txRoutes.amountToReceive, root.swapAdaptor.toToken.decimals))
            compare(receivePanel.rawValue, SQUtils.AmountsArithmetic.fromNumber(
                        LocaleUtils.numberFromLocaleString(root.swapAdaptor.swapOutputData.toTokenAmount, Qt.locale()),
                        root.swapAdaptor.toToken.decimals).toString())
        }

        function test_modal_pay_input_default() {
            // Launch popup
            launchAndVerfyModal()

            const payPanel = findChild(controlUnderTest, "payPanel")
            verify(!!payPanel)
            const amountToSendInput = findChild(payPanel, "amountToSendInput")
            verify(!!amountToSendInput)
            const bottomItemText = findChild(payPanel, "bottomItemText")
            verify(!!bottomItemText)
            const holdingSelector = findChild(payPanel, "holdingSelector")
            verify(!!holdingSelector)
            const maxTagButton = findChild(payPanel, "maxTagButton")
            verify(!!maxTagButton)
            const tokenSelectorContentItemText = findChild(payPanel, "tokenSelectorContentItemText")
            verify(!!tokenSelectorContentItemText)

            waitForRendering(payPanel)

            // check default states for the from input selector
            compare(amountToSendInput.caption, qsTr("Pay"))
            verify(amountToSendInput.interactive)
            compare(amountToSendInput.input.text, "")
            verify(amountToSendInput.input.input.edit.cursorVisible)
            compare(amountToSendInput.input.placeholderText, LocaleUtils.numberToLocaleString(0))
            compare(bottomItemText.text, root.swapAdaptor.currencyStore.formatCurrencyAmount(0, root.swapAdaptor.currencyStore.currentCurrency))
            compare(holdingSelector.currentTokensKey, "")
            compare(tokenSelectorContentItemText.text, qsTr("Select asset"))
            verify(!maxTagButton.visible)
            compare(payPanel.selectedHoldingId, "")
            compare(payPanel.value, 0)
            compare(payPanel.rawValue, "0")
            verify(!payPanel.valueValid)

            closeAndVerfyModal()
        }

        function test_modal_pay_input_presetValues() {
            // try setting value before popup is launched and check values
            let valueToExchange = 0.001
            let valueToExchangeString = valueToExchange.toString()
            root.swapFormData.selectedAccountAddress = swapAdaptor.nonWatchAccounts.get(0).address
            root.swapFormData.selectedNetworkChainId = root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId
            root.swapFormData.fromTokensKey = "ETH"
            root.swapFormData.fromTokenAmount = valueToExchangeString

            let expectedToken = SQUtils.ModelUtils.getByKey(root.tokenSelectorAdaptor.outputAssetsModel, "tokensKey", "ETH")

            // Launch popup
            launchAndVerfyModal()

            waitForItemPolished(controlUnderTest.contentItem)

            const payPanel = findChild(controlUnderTest, "payPanel")
            verify(!!payPanel)
            waitForRendering(payPanel)
            const amountToSendInput = findChild(payPanel, "amountToSendInput")
            verify(!!amountToSendInput)
            const bottomItemText = findChild(payPanel, "bottomItemText")
            verify(!!bottomItemText)
            const holdingSelector = findChild(payPanel, "holdingSelector")
            verify(!!holdingSelector)
            const maxTagButton = findChild(payPanel, "maxTagButton")
            verify(!!maxTagButton)
            const tokenSelectorContentItemText = findChild(payPanel, "tokenSelectorContentItemText")
            verify(!!tokenSelectorContentItemText)
            const tokenSelectorIcon = findChild(payPanel, "tokenSelectorIcon")
            verify(!!tokenSelectorIcon)

            compare(amountToSendInput.caption, qsTr("Pay"))
            verify(amountToSendInput.interactive)
            tryCompare(amountToSendInput.input.input, "text", valueToExchangeString)
            compare(amountToSendInput.input.placeholderText, LocaleUtils.numberToLocaleString(0))
            tryCompare(amountToSendInput.input.input.edit, "cursorVisible", true)
            tryCompare(bottomItemText, "text", root.swapAdaptor.currencyStore.formatCurrencyAmount(valueToExchange * expectedToken.marketDetails.currencyPrice.amount, root.swapAdaptor.currencyStore.currentCurrency))
            compare(holdingSelector.currentTokensKey, expectedToken.tokensKey)
            tryCompare(tokenSelectorContentItemText, "text", expectedToken.symbol)
            compare(tokenSelectorIcon.image.source, Constants.tokenIcon(expectedToken.symbol))
            verify(tokenSelectorIcon.visible)
            verify(maxTagButton.visible)
            compare(maxTagButton.text, qsTr("Max. %1").arg(expectedToken.currentBalance === 0 ? "0"
                                                                                              : root.swapAdaptor.currencyStore.formatCurrencyAmount(WalletUtils.calculateMaxSafeSendAmount(expectedToken.currentBalance, expectedToken.symbol), expectedToken.symbol, {noSymbol: true})))
            compare(payPanel.selectedHoldingId, expectedToken.symbol)
            compare(payPanel.value, valueToExchange)
            compare(payPanel.rawValue, SQUtils.AmountsArithmetic.fromNumber(valueToExchangeString, expectedToken.decimals).toString())
            tryCompare(payPanel, "valueValid", expectedToken.currentBalance > 0)

            closeAndVerfyModal()
        }

        function test_modal_pay_input_wrong_value_1() {
            let invalidValues = ["ABC", "0.0.010201", "12PASA", "100,9.01"]
            for (let i =0; i<invalidValues.length; i++) {
                let invalidValue = invalidValues[i]
                // try setting value before popup is launched and check values
                root.swapFormData.selectedAccountAddress = swapAdaptor.nonWatchAccounts.get(0).address
                root.swapFormData.selectedNetworkChainId = root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId
                root.swapFormData.fromTokensKey =
                        root.swapFormData.fromTokenAmount = invalidValue

                // Launch popup
                launchAndVerfyModal()

                const payPanel = findChild(controlUnderTest, "payPanel")
                verify(!!payPanel)
                const amountToSendInput = findChild(payPanel, "amountToSendInput")
                verify(!!amountToSendInput)
                const bottomItemText = findChild(payPanel, "bottomItemText")
                verify(!!bottomItemText)
                const holdingSelector = findChild(payPanel, "holdingSelector")
                verify(!!holdingSelector)
                const maxTagButton = findChild(payPanel, "maxTagButton")
                verify(!!maxTagButton)
                const tokenSelectorContentItemText = findChild(payPanel, "tokenSelectorContentItemText")
                verify(!!tokenSelectorContentItemText)

                waitForRendering(payPanel)

                compare(amountToSendInput.caption, qsTr("Pay"))
                verify(amountToSendInput.interactive)
                compare(amountToSendInput.input.placeholderText, LocaleUtils.numberToLocaleString(0))
                verify(amountToSendInput.input.input.edit.cursorVisible)
                compare(bottomItemText.text, root.swapAdaptor.currencyStore.formatCurrencyAmount(0, root.swapAdaptor.currencyStore.currentCurrency))
                compare(holdingSelector.currentTokensKey, "")
                compare(tokenSelectorContentItemText.text, "Select asset")
                verify(!maxTagButton.visible)
                compare(payPanel.selectedHoldingId, "")
                compare(payPanel.value, 0)
                compare(payPanel.rawValue, SQUtils.AmountsArithmetic.fromNumber("0", 0).toString())
                verify(!payPanel.valueValid)

                closeAndVerfyModal()
            }
        }

        function test_modal_pay_input_wrong_value_2() {
            // try setting value before popup is launched and check values
            let valueToExchange = 100
            let valueToExchangeString = valueToExchange.toString()
            root.swapFormData.selectedAccountAddress = swapAdaptor.nonWatchAccounts.get(0).address
            root.swapFormData.selectedNetworkChainId = root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId
            root.swapFormData.fromTokensKey = "ETH"
            root.swapFormData.fromTokenAmount = valueToExchangeString

            let expectedToken =  SQUtils.ModelUtils.getByKey(root.tokenSelectorAdaptor.outputAssetsModel, "tokensKey", "ETH")

            // Launch popup
            launchAndVerfyModal()

            waitForItemPolished(controlUnderTest.contentItem)

            const payPanel = findChild(controlUnderTest, "payPanel")
            verify(!!payPanel)
            waitForRendering(payPanel)
            const amountToSendInput = findChild(payPanel, "amountToSendInput")
            verify(!!amountToSendInput)
            const bottomItemText = findChild(payPanel, "bottomItemText")
            verify(!!bottomItemText)
            const holdingSelector = findChild(payPanel, "holdingSelector")
            verify(!!holdingSelector)
            const maxTagButton = findChild(payPanel, "maxTagButton")
            verify(!!maxTagButton)
            const tokenSelectorContentItemText = findChild(payPanel, "tokenSelectorContentItemText")
            verify(!!tokenSelectorContentItemText)
            const tokenSelectorIcon = findChild(payPanel, "tokenSelectorIcon")
            verify(!!tokenSelectorIcon)

            compare(amountToSendInput.caption, qsTr("Pay"))
            verify(amountToSendInput.interactive)
            compare(amountToSendInput.input.text, valueToExchangeString)
            compare(amountToSendInput.input.placeholderText, LocaleUtils.numberToLocaleString(0))
            tryCompare(amountToSendInput.input.input.edit, "cursorVisible", true)
            tryCompare(bottomItemText, "text", root.swapAdaptor.currencyStore.formatCurrencyAmount(valueToExchange * expectedToken.marketDetails.currencyPrice.amount, root.swapAdaptor.currencyStore.currentCurrency))
            compare(holdingSelector.currentTokensKey, expectedToken.tokensKey)
            compare(tokenSelectorContentItemText.text, expectedToken.symbol)
            compare(tokenSelectorIcon.image.source, Constants.tokenIcon(expectedToken.symbol))
            verify(tokenSelectorIcon.visible)
            verify(maxTagButton.visible)
            compare(maxTagButton.text, qsTr("Max. %1").arg(expectedToken.currentBalance === 0 ? "0"
                                                                                              : root.swapAdaptor.currencyStore.formatCurrencyAmount(WalletUtils.calculateMaxSafeSendAmount(expectedToken.currentBalance, expectedToken.symbol), expectedToken.symbol, {noSymbol: true})))
            compare(payPanel.selectedHoldingId, expectedToken.symbol)
            compare(payPanel.value, valueToExchange)
            compare(payPanel.rawValue, SQUtils.AmountsArithmetic.fromNumber(valueToExchangeString, expectedToken.decimals).toString())
            verify(!payPanel.valueValid)

            closeAndVerfyModal()
        }

        function test_modal_receive_input_default() {
            // Launch popup
            launchAndVerfyModal()

            const receivePanel = findChild(controlUnderTest, "receivePanel")
            verify(!!receivePanel)
            const amountToSendInput = findChild(receivePanel, "amountToSendInput")
            verify(!!amountToSendInput)
            const bottomItemText = findChild(receivePanel, "bottomItemText")
            verify(!!bottomItemText)
            const holdingSelector = findChild(receivePanel, "holdingSelector")
            verify(!!holdingSelector)
            const maxTagButton = findChild(receivePanel, "maxTagButton")
            verify(!!maxTagButton)
            const tokenSelectorContentItemText = findChild(receivePanel, "tokenSelectorContentItemText")
            verify(!!tokenSelectorContentItemText)

            // check default states for the from input selector
            compare(amountToSendInput.caption, qsTr("Receive"))
            compare(amountToSendInput.input.text, "")
            // TODO: this should be come interactive under https://github.com/status-im/status-desktop/issues/15095
            verify(!amountToSendInput.interactive)
            verify(!amountToSendInput.input.input.edit.cursorVisible)
            compare(amountToSendInput.input.placeholderText, LocaleUtils.numberToLocaleString(0))
            compare(bottomItemText.text, root.swapAdaptor.currencyStore.formatCurrencyAmount(0, root.swapAdaptor.currencyStore.currentCurrency))
            compare(holdingSelector.currentTokensKey, "")
            compare(tokenSelectorContentItemText.text, qsTr("Select asset"))
            verify(!maxTagButton.visible)
            compare(receivePanel.selectedHoldingId, "")
            compare(receivePanel.value, 0)
            compare(receivePanel.rawValue, "0")
            verify(!receivePanel.valueValid)

            closeAndVerfyModal()
        }

        function test_modal_receive_input_presetValues() {
            let valueToReceive = 0.001
            let valueToReceiveString = valueToReceive.toString()
            // try setting value before popup is launched and check values
            root.swapFormData.selectedAccountAddress = swapAdaptor.nonWatchAccounts.get(0).address
            root.swapFormData.selectedNetworkChainId = root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId
            root.swapFormData.toTokenKey = "STT"
            root.swapFormData.toTokenAmount = valueToReceiveString

            let expectedToken = SQUtils.ModelUtils.getByKey(root.tokenSelectorAdaptor.outputAssetsModel, "tokensKey", "STT")

            // Launch popup
            launchAndVerfyModal()

            waitForItemPolished(controlUnderTest.contentItem)

            const receivePanel = findChild(controlUnderTest, "receivePanel")
            verify(!!receivePanel)
            waitForRendering(receivePanel)
            const amountToSendInput = findChild(receivePanel, "amountToSendInput")
            verify(!!amountToSendInput)
            const bottomItemText = findChild(receivePanel, "bottomItemText")
            verify(!!bottomItemText)
            const holdingSelector = findChild(receivePanel, "holdingSelector")
            verify(!!holdingSelector)
            const maxTagButton = findChild(receivePanel, "maxTagButton")
            verify(!!maxTagButton)
            const tokenSelectorContentItemText = findChild(receivePanel, "tokenSelectorContentItemText")
            verify(!!tokenSelectorContentItemText)
            const tokenSelectorIcon = findChild(receivePanel, "tokenSelectorIcon")
            verify(!!tokenSelectorIcon)

            compare(amountToSendInput.caption, qsTr("Receive"))
            // TODO: this should be come interactive under https://github.com/status-im/status-desktop/issues/15095
            verify(!amountToSendInput.interactive)
            verify(!amountToSendInput.input.input.edit.cursorVisible)
            compare(amountToSendInput.input.text, valueToReceive.toLocaleString(Qt.locale(), 'f', -128))
            compare(amountToSendInput.input.placeholderText, LocaleUtils.numberToLocaleString(0))
            tryCompare(bottomItemText, "text", root.swapAdaptor.currencyStore.formatCurrencyAmount(valueToReceive * expectedToken.marketDetails.currencyPrice.amount, root.swapAdaptor.currencyStore.currentCurrency))
            compare(holdingSelector.currentTokensKey, expectedToken.tokensKey)
            compare(tokenSelectorContentItemText.text, expectedToken.symbol)
            compare(tokenSelectorIcon.image.source, Constants.tokenIcon(expectedToken.symbol))
            verify(tokenSelectorIcon.visible)
            verify(!maxTagButton.visible)
            compare(receivePanel.selectedHoldingId, expectedToken.symbol)
            compare(receivePanel.value, valueToReceive)
            compare(receivePanel.rawValue, SQUtils.AmountsArithmetic.fromNumber(valueToReceiveString, expectedToken.decimals).toString())
            verify(receivePanel.valueValid)

            closeAndVerfyModal()
        }

        function test_modal_max_button_click_with_preset_pay_value() {
            // try setting value before popup is launched and check values
            let valueToExchange = 0.2
            let valueToExchangeString = valueToExchange.toString()
            root.swapFormData.selectedNetworkChainId = root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId
            // The default is the first account. Setting the second account to test switching accounts
            root.swapFormData.fromTokensKey = "ETH"
            root.swapFormData.fromTokenAmount = valueToExchangeString
            root.swapFormData.toTokenKey = "STT"

            formValuesChanged.wait()

            // Launch popup
            launchAndVerfyModal()
            // The default is the first account. Setting the second account to test switching accounts
            root.swapFormData.selectedAccountAddress = swapAdaptor.nonWatchAccounts.get(1).address

            waitForItemPolished(controlUnderTest.contentItem)

            const payPanel = findChild(controlUnderTest, "payPanel")
            verify(!!payPanel)
            const maxTagButton = findChild(payPanel, "maxTagButton")
            verify(!!maxTagButton)
            const amountToSendInput = findChild(payPanel, "amountToSendInput")
            verify(!!amountToSendInput)
            const bottomItemText = findChild(payPanel, "bottomItemText")
            verify(!!bottomItemText)

            let expectedToken =  SQUtils.ModelUtils.getByKey(root.tokenSelectorAdaptor.outputAssetsModel, "tokensKey", "ETH")

            // check states for the pay input selector
            verify(maxTagButton.visible)
            let maxPossibleValue = WalletUtils.calculateMaxSafeSendAmount(expectedToken.currentBalance, expectedToken.symbol)
            let truncmaxPossibleValue = Math.trunc(maxPossibleValue*100)/100
            compare(maxTagButton.text, qsTr("Max. %1").arg(truncmaxPossibleValue === 0 ? Qt.locale().zeroDigit
                                                                                       : root.swapAdaptor.currencyStore.formatCurrencyAmount(truncmaxPossibleValue, expectedToken.symbol, {noSymbol: true})))
            waitForItemPolished(amountToSendInput)
            verify(amountToSendInput.interactive)
            tryCompare(amountToSendInput.input.input.edit, "cursorVisible", true)
            tryCompare(amountToSendInput.input, "text", valueToExchange.toLocaleString(Qt.locale(), 'f', -128))
            compare(amountToSendInput.input.placeholderText, LocaleUtils.numberToLocaleString(0))
            tryCompare(bottomItemText, "text", root.swapAdaptor.currencyStore.formatCurrencyAmount(valueToExchange * expectedToken.marketDetails.currencyPrice.amount, root.swapAdaptor.currencyStore.currentCurrency))

            // click on max button
            mouseClick(maxTagButton)
            waitForItemPolished(payPanel)

            verify(amountToSendInput.interactive)
            verify(amountToSendInput.input.input.edit.cursorVisible)
            tryCompare(amountToSendInput.input, "text", maxPossibleValue === 0 ? "" : maxPossibleValue.toLocaleString(Qt.locale(), 'f', -128))
            tryCompare(bottomItemText, "text", root.swapAdaptor.currencyStore.formatCurrencyAmount(maxPossibleValue * expectedToken.marketDetails.currencyPrice.amount, root.swapAdaptor.currencyStore.currentCurrency))

            closeAndVerfyModal()
        }

        function test_modal_max_button_click_with_no_preset_pay_value() {
            // Launch popup
            launchAndVerfyModal()
            // The default is the first account. Setting the second account to test switching accounts
            root.swapFormData.selectedAccountAddress = swapAdaptor.nonWatchAccounts.get(1).address
            formValuesChanged.clear()
            
            // try setting value before popup is launched and check values
            root.swapFormData.selectedNetworkChainId = root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId
            root.swapFormData.selectedAccountAddress = swapAdaptor.nonWatchAccounts.get(0).address
            root.swapFormData.fromTokensKey = "ETH"
            root.swapFormData.toTokenKey = "STT"

            formValuesChanged.wait()

            const payPanel = findChild(controlUnderTest, "payPanel")
            verify(!!payPanel)
            const maxTagButton = findChild(payPanel, "maxTagButton")
            verify(!!maxTagButton)
            const amountToSendInput = findChild(payPanel, "amountToSendInput")
            verify(!!amountToSendInput)
            const bottomItemText = findChild(payPanel, "bottomItemText")
            verify(!!bottomItemText)

            waitForRendering(payPanel)

            let expectedToken =  SQUtils.ModelUtils.getByKey(root.tokenSelectorAdaptor.outputAssetsModel, "tokensKey", "ETH")

            // check states for the pay input selector
            verify(maxTagButton.visible)
            let maxPossibleValue = WalletUtils.calculateMaxSafeSendAmount(expectedToken.currentBalance, expectedToken.symbol)
            compare(maxTagButton.text, qsTr("Max. %1").arg(maxPossibleValue === 0 ? "0"
                                                                                  : root.swapAdaptor.currencyStore.formatCurrencyAmount(maxPossibleValue, expectedToken.symbol, {noSymbol: true})))
            verify(amountToSendInput.interactive)
            verify(amountToSendInput.input.input.edit.cursorVisible)
            compare(amountToSendInput.input.text, "")
            compare(amountToSendInput.input.placeholderText, LocaleUtils.numberToLocaleString(0))
            compare(bottomItemText.text, root.swapAdaptor.currencyStore.formatCurrencyAmount(0, root.swapAdaptor.currencyStore.currentCurrency))

            // click on max button
            maxTagButton.clicked()
            waitForItemPolished(payPanel)

            formValuesChanged.wait()

            verify(amountToSendInput.interactive)
            verify(amountToSendInput.input.input.edit.cursorVisible)
            compare(amountToSendInput.input.text, maxPossibleValue > 0 ? maxPossibleValue.toLocaleString(Qt.locale(), 'f', -128) : "")
            tryCompare(bottomItemText, "text", root.swapAdaptor.currencyStore.formatCurrencyAmount(maxPossibleValue * expectedToken.marketDetails.currencyPrice.amount, root.swapAdaptor.currencyStore.currentCurrency))

            closeAndVerfyModal()
        }

        function test_modal_pay_input_switching_accounts() {
            skip("flaky test")
            // test with pay value being set and not set
            let payValuesToTestWith = ["", "0.2"]

            for (let index = 0; index < payValuesToTestWith.length; index++) {
                let valueToExchangeString = payValuesToTestWith[index]
                let valueToExchange = Number(valueToExchangeString)

                // Asset chosen but no pay value set state -------------------------------------------------------------------------------
                root.swapFormData.fromTokenAmount = valueToExchangeString
                root.swapFormData.selectedAccountAddress = swapAdaptor.nonWatchAccounts.get(0).address
                root.swapFormData.selectedNetworkChainId = root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId
                root.swapFormData.fromTokensKey = "ETH"

                // Launch popup
                launchAndVerfyModal()

                const payPanel = findChild(controlUnderTest, "payPanel")
                verify(!!payPanel)
                const maxTagButton = findChild(payPanel, "maxTagButton")
                verify(!!maxTagButton)
                const amountToSendInput = findChild(payPanel, "amountToSendInput")
                verify(!!amountToSendInput)

                const errorTag = findChild(controlUnderTest, "errorTag")
                verify(!!errorTag)

                for (let i=0; i< root.swapAdaptor.nonWatchAccounts.count; i++) {
                    root.swapFormData.selectedAccountAddress = root.swapAdaptor.nonWatchAccounts.get(i).address

                    waitForItemPolished(controlUnderTest.contentItem)

                    let expectedToken = SQUtils.ModelUtils.getByKey(root.tokenSelectorAdaptor.outputAssetsModel, "tokensKey", "ETH")

                    // check states for the pay input selector
                    tryCompare(maxTagButton, "visible", true)
                    let maxPossibleValue = WalletUtils.calculateMaxSafeSendAmount(expectedToken.currentBalance, expectedToken.symbol)
                    tryCompare(maxTagButton, "text", qsTr("Max. %1").arg(maxPossibleValue === 0 ? Qt.locale().zeroDigit : root.swapAdaptor.currencyStore.formatCurrencyAmount(maxPossibleValue, expectedToken.symbol, {noSymbol: true})))
                    compare(payPanel.selectedHoldingId, expectedToken.symbol)
                    tryCompare(payPanel, "valueValid", !!valueToExchangeString && valueToExchange <= maxPossibleValue)

                    tryCompare(payPanel, "value", valueToExchange)
                    compare(payPanel.rawValue, !!valueToExchangeString ? SQUtils.AmountsArithmetic.fromNumber(valueToExchangeString, expectedToken.decimals).toString(): "0")

                    // check if tag is visible in case amount entered to exchange is greater than max balance to send
                    let amountEnteredGreaterThanMaxBalance = valueToExchange > maxPossibleValue
                    let errortext = amountEnteredGreaterThanMaxBalance ? qsTr("Insufficient funds for swap"): qsTr("An error has occured, please try again")
                    compare(errorTag.visible, amountEnteredGreaterThanMaxBalance)
                    compare(errorTag.text, errortext)
                    compare(errorTag.buttonText, qsTr("Buy crypto"))
                    compare(errorTag.buttonVisible, amountEnteredGreaterThanMaxBalance)
                }

                closeAndVerfyModal()
            }
        }

        function test_modal_exchange_button_default_state_data() {
            return [
                        {fromToken: "", fromTokenAmount: "", toToken: "", toTokenAmount: ""},
                        {fromToken: "", fromTokenAmount: "", toToken: "STT", toTokenAmount: ""},
                        {fromToken: "ETH", fromTokenAmount: "", toToken: "", toTokenAmount: ""},
                        {fromToken: "ETH", fromTokenAmount: "", toToken: "STT", toTokenAmount: ""},
                        {fromToken: "ETH", fromTokenAmount: "100", toToken: "STT", toTokenAmount: ""},
                        {fromToken: "ETH", fromTokenAmount: "", toToken: "STT", toTokenAmount: "50"},
                        {fromToken: "ETH", fromTokenAmount: "100", toToken: "STT", toTokenAmount: "50"},
                        {fromToken: "", fromTokenAmount: "", toToken: "", toTokenAmount: "50"},
                        {fromToken: "", fromTokenAmount: "100", toToken: "", toTokenAmount: ""}
                    ]
        }

        function test_modal_exchange_button_default_state(data) {
            const payPanel = findChild(controlUnderTest, "payPanel")
            verify(!!payPanel)
            const receivePanel = findChild(controlUnderTest, "receivePanel")
            verify(!!receivePanel)
            const swapExchangeButton = findChild(controlUnderTest, "swapExchangeButton")
            verify(!!swapExchangeButton)

            const payAmountToSendInput = findChild(payPanel, "amountToSendInput")
            verify(!!payAmountToSendInput)
            const payBottomItemText = findChild(payPanel, "bottomItemText")
            verify(!!payBottomItemText)
            const maxTagButton = findChild(payPanel, "maxTagButton")
            verify(!!maxTagButton)

            const receiveAmountToSendInput = findChild(receivePanel, "amountToSendInput")
            verify(!!receiveAmountToSendInput)
            const receiveBottomItemText = findChild(receivePanel, "bottomItemText")
            verify(!!receiveBottomItemText)

            root.swapAdaptor.reset()

            // set network and address by default same
            root.swapFormData.selectedNetworkChainId = root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId
            root.swapFormData.selectedAccountAddress = root.swapAdaptor.nonWatchAccounts.get(0).address
            root.swapFormData.fromTokensKey = data.fromToken
            root.swapFormData.fromTokenAmount = data.fromTokenAmount
            root.swapFormData.toTokenKey = data.toToken
            root.swapFormData.toTokenAmount = data.toTokenAmount

            let expectedFromTokenIcon = !!root.swapAdaptor.fromToken && !!root.swapAdaptor.fromToken.symbol ?
                    Constants.tokenIcon(root.swapAdaptor.fromToken.symbol): ""
            let expectedToTokenIcon = !!root.swapAdaptor.toToken && !!root.swapAdaptor.toToken.symbol ?
                    Constants.tokenIcon(root.swapAdaptor.toToken.symbol): ""

            // Launch popup
            launchAndVerfyModal()
            waitForRendering(payPanel)
            waitForRendering(receivePanel)

            let paytokenSelectorContentItemText = findChild(payPanel, "tokenSelectorContentItemText")
            verify(!!paytokenSelectorContentItemText)
            let paytokenSelectorIcon = findChild(payPanel, "tokenSelectorIcon")
            compare(!!data.fromToken , !!paytokenSelectorIcon)
            let receivetokenSelectorContentItemText = findChild(receivePanel, "tokenSelectorContentItemText")
            verify(!!receivetokenSelectorContentItemText)
            let receivetokenSelectorIcon = findChild(receivePanel, "tokenSelectorIcon")
            compare(!!data.toToken, !!receivetokenSelectorIcon)

            // verify pay values
            compare(payPanel.tokenKey, data.fromToken)
            compare(payPanel.tokenAmount, data.fromTokenAmount)
            verify(payAmountToSendInput.input.input.edit.cursorVisible)
            compare(paytokenSelectorContentItemText.text, !!root.swapFormData.fromTokensKey ? root.swapFormData.fromTokensKey : qsTr("Select asset"))
            compare(!!data.fromToken , !!paytokenSelectorIcon)
            if(!!paytokenSelectorIcon) {
                compare(paytokenSelectorIcon.image.source, expectedFromTokenIcon)
            }
            verify(!!data.fromToken ? maxTagButton.visible: !maxTagButton.visible)

            // verify receive values
            compare(receivePanel.tokenKey, data.toToken)
            compare(receivePanel.tokenAmount, data.toTokenAmount)
            verify(!receiveAmountToSendInput.input.input.edit.cursorVisible)
            compare(receivetokenSelectorContentItemText.text, !!root.swapFormData.toTokenKey ? root.swapFormData.toTokenKey : qsTr("Select asset"))
            if(!!receivetokenSelectorIcon) {
                compare(receivetokenSelectorIcon.image.source, expectedToTokenIcon)
            }

            // click exchange button
            swapExchangeButton.clicked()
            waitForRendering(payPanel)
            waitForRendering(receivePanel)

            // verify form values
            compare(root.swapFormData.fromTokensKey, data.toToken)
            compare(root.swapFormData.fromTokenAmount, data.toTokenAmount)
            compare(root.swapFormData.toTokenKey, data.fromToken)
            compare(root.swapFormData.toTokenAmount, data.fromTokenAmount)

            paytokenSelectorContentItemText = findChild(payPanel, "tokenSelectorContentItemText")
            verify(!!paytokenSelectorContentItemText)
            paytokenSelectorIcon = findChild(payPanel, "tokenSelectorIcon")
            compare(!!root.swapFormData.fromTokensKey , !!paytokenSelectorIcon)
            receivetokenSelectorContentItemText = findChild(receivePanel, "tokenSelectorContentItemText")
            verify(!!receivetokenSelectorContentItemText)
            receivetokenSelectorIcon = findChild(receivePanel, "tokenSelectorIcon")
            compare(!!root.swapFormData.toTokenKey, !!receivetokenSelectorIcon)

            // verify pay values
            compare(payPanel.tokenKey, data.toToken)
            compare(payPanel.tokenAmount, data.toTokenAmount)
            verify(payAmountToSendInput.input.input.edit.cursorVisible)
            compare(paytokenSelectorContentItemText.text, !!data.toToken ? data.toToken : qsTr("Select asset"))
            if(!!paytokenSelectorIcon) {
                compare(paytokenSelectorIcon.image.source, expectedToTokenIcon)
            }
            verify(!!data.toToken ? maxTagButton.visible: !maxTagButton.visible)
            compare(maxTagButton.text, qsTr("Max. %1").arg(Qt.locale().zeroDigit))
            compare(maxTagButton.type, (payAmountToSendInput.input.valid || !payAmountToSendInput.input.text) && maxTagButton.value > 0 ? StatusBaseButton.Type.Normal : StatusBaseButton.Type.Danger)

            // verify receive values
            compare(receivePanel.tokenKey, data.fromToken)
            compare(receivePanel.tokenAmount, data.fromTokenAmount)
            verify(!receiveAmountToSendInput.input.input.edit.cursorVisible)
            compare(receivetokenSelectorContentItemText.text, !!data.fromToken ? data.fromToken : qsTr("Select asset"))
            if(!!receivetokenSelectorIcon) {
                compare(receivetokenSelectorIcon.image.source, expectedFromTokenIcon)
            }

            closeAndVerfyModal()
        }

        function test_approval_flow_button_states() {
            root.swapAdaptor.reset()

            // Launch popup
            launchAndVerfyModal()

            const maxFeesValue = findChild(controlUnderTest, "maxFeesValue")
            verify(!!maxFeesValue)
            const signButton = findChild(controlUnderTest, "signButton")
            verify(!!signButton)
            const errorTag = findChild(controlUnderTest, "errorTag")
            verify(!!errorTag)
            const payPanel = findChild(controlUnderTest, "payPanel")
            verify(!!payPanel)
            const receivePanel = findChild(controlUnderTest, "receivePanel")
            verify(!!receivePanel)

            // Check max fees values and sign button state when nothing is set
            compare(maxFeesValue.text, "--")
            verify(!signButton.enabled)
            verify(!errorTag.visible)

            // set input values in the form correctly
            root.swapFormData.fromTokensKey = root.swapAdaptor.walletAssetsStore.walletTokensStore.plainTokensBySymbolModel.get(0).key
            formValuesChanged.wait()
            root.swapFormData.toTokenKey = root.swapAdaptor.walletAssetsStore.walletTokensStore.plainTokensBySymbolModel.get(1).key
            root.swapFormData.fromTokenAmount = "0.001"
            formValuesChanged.wait()
            root.swapFormData.selectedNetworkChainId = root.swapAdaptor.filteredFlatNetworksModel.get(0).chainId
            formValuesChanged.wait()
            root.swapFormData.selectedAccountAddress = "0x7F47C2e18a4BBf5487E6fb082eC2D9Ab0E6d7240"
            formValuesChanged.wait()

            // wait for fetchSuggestedRoutes function to be called
            fetchSuggestedRoutesCalled.wait()

            // verify loading state was set and no errors currently
            verifyLoadingAndNoErrorsState(payPanel, receivePanel)

            // emit event with route that needs no approval
            let txRoutes = root.dummySwapTransactionRoutes.txHasRoutesApprovalNeeded
            txRoutes.uuid = root.swapAdaptor.uuid
            root.swapStore.suggestedRoutesReady(txRoutes)

            // calculation needed for total fees
            let gasTimeEstimate = txRoutes.gasTimeEstimate
            let totalTokenFeesInFiat = gasTimeEstimate.totalTokenFees * root.swapAdaptor.fromToken.marketDetails.currencyPrice.amount
            let totalFees = root.swapAdaptor.currencyStore.getFiatValue(gasTimeEstimate.totalFeesInEth, Constants.ethToken) + totalTokenFeesInFiat
            let bestPath = SQUtils.ModelUtils.get(txRoutes.suggestedRoutes, 0, "route")

            // verify loading state removed and data is displayed as expected on the Modal
            verify(root.swapAdaptor.validSwapProposalReceived)
            verify(!root.swapAdaptor.swapProposalLoading)
            compare(root.swapAdaptor.swapOutputData.fromTokenAmount, "")
            compare(root.swapAdaptor.swapOutputData.toTokenAmount, SQUtils.AmountsArithmetic.div(
                        SQUtils.AmountsArithmetic.fromString(txRoutes.amountToReceive),
                        SQUtils.AmountsArithmetic.fromNumber(1, root.swapAdaptor.toToken.decimals)).toString())
            compare(root.swapAdaptor.swapOutputData.totalFees, totalFees)
            compare(root.swapAdaptor.swapOutputData.hasError, false)
            compare(root.swapAdaptor.swapOutputData.estimatedTime, bestPath.estimatedTime)
            compare(root.swapAdaptor.swapOutputData.txProviderName, bestPath.bridgeName)
            compare(root.swapAdaptor.swapOutputData.approvalNeeded, true)
            compare(root.swapAdaptor.swapOutputData.approvalGasFees, bestPath.approvalGasFees.toString())
            compare(root.swapAdaptor.swapOutputData.approvalAmountRequired, bestPath.approvalAmountRequired)
            compare(root.swapAdaptor.swapOutputData.approvalContractAddress, bestPath.approvalContractAddress)

            verify(!errorTag.visible)
            verify(signButton.enabled)
            verify(!signButton.loading)
            compare(signButton.text, qsTr("Approve %1").arg(root.swapAdaptor.fromToken.symbol))
            // TODO: note that there is a loss of precision as the approvalGasFees is currently passes as float from the backend and not string.
            compare(maxFeesValue.text, root.swapAdaptor.currencyStore.formatCurrencyAmount(
                        root.swapAdaptor.swapOutputData.totalFees,
                        root.swapAdaptor.currencyStore.currentCurrency))

            // simulate user click on approve button and approval failed
            root.swapStore.transactionSent(root.swapFormData.selectedNetworkChainId, "0x877ffe47fc29340312611d4e833ab189fe4f4152b01cc9a05bb4125b81b2a89a", root.swapAdaptor.uuid, "")

            verify(root.swapAdaptor.approvalPending)
            verify(!root.swapAdaptor.approvalSuccessful)
            verify(!errorTag.visible)
            verify(!signButton.enabled)
            verify(signButton.loading)
            compare(signButton.text, qsTr("Approving %1").arg(root.swapAdaptor.fromToken.symbol))
            // TODO: note that there is a loss of precision as the approvalGasFees is currently passes as float from the backend and not string.
            compare(maxFeesValue.text, root.swapAdaptor.currencyStore.formatCurrencyAmount(
                        root.swapAdaptor.swapOutputData.totalFees,
                        root.swapAdaptor.currencyStore.currentCurrency))

            // simulate approval tx was unsuccessful
            root.swapStore.transactionSendingComplete("0x877ffe47fc29340312611d4e833ab189fe4f4152b01cc9a05bb4125b81b2a89a", false)

            verify(!root.swapAdaptor.approvalPending)
            verify(!root.swapAdaptor.approvalSuccessful)
            verify(!errorTag.visible)
            verify(signButton.enabled)
            verify(!signButton.loading)
            compare(signButton.text, qsTr("Approve %1").arg(root.swapAdaptor.fromToken.symbol))
            // TODO: note that there is a loss of precision as the approvalGasFees is currently passes as float from the backend and not string.
            compare(maxFeesValue.text, root.swapAdaptor.currencyStore.formatCurrencyAmount(
                        root.swapAdaptor.swapOutputData.totalFees,
                        root.swapAdaptor.currencyStore.currentCurrency))

            // simulate user click on approve button and successful approval tx made
            signButton.clicked()
            root.swapStore.transactionSent(root.swapFormData.selectedNetworkChainId, "0x877ffe47fc29340312611d4e833ab189fe4f4152b01cc9a05bb4125b81b2a89a", root.swapAdaptor.uuid, "")

            verify(root.swapAdaptor.approvalPending)
            verify(!root.swapAdaptor.approvalSuccessful)
            verify(!errorTag.visible)
            verify(!signButton.enabled)
            verify(signButton.loading)
            compare(signButton.text, qsTr("Approving %1").arg(root.swapAdaptor.fromToken.symbol))
            // TODO: note that there is a loss of precision as the approvalGasFees is currently passes as float from the backend and not string.
            compare(maxFeesValue.text, root.swapAdaptor.currencyStore.formatCurrencyAmount(
                        root.swapAdaptor.swapOutputData.totalFees,
                        root.swapAdaptor.currencyStore.currentCurrency))

            // simulate approval tx was successful
            signButton.clicked()
            root.swapStore.transactionSendingComplete("0x877ffe47fc29340312611d4e833ab189fe4f4152b01cc9a05bb4125b81b2a89a", true)

            // check if fetchSuggestedRoutes called
            fetchSuggestedRoutesCalled.wait()

            // verify loading state was set and no errors currently
            verifyLoadingAndNoErrorsState(payPanel, receivePanel)

            verify(!root.swapAdaptor.approvalPending)
            verify(!root.swapAdaptor.approvalSuccessful)
            verify(!errorTag.visible)
            verify(!signButton.enabled)
            verify(!signButton.loading)
            compare(signButton.text, qsTr("Swap"))
            compare(maxFeesValue.text,  Constants.dummyText)

            let txHasRouteNoApproval = root.dummySwapTransactionRoutes.txHasRouteNoApproval
            txHasRouteNoApproval.uuid = root.swapAdaptor.uuid
            root.swapStore.suggestedRoutesReady(txHasRouteNoApproval)

            verify(!root.swapAdaptor.approvalPending)
            verify(!root.swapAdaptor.approvalSuccessful)
            verify(!errorTag.visible)
            verify(signButton.enabled)
            verify(!signButton.loading)
            compare(signButton.text, qsTr("Swap"))
            compare(maxFeesValue.text, root.swapAdaptor.currencyStore.formatCurrencyAmount(
                        root.swapAdaptor.swapOutputData.totalFees,
                        root.swapAdaptor.currencyStore.currentCurrency))
            closeAndVerfyModal()
        }

        function test_modal_switching_networks_payPanel_data() {
            return [
                        {key: "ETH"},
                        {key: "aave"}
                    ]
        }

        function test_modal_switching_networks_payPanel(data) {
            // try setting value before popup is launched and check values
            let valueToExchange = 1
            let valueToExchangeString = valueToExchange.toString()
            root.swapFormData.selectedAccountAddress = "0x7F47C2e18a4BBf5487E6fb082eC2D9Ab0E6d7240"
            root.swapFormData.fromTokensKey = data.key
            root.swapFormData.fromTokenAmount = valueToExchangeString

            // Launch popup
            launchAndVerfyModal()

            const payPanel = findChild(controlUnderTest, "payPanel")
            verify(!!payPanel)
            const maxTagButton = findChild(payPanel, "maxTagButton")
            verify(!!maxTagButton)
            const networkComboBox = findChild(controlUnderTest, "networkFilter")
            verify(!!networkComboBox)
            const errorTag = findChild(controlUnderTest, "errorTag")
            verify(!!errorTag)

            for (let i=0; i<networkComboBox.control.popup.contentItem.count; i++) {
                // launch network selection popup
                verify(!networkComboBox.control.popup.opened)
                mouseClick(networkComboBox)
                verify(networkComboBox.control.popup.opened)

                let delegateUnderTest = networkComboBox.control.popup.contentItem.itemAtIndex(i)
                verify(!!delegateUnderTest)
                mouseClick(delegateUnderTest)

                waitForRendering(payPanel)

                const tokenSelectorContentItemText = findChild(payPanel, "tokenSelectorContentItemText")
                verify(!!tokenSelectorContentItemText)

                let fromTokenExistsOnNetwork = false
                let expectedToken = SQUtils.ModelUtils.getByKey(root.tokenSelectorAdaptor.plainTokensBySymbolModel, "key", root.swapFormData.fromTokensKey)
                if(!!expectedToken) {
                    fromTokenExistsOnNetwork = !!SQUtils.ModelUtils.getByKey(expectedToken.addressPerChain, "chainId",networkComboBox.selection[0], "address")
                }

                if (!fromTokenExistsOnNetwork) {
                    verify(!maxTagButton.visible)
                    compare(payPanel.selectedHoldingId, "")
                    verify(!payPanel.valueValid)
                    compare(payPanel.value, 0)
                    compare(payPanel.rawValue, "0")
                    verify(!errorTag.visible)
                    compare(tokenSelectorContentItemText.text, qsTr("Select asset"))
                } else {
                    // check states for the pay input selector
                    verify(maxTagButton.visible)
                    let balancesModel = SQUtils.ModelUtils.getByKey(root.tokenSelectorAdaptor.outputAssetsModel, "tokensKey", root.swapFormData.fromTokensKey, "balances")
                    let balanceEntry = SQUtils.ModelUtils.getFirstModelEntryIf(balancesModel, (balance) => {
                                                                                   return balance.account.toLowerCase() === root.swapFormData.selectedAccountAddress.toLowerCase() &&
                                                                                   balance.chainId === root.swapFormData.selectedNetworkChainId
                                                                               })
                    let balance =  SQUtils.AmountsArithmetic.toNumber(
                            SQUtils.AmountsArithmetic.fromString(balanceEntry.balance),
                            expectedToken.decimals)

                    let maxPossibleValue = WalletUtils.calculateMaxSafeSendAmount(balance, expectedToken.symbol)
                    compare(maxTagButton.text, qsTr("Max. %1").arg(
                                maxPossibleValue === 0 ? "0" :
                                                         root.swapAdaptor.currencyStore.formatCurrencyAmount(maxPossibleValue, expectedToken.symbol, {noSymbol: true})))
                    compare(payPanel.selectedHoldingId.toLowerCase(), expectedToken.symbol.toLowerCase())
                    compare(payPanel.valueValid, valueToExchange <= maxPossibleValue)
                    compare(payPanel.value, valueToExchange)
                    compare(payPanel.rawValue, SQUtils.AmountsArithmetic.fromNumber(valueToExchangeString, expectedToken.decimals).toString())
                    compare(errorTag.visible, valueToExchange > maxPossibleValue)
                    if(errorTag.visible)
                        compare(errorTag.text, qsTr("Insufficient funds for swap"))
                    compare(tokenSelectorContentItemText.text, expectedToken.symbol)
                }
            }

            closeAndVerfyModal()
        }

        function test_modal_switching_networks_receivePanel_data() {
                return [
                            {key: "aave"},
                            {key: "STT"}
                        ]
        }

        function test_modal_switching_networks_receivePanel(data) {
            // try setting value before popup is launched and check values
            let valueToExchange = 1
            let valueToExchangeString = valueToExchange.toString()
            root.swapFormData.selectedAccountAddress = "0x7F47C2e18a4BBf5487E6fb082eC2D9Ab0E6d7240"
            root.swapFormData.fromTokensKey = "ETH"
            root.swapFormData.fromTokenAmount = valueToExchangeString
            root.swapFormData.toTokenKey = data.key

            // Launch popup
            launchAndVerfyModal()

            const receivePanel = findChild(controlUnderTest, "receivePanel")
            verify(!!receivePanel)
            const networkComboBox = findChild(controlUnderTest, "networkFilter")
            verify(!!networkComboBox)

            for (let i=0; i<networkComboBox.control.popup.contentItem.count; i++) {
                // launch network selection popup
                verify(!networkComboBox.control.popup.opened)
                mouseClick(networkComboBox)
                verify(networkComboBox.control.popup.opened)

                let delegateUnderTest = networkComboBox.control.popup.contentItem.itemAtIndex(i)
                verify(!!delegateUnderTest)
                mouseClick(delegateUnderTest)

                waitForRendering(receivePanel)

                const tokenSelectorContentItemText = findChild(receivePanel, "tokenSelectorContentItemText")
                verify(!!tokenSelectorContentItemText)

                let fromTokenExistsOnNetwork = false
                let expectedToken = SQUtils.ModelUtils.getByKey(root.tokenSelectorAdaptor.plainTokensBySymbolModel, "key", root.swapFormData.toTokenKey)
                if(!!expectedToken) {
                    fromTokenExistsOnNetwork = !!SQUtils.ModelUtils.getByKey(expectedToken.addressPerChain, "chainId", networkComboBox.selection[0], "address")
                }

                if (!fromTokenExistsOnNetwork) {
                    compare(receivePanel.selectedHoldingId, "")
                    compare(tokenSelectorContentItemText.text, qsTr("Select asset"))
                } else {
                    compare(receivePanel.selectedHoldingId.toLowerCase(), expectedToken.symbol.toLowerCase())
                    compare(tokenSelectorContentItemText.text, expectedToken.symbol)
                }
            }

            closeAndVerfyModal()
        }

        function test_auto_refresh() {
            // Asset chosen but no pay value set state -------------------------------------------------------------------------------
            root.swapFormData.fromTokenAmount = "0.0001"
            root.swapFormData.selectedAccountAddress = "0x7F47C2e18a4BBf5487E6fb082eC2D9Ab0E6d7240"
            root.swapFormData.selectedNetworkChainId = 11155111
            root.swapFormData.fromTokensKey = "ETH"
            // for testing making it 1.5 seconds so as to not make tests running too long
            root.swapFormData.autoRefreshTime = 1500

            // Launch popup
            launchAndVerfyModal()

            // check if fetchSuggestedRoutes called
            fetchSuggestedRoutesCalled.wait()

            // emit routes ready
            let txHasRouteNoApproval = root.dummySwapTransactionRoutes.txHasRouteNoApproval
            txHasRouteNoApproval.uuid = root.swapAdaptor.uuid
            root.swapStore.suggestedRoutesReady(txHasRouteNoApproval)

            // check if fetch occurs automatically after 15 seconds
            fetchSuggestedRoutesCalled.wait()
        }

        function test_deleteing_input_characters_data() {
            return [
                        {input: "0.001"},
                        {input: "1.00015"},
                        /* TODO uncomment after https://discord.com/channels/@me/927512790296563712/1260937239140241408
                        {input: "100.000000000000151001"},
                        {input: "1.0200000000000151001"} */
                    ]
        }

        function test_deleteing_input_characters(data) {
            root.swapFormData.fromTokenAmount = data.input
            root.swapFormData.selectedAccountAddress = "0x7F47C2e18a4BBf5487E6fb082eC2D9Ab0E6d7240"
            root.swapFormData.selectedNetworkChainId = 11155111
            root.swapFormData.fromTokensKey = "ETH"

            const amountToSendInput = findChild(controlUnderTest, "amountToSendInput")
            verify(!!amountToSendInput)

            // Launch popup
            launchAndVerfyModal()

            waitForRendering(amountToSendInput)

            //TODO: should not be needed after https://github.com/status-im/status-desktop/issues/15417
            amountToSendInput.input.input.cursorPosition = data.input.length
            for(let i =0; i< data.input.length; i++) {
                keyClick(Qt.Key_Backspace)
                let expectedAmount = data.input.substring(0, data.input.length - (i+1))
                compare(amountToSendInput.input.text, expectedAmount)
            }
        }
    }
}
