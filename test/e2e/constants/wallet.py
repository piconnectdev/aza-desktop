import random
from enum import Enum


class DerivationPath(Enum):
    CUSTOM = 'Custom'
    ETHEREUM = 'Ethereum'
    ETHEREUM_ROPSTEN = 'Ethereum Testnet (Ropsten)'
    ETHEREUM_LEDGER = 'Ethereum (Ledger)'
    ETHEREUM_LEDGER_LIVE = 'Ethereum (Ledger Live/KeepKey)'
    STATUS_ACCOUNT_DERIVATION_PATH = "m / 44' / 60' / 0' / 0 / 0"
    GENERATED_ACCOUNT_DERIVATION_PATH_1 = "m / 44' / 60' / 0' / 0 / 1"


class WalletNetworkSettings(Enum):
    EDIT_NETWORK_LIVE_TAB = 'Live Network'
    EDIT_NETWORK_TEST_TAB = 'Test Network'
    TESTNET_SUBTITLE = 'Switch entire Status app to testnet only mode'
    TESTNET_ENABLED_TOAST_MESSAGE = 'Testnet mode turned on'
    TESTNET_DISABLED_TOAST_MESSAGE = 'Testnet mode turned off'
    ACKNOWLEDGMENT_CHECKBOX_TEXT = ('I understand that changing network settings can cause unforeseen issues, errors, '
                                    'security risks and potentially even loss of funds.')
    REVERT_TO_DEFAULT_LIVE_MAINNET_TOAST_MESSAGE = 'Live network settings for Mainnet reverted to default'
    REVERT_TO_DEFAULT_TEST_MAINNET_TOAST_MESSAGE = 'Test network settings for Mainnet reverted to default'
    STATUS_ACCOUNT_DEFAULT_NAME = 'Account 1'
    STATUS_ACCOUNT_DEFAULT_COLOR = '#2a4af5'


class WalletAccountSettings(Enum):
    STATUS_ACCOUNT_ORIGIN = 'Derived from your default Status key pair'
    WATCHED_ADDRESS_ORIGIN = 'Watched address'
    STORED_ON_DEVICE = 'On device'
    WATCHED_ADDRESSES_KEYPAIR_LABEL = 'Watched addresses'


class WalletNetworkNaming(Enum):
    LAYER1_ETHEREUM = 'Mainnet'
    LAYER2_OPTIMISIM = 'Optimism'
    LAYER2_ARBITRUM = 'Arbitrum'
    ETHEREUM_MAINNET_NETWORK_ID = 1
    ETHEREUM_SEPOLIA_NETWORK_ID = 11155111
    OPTIMISM_MAINNET_NETWORK_ID = 10
    OPTIMISM_SEPOLIA_NETWORK_ID = 11155420
    ARBITRUM_MAINNET_NETWORK_ID = 42161
    ARBITRUM_SEPOLIA_NETWORK_ID = 421614


class WalletNetworkDefaultValues(Enum):
    ETHEREUM_LIVE_MAIN = 'https://eth-archival.rpc.grove.city'
    ETHEREUM_TEST_MAIN = 'https://sepolia-archival.rpc.grove.city'
    ETHEREUM_LIVE_FAILOVER = 'https://mainnet.infura.io'
    ETHEREUM_TEST_FAILOVER = 'https://sepolia.infura.io'


class WalletEditNetworkErrorMessages(Enum):
    PINGUNSUCCESSFUL = 'RPC appears to be either offline or this is not a valid JSON RPC endpoint URL'
    PINGVERIFIED = 'RPC successfully reached'


class WalletOrigin(Enum):
    WATCHED_ADDRESS_ORIGIN = 'New watched address'


class WalletTransactions(Enum):
    TRANSACTION_PENDING_TOAST_MESSAGE = 'Transaction pending'


class WalletScreensHeaders(Enum):
    WALLET_ADD_ACCOUNT_POPUP_TITLE = 'Add a new account'
    WALLET_EDIT_ACCOUNT_POPUP_TITLE = 'Edit account'


class WalletRenameKeypair(Enum):
    WALLET_SUCCESSFUL_RENAMING = 'You successfully renamed your key pair\n'


class WalletSeedPhrase(Enum):
    WALLET_SEED_PHRASE_ALREADY_ADDED = 'The entered seed phrase is already added'


class WalletAccountPopup(Enum):
    WALLET_ACCOUNT_NAME_MIN = 'Account name must be at least 5 characters'
    WALLET_KEYPAIR_NAME_MIN = 'Key pair name must be at least 5 character(s)'
    WALLET_KEYPAIR_MIN = 'Key pair must be at least 5 character(s)'


class SeedPhrases(Enum):
    TWELVE_WORDS_SEED = 'pelican chief sudden oval media rare swamp elephant lawsuit wheat knife initial'
    EIGHTEEN_WORDS_SEED = 'kitten tiny cup admit cactus shrug shuffle accident century faith roof plastic beach police barely vacant sign blossom'
    TWENTY_FOUR_WORDS_SEED = 'elite dinosaur flavor canoe garbage palace antique dolphin virtual mixed sand impact solution inmate hair pipe affair cage vote estate gloom lamp robust like'

    @classmethod
    def select_random_seed(cls):
        return random.choice(list(SeedPhrases))