import strformat
import ../../../../shared_models/wallet_account_item
import ./related_accounts_model as related_accounts_model

export wallet_account_item

type
  Item* = ref object of WalletAccountItem
    relatedAccounts: related_accounts_model.Model

proc initItem*(
  name: string = "",
  address: string = "",
  path: string = "",
  colorId: string = "",
  walletType: string = "",
  emoji: string = "",
  relatedAccounts: related_accounts_model.Model = nil,
  keyUid: string = "",
  keycardAccount: bool = false,
  position: int = 0,
  operability: string = ""
): Item =
  result = Item()
  result.WalletAccountItem.setup(name,
    address,
    colorId,
    emoji,
    walletType,
    path,
    keyUid,
    keycardAccount,
    position,
    operability)

  result.relatedAccounts = relatedAccounts

proc `$`*(self: Item): string =
  result = "ProfileSection-Accounts-Item("
  result = result & $self.WalletAccountItem
  result = result & "\nrelatedAccounts: " & $self.relatedAccounts
  result = result & ")"

proc relatedAccounts*(self: Item): related_accounts_model.Model =
  return self.relatedAccounts
