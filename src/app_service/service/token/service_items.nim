import strformat, Tables

import app_service/common/types as common_types
#TODO: remove dependency
import ../wallet_account/dto/token_dto

# This file holds the data types used by models internally

type SupportedSourcesItem* = ref object of RootObj
    name*: string
    updatedAt* : int64
    source*: string
    version*: string
    # Needed to show upfront on ui count of tokens on each list
    tokensCount*: int

proc `$`*(self: SupportedSourcesItem): string =
  result = fmt"""SupportedSourcesItem[
    name: {self.name},
    updatedAt: {self.updatedAt},
    source: {self.source},
    version: {self.version},
    tokensCount: {self.tokensCount}
    ]"""

type
  TokenItem* = ref object of RootObj
    # key is created using chainId and Address
    key*: string
    name*: string
    symbol*: string
    # uniswap/status/custom seq[string]
    sources*: seq[string]
    chainID*: int
    address*: string
    decimals*: int
    # will remain empty until backend provides us this data
    image*: string
    `type`*: common_types.NewTokenType
    communityId*: string

proc `$`*(self: TokenItem): string =
  result = fmt"""TokenItem[
    key: {self.key},
    name: {self.name},
    symbol: {self.symbol},
    sources: {self.sources},
    chainID: {self.chainID},
    address: {self.address},
    decimals: {self.decimals},
    image: {self.image},
    `type`: {self.`type`},
    communityId: {self.communityId}
    ]"""

type AddressPerChain* = ref object of RootObj
    chainId*: int
    address*: string

proc `$`*(self: AddressPerChain): string =
  result = fmt"""AddressPerChain[
    chainId: {self.chainId},
    address: {self.address}
    ]"""

type
  TokenBySymbolItem* = ref object of TokenItem
    addressPerChainId*: seq[AddressPerChain]

proc `$`*(self: TokenBySymbolItem): string =
  result = fmt"""TokenBySymbolItem[
    key: {self.key},
    name: {self.name},
    symbol: {self.symbol},
    sources: {self.sources},
    addressPerChainId: {self.addressPerChainId},
    decimals: {self.decimals},
    image: {self.image},
    `type`: {self.`type`},
    communityId: {self.communityId}
    ]"""

# In case of community tokens only the description will be available
type TokenDetails* = ref object of RootObj
    description*: string
    websiteUrl*: string
    marketValues*: TokenMarketValuesDto

proc cmpTokenItem*(x, y: TokenItem): int =
    cmp(x.name, y.name)

proc cmpTokenBySymbolItem*(x, y: TokenBySymbolItem): int =
    cmp(x.name, y.name)
