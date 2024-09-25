import NimQml, Tables, stew/shims/strformat, sequtils, sugar

# TODO: use generics to remove duplication between user_model and member_model

import ../../../app_service/common/types
import ../../../app_service/service/contacts/dto/contacts
import member_item

type
  ModelRole {.pure.} = enum
    PubKey = UserRole + 1
    DisplayName
    PreferredDisplayName
    EnsName
    IsEnsVerified
    LocalNickname
    Alias
    Icon
    ColorId
    ColorHash
    OnlineStatus
    IsContact
    IsVerified
    IsUntrustworthy
    IsBlocked
    ContactRequest
    IncomingVerificationStatus
    OutgoingVerificationStatus
    MemberRole
    Joined
    RequestToJoinId
    RequestToJoinLoading
    AirdropAddress
    MembershipRequestState

QtObject:
  type
    Model* = ref object of QAbstractListModel
      items: seq[MemberItem]

  proc delete(self: Model) =
    self.items = @[]
    self.QAbstractListModel.delete

  proc setup(self: Model) =
    self.QAbstractListModel.setup

  proc newModel*(): Model =
    new(result, delete)
    result.setup

  proc countChanged(self: Model) {.signal.}

  proc setItems*(self: Model, items: seq[MemberItem]) =
    self.beginResetModel()
    self.items = items
    self.endResetModel()
    self.countChanged()

  proc getItems*(self: Model): seq[MemberItem] =
    self.items

  proc `$`*(self: Model): string =
    for i in 0 ..< self.items.len:
      result &= fmt"""Member Model:
      [{i}]:({$self.items[i]})
      """

  proc getCount*(self: Model): int {.slot.} =
    self.items.len

  QtProperty[int]count:
    read = getCount
    notify = countChanged

  method rowCount(self: Model, index: QModelIndex = nil): int =
    return self.items.len

  method roleNames(self: Model): Table[int, string] =
    {
      ModelRole.PubKey.int: "pubKey",
      ModelRole.DisplayName.int: "displayName",
      ModelRole.PreferredDisplayName.int: "preferredDisplayName",
      ModelRole.EnsName.int: "ensName",
      ModelRole.IsEnsVerified.int: "isEnsVerified",
      ModelRole.LocalNickname.int: "localNickname",
      ModelRole.Alias.int: "alias",
      ModelRole.Icon.int: "icon",
      ModelRole.ColorId.int: "colorId",
      ModelRole.ColorHash.int: "colorHash",
      ModelRole.OnlineStatus.int: "onlineStatus",
      ModelRole.IsContact.int: "isContact",
      ModelRole.IsVerified.int: "isVerified",
      ModelRole.IsUntrustworthy.int: "isUntrustworthy",
      ModelRole.IsBlocked.int: "isBlocked",
      ModelRole.ContactRequest.int: "contactRequest",
      ModelRole.IncomingVerificationStatus.int: "incomingVerificationStatus",
      ModelRole.OutgoingVerificationStatus.int: "outgoingVerificationStatus",
      ModelRole.MemberRole.int: "memberRole",
      ModelRole.Joined.int: "joined",
      ModelRole.RequestToJoinId.int: "requestToJoinId",
      ModelRole.RequestToJoinLoading.int: "requestToJoinLoading",
      ModelRole.AirdropAddress.int: "airdropAddress",
      ModelRole.MembershipRequestState.int: "membershipRequestState"
    }.toTable

  method data(self: Model, index: QModelIndex, role: int): QVariant =
    if (not index.isValid):
      return

    if (index.row < 0 or index.row >= self.items.len):
      return

    let item = self.items[index.row]
    let enumRole = role.ModelRole

    case enumRole:
    of ModelRole.PubKey:
      result = newQVariant(item.pubKey)
    of ModelRole.DisplayName:
      result = newQVariant(item.displayName)
    of ModelRole.PreferredDisplayName:
      if item.localNickname != "":
        return newQVariant(item.localNickname)
      if item.ensName != "":
        return newQVariant(item.ensName)
      if item.displayName != "":
        return newQVariant(item.displayName)
      return newQVariant(item.alias)
    of ModelRole.EnsName:
      result = newQVariant(item.ensName)
    of ModelRole.IsEnsVerified:
      result = newQVariant(item.isEnsVerified)
    of ModelRole.LocalNickname:
      result = newQVariant(item.localNickname)
    of ModelRole.Alias:
      result = newQVariant(item.alias)
    of ModelRole.Icon:
      result = newQVariant(item.icon)
    of ModelRole.ColorId:
      result = newQVariant(item.colorId)
    of ModelRole.ColorHash:
      result = newQVariant(item.colorHash)
    of ModelRole.OnlineStatus:
      result = newQVariant(item.onlineStatus.int)
    of ModelRole.IsContact:
      result = newQVariant(item.isContact)
    of ModelRole.IsVerified:
      result = newQVariant(item.isVerified)
    of ModelRole.IsUntrustworthy:
      result = newQVariant(item.isUntrustworthy)
    of ModelRole.IsBlocked:
      result = newQVariant(item.isBlocked)
    of ModelRole.ContactRequest:
      result = newQVariant(item.contactRequest.int)
    of ModelRole.IncomingVerificationStatus:
      result = newQVariant(item.incomingVerificationStatus.int)
    of ModelRole.OutgoingVerificationStatus:
      result = newQVariant(item.outgoingVerificationStatus.int)
    of ModelRole.MemberRole:
      result = newQVariant(item.memberRole.int)
    of ModelRole.Joined:
      result = newQVariant(item.joined)
    of ModelRole.RequestToJoinId:
      result = newQVariant(item.requestToJoinId)
    of ModelRole.RequestToJoinLoading:
      result = newQVariant(item.requestToJoinLoading)
    of ModelRole.AirdropAddress:
      result = newQVariant(item.airdropAddress)
    of ModelRole.MembershipRequestState:
      result = newQVariant(item.membershipRequestState.int)

  proc addItem*(self: Model, item: MemberItem) =
    let modelIndex = newQModelIndex()
    defer: modelIndex.delete
    self.beginInsertRows(modelIndex, self.items.len, self.items.len)
    self.items.add(item)
    self.endInsertRows()
    self.countChanged()

  proc addItems*(self: Model, items: seq[MemberItem]) =
    if items.len == 0:
      return

    let modelIndex = newQModelIndex()
    defer: modelIndex.delete

    let first = self.items.len
    let last = first + items.len - 1

    self.beginInsertRows(modelIndex, first, last)
    self.items.add(items)
    self.endInsertRows()
    self.countChanged()

  proc findIndexForMember(self: Model, pubKey: string): int =
    for i in 0 ..< self.items.len:
      if(self.items[i].pubKey == pubKey):
        return i

    return -1

  proc removeItemWithIndex(self: Model, index: int) =
    let parentModelIndex = newQModelIndex()
    defer: parentModelIndex.delete

    self.beginRemoveRows(parentModelIndex, index, index)
    self.items.delete(index)
    self.endRemoveRows()
    self.countChanged()

  proc isContactWithIdAdded*(self: Model, id: string): bool =
    return self.findIndexForMember(id) != -1

  proc setName*(self: Model, pubKey: string, displayName: string, ensName: string, localNickname: string) =
    let ind = self.findIndexForMember(pubKey)
    if ind == -1:
      return

    var roles: seq[int] = @[]

    if self.items[ind].displayName != displayName:
      self.items[ind].displayName = displayName
      roles.add(ModelRole.DisplayName.int)

    if self.items[ind].ensName != ensName:
      self.items[ind].ensName = ensName
      roles.add(ModelRole.EnsName.int)

    if self.items[ind].localNickname != localNickname:
      self.items[ind].localNickname = localNickname
      roles.add(ModelRole.LocalNickname.int)

    if roles.len == 0:
      return

    roles.add(ModelRole.PreferredDisplayName.int)

    let index = self.createIndex(ind, 0, nil)
    defer: index.delete
    self.dataChanged(index, index, roles)

  proc setIcon*(self: Model, pubKey: string, icon: string) =
    let ind = self.findIndexForMember(pubKey)
    if ind == -1:
      return

    if self.items[ind].icon == icon:
      return

    self.items[ind].icon = icon

    let index = self.createIndex(ind, 0, nil)
    defer: index.delete
    self.dataChanged(index, index, @[ModelRole.Icon.int])

  proc updateItem*(
      self: Model,
      pubKey: string,
      displayName: string,
      ensName: string,
      isEnsVerified: bool,
      localNickname: string,
      alias: string,
      icon: string,
      isContact: bool,
      isVerified: bool,
      memberRole: MemberRole,
      joined: bool,
      isUntrustworthy: bool,
      ) =
    let ind = self.findIndexForMember(pubKey)
    if ind == -1:
      return

    var roles: seq[int] = @[]

    var preferredNameMightHaveChanged = false

    if self.items[ind].displayName != displayName:
      self.items[ind].displayName = displayName
      preferredNameMightHaveChanged = true
      roles.add(ModelRole.DisplayName.int)

    if self.items[ind].ensName != ensName:
      self.items[ind].ensName = ensName
      preferredNameMightHaveChanged = true
      roles.add(ModelRole.EnsName.int)

    if self.items[ind].localNickname != localNickname:
      self.items[ind].localNickname = localNickname
      preferredNameMightHaveChanged = true
      roles.add(ModelRole.LocalNickname.int)

    if self.items[ind].isEnsVerified != isEnsVerified:
      self.items[ind].isEnsVerified = isEnsVerified
      roles.add(ModelRole.IsEnsVerified.int)

    if self.items[ind].alias != alias:
      self.items[ind].alias = alias
      preferredNameMightHaveChanged = true
      roles.add(ModelRole.Alias.int)

    if self.items[ind].icon != icon:
      self.items[ind].icon = icon
      roles.add(ModelRole.Icon.int)

    if self.items[ind].isContact != isContact:
      self.items[ind].isContact = isContact
      roles.add(ModelRole.IsContact.int)

    if self.items[ind].isVerified != isVerified:
      self.items[ind].isVerified = isVerified
      roles.add(ModelRole.IsVerified.int)

    if self.items[ind].memberRole != memberRole:
      self.items[ind].memberRole = memberRole
      roles.add(ModelRole.MemberRole.int)

    if self.items[ind].joined != joined:
      self.items[ind].joined = joined
      roles.add(ModelRole.Joined.int)

    if self.items[ind].isUntrustworthy != isUntrustworthy:
      self.items[ind].isUntrustworthy = isUntrustworthy
      roles.add(ModelRole.IsUntrustworthy.int)

    if preferredNameMightHaveChanged:
      roles.add(ModelRole.PreferredDisplayName.int)

    if roles.len == 0:
      return

    let index = self.createIndex(ind, 0, nil)
    defer: index.delete
    self.dataChanged(index, index, roles)

  proc updateItem*(
      self: Model,
      pubKey: string,
      displayName: string,
      ensName: string,
      isEnsVerified: bool,
      localNickname: string,
      alias: string,
      icon: string,
      isContact: bool,
      isVerified: bool,
      isUntrustworthy: bool,
      ) =
    let ind = self.findIndexForMember(pubKey)
    if ind == -1:
      return

    self.updateItem(
      pubKey,
      displayName,
      ensName,
      isEnsVerified,
      localNickname,
      alias,
      icon,
      isContact,
      isVerified,
      memberRole = self.items[ind].memberRole,
      joined = self.items[ind].joined,
      isUntrustworthy,
    )

  proc setOnlineStatus*(self: Model, pubKey: string, onlineStatus: OnlineStatus) =
    let idx = self.findIndexForMember(pubKey)
    if idx == -1:
      return

    if self.items[idx].onlineStatus == onlineStatus:
      return

    self.items[idx].onlineStatus = onlineStatus
    let index = self.createIndex(idx, 0, nil)
    defer: index.delete
    self.dataChanged(index, index, @[
      ModelRole.OnlineStatus.int
    ])

  proc setAirdropAddress*(self: Model, pubKey: string, airdropAddress: string) =
    let idx = self.findIndexForMember(pubKey)
    if idx == -1:
      return

    if self.items[idx].airdropAddress == airdropAddress:
      return

    self.items[idx].airdropAddress = airdropAddress
    let index = self.createIndex(idx, 0, nil)
    defer: index.delete
    self.dataChanged(index, index, @[
      ModelRole.AirdropAddress.int
    ])

# TODO: rename me to removeItemByPubkey
  proc removeItemById*(self: Model, pubKey: string) =
    let ind = self.findIndexForMember(pubKey)
    if ind == -1:
      return

    self.removeItemWithIndex(ind)

# TODO: rename me to getItemsAsPubkeys
  proc getItemIds*(self: Model): seq[string] =
    return self.items.map(i => i.pubKey)

  proc updateLoadingState*(self: Model, memberKey: string, requestToJoinLoading: bool) =
    let idx = self.findIndexForMember(memberKey)
    if idx == -1:
      return

    if self.items[idx].requestToJoinLoading == requestToJoinLoading:
      return

    self.items[idx].requestToJoinLoading = requestToJoinLoading
    let index = self.createIndex(idx, 0, nil)
    defer: index.delete
    self.dataChanged(index, index, @[
      ModelRole.RequestToJoinLoading.int
    ])

  proc updateMembershipStatus*(self: Model, memberKey: string, membershipRequestState: MembershipRequestState) {.inline.} =
    let idx = self.findIndexForMember(memberKey)
    if idx == -1:
      return

    if self.items[idx].membershipRequestState == membershipRequestState:
      return

    self.items[idx].membershipRequestState = membershipRequestState
    let index = self.createIndex(idx, 0, nil)
    defer: index.delete
    self.dataChanged(index, index, @[
      ModelRole.MembershipRequestState.int
    ])
