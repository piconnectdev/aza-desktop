const
  ETH_TRANSACTION_TYPE* = "eth"
  ERC20_TRANSACTION_TYPE* = "erc20"
  ERC721_TRANSACTION_TYPE* = "erc721"

  SNT_CONTRACT_ADDRESS* = "0x744d70fdbe2ba4cf95131626614a1763df805b9e"
  STT_CONTRACT_ADDRESS_SEPOLIA* = "0xE452027cdEF746c7Cd3DB31CB700428b16cD8E51"

  SIGNATURE_LEN* = 130
  SIGNATURE_LEN_0X_INCLUDED* = SIGNATURE_LEN + 2

  TX_HASH_LEN* = 32 * 2
  TX_HASH_LEN_WITH_PREFIX* = TX_HASH_LEN + 2

  PARASWAP_V5_APPROVE_CONTRACT_ADDRESS* = "0x216B4B4Ba9F3e719726886d34a177484278Bfcae" # Same address for all supported chains
  PARASWAP_V5_SWAP_CONTRACT_ADDRESS* = "0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57" # Same address for all supported chains
  PARASWAP_V6_2_CONTRACT_ADDRESS* = "0x6a000f20005980200259b80c5102003040001068" # Same address for all supported chains
