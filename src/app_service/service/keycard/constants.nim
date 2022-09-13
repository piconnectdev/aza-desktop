const ErrorKey* = "error"
const ErrorOK* = "ok"
const ErrorCancel* = "cancel"
const ErrorConnection* = "connection-error"
const ErrorUnknownFlow* = "unknown-flow"
const ErrorNotAKeycard* = "not-a-keycard"
const ErrorNoKeys* = "no-keys"
const ErrorHasKeys* = "has-keys"
const ErrorRequireInit* = "require-init"
const ErrorPairing* = "pairing"
const ErrorUnblocking* = "unblocking"
const ErrorSigning* = "signing"
const ErrorExporting* = "exporting"
const ErrorChanging* = "changing-credentials"
const ErrorLoadingKeys* = "loading-keys"
const ErrorStoreMeta* = "storing-metadata"
const ErrorNoData* = "no-data"
const ErrorFreePairingSlots* = "free-pairing-slots"
const ErrorPIN* = "pin"

const RequestParamAppInfo* = "application-info"
const RequestParamInstanceUID* = "instance-uid"
const RequestParamFactoryReset* = "factory reset"
const RequestParamKeyUID* = "key-uid"
const RequestParamFreeSlots* = "free-pairing-slots"
const RequestParamPINRetries* = "pin-retries"
const RequestParamPUKRetries* = "puk-retries"
const RequestParamPairingPass* = "pairing-pass"
const RequestParamPaired* = "paired"
const RequestParamNewPairing* = "new-pairing-pass"
const RequestParamDefPairing* = "KeycardDefaultPairing"
const RequestParamPIN* = "pin"
const RequestParamNewPIN* = "new-pin"
const RequestParamPUK* = "puk"
const RequestParamNewPUK* = "new-puk"
const RequestParamMasterKey* = "master-key"
const RequestParamWalleRootKey* = "wallet-root-key"
const RequestParamWalletKey* = "wallet-key"
const RequestParamEIP1581Key* = "eip1581-key"
const RequestParamWhisperKey* = "whisper-key"
const RequestParamEncKey* = "encryption-key"
const RequestParamExportedKey* = "exported-key"
const RequestParamMnemonic* = "mnemonic"
const RequestParamMnemonicLen* = "mnemonic-length"
const RequestParamMnemonicIdxs* = "mnemonic-indexes"
const RequestParamTXHash* = "tx-hash"
const RequestParamBIP44Path* = "bip44-path"
const RequestParamTXSignature* = "tx-signature"
const RequestParamOverwrite* = "overwrite"
const RequestParamResolveAddr* = "resolve-addresses"
const RequestParamCardMeta* = "card-metadata"
const RequestParamCardName* = "card-name"
const RequestParamWalletPaths* = "wallet-paths"

const ResponseKeyType* = "type"
const ResponseKeyEvent* = "event"

const ResponseTypeValueKeycardFlowResult* = "keycard.flow-result"
const ResponseTypeValueInsertCard* = "keycard.action.insert-card"
const ResponseTypeValueCardInserted* = "keycard.action.card-inserted"
const ResponseTypeValueSwapCard* = "keycard.action.swap-card"
const ResponseTypeValueEnterPairing* = "keycard.action.enter-pairing"
const ResponseTypeValueEnterPIN* = "keycard.action.enter-pin"
const ResponseTypeValueEnterPUK* = "keycard.action.enter-puk"
const ResponseTypeValueEnterNewPair* = "keycard.action.enter-new-pairing"
const ResponseTypeValueEnterNewPIN* = "keycard.action.enter-new-pin"
const ResponseTypeValueEnterNewPUK* = "keycard.action.enter-new-puk"
const ResponseTypeValueEnterTXHash* = "keycard.action.enter-tx-hash"
const ResponseTypeValueEnterPath* = "keycard.action.enter-bip44-path"
const ResponseTypeValueEnterMnemonic* = "keycard.action.enter-mnemonic"
const ResponseTypeValueEnterCardName* = "keycard.action.enter-cardname"
const ResponseTypeValueEnterWallets* = "keycard.action.enter-wallets"

const ResponseParamInitialized* = "initialized"
const ResponseParamAppInfoInstanceUID* = "instanceUID"
const ResponseParamVersion* = "version"
const ResponseParamAvailableSlots* = "availableSlots"
const ResponseParamAppInfoKeyUID* = "keyUID"
const ResponseParamName* = "name"
const ResponseParamWallets* = "wallets"
const ResponseParamPath* = "path"
const ResponseParamAddress* = "address"
const ResponseParamPublicKey* = "publicKey"
const ResponseParamPrivateKey* = "privateKey"
const ResponseParamTxSignatureR* = "r"
const ResponseParamTxSignatureS* = "s"
const ResponseParamTxSignatureV* = "v"
const ResponseParamErrorKey* = ErrorKey
const ResponseParamInstanceUID* =RequestParamInstanceUID
const ResponseParamCardMeta* = RequestParamCardMeta
const ResponseParamFreeSlots* = RequestParamFreeSlots
const ResponseParamPINRetries* = RequestParamPINRetries
const ResponseParamPUKRetries* = RequestParamPUKRetries
const ResponseParamKeyUID* = RequestParamKeyUID
const ResponseParamAppInfo* = RequestParamAppInfo
const ResponseParamEIP1581Key* = RequestParamEIP1581Key
const ResponseParamEncKey* = RequestParamEncKey
const ResponseParamMasterKey* = RequestParamMasterKey
const ResponseParamWalletKey* = RequestParamWalletKey
const ResponseParamWalleRootKey* = RequestParamWalleRootKey
const ResponseParamWhisperKey* = RequestParamWhisperKey
const ResponseParamMnemonicIdxs* = RequestParamMnemonicIdxs
const ResponseParamTXSignature* = RequestParamTXSignature