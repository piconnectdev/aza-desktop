import NimQml, logging, std/json, sequtils, strutils
import tables, stint, sets

import model
import entry
import recipients_model

import web3/conversions

import app/core/eventemitter
import app/core/signals/types

import backend/activity as backend_activity
import backend/transactions

type EventCallbackProc = proc (eventObject: JsonNode)
type WalletEventCallbackProc = proc (data: WalletSignal)

# EventsHandler responsible for catching activity related backend events and reporting them
QtObject:
  type
    EventsHandler* = ref object of QObject
      events: EventEmitter
      eventHandlers: Table[string, EventCallbackProc]
      walletEventHandlers: Table[string, WalletEventCallbackProc]

      # Ignore events older than this relevantTimestamp
      relevantTimestamp: int
      subscribedAddresses: HashSet[string]
      newDataAvailableFn: proc()

  proc setup(self: EventsHandler) =
    self.QObject.setup

  proc delete*(self: EventsHandler) =
    self.QObject.delete

  proc onFilteringDone*(self: EventsHandler, handler: EventCallbackProc) =
    self.eventHandlers[backend_activity.eventActivityFilteringDone] = handler

  proc onGetRecipientsDone*(self: EventsHandler, handler: EventCallbackProc) =
    self.eventHandlers[backend_activity.eventActivityGetRecipientsDone] = handler

  proc onGetOldestTimestampDone*(self: EventsHandler, handler: EventCallbackProc) =
    self.eventHandlers[backend_activity.eventActivityGetOldestTimestampDone] = handler

  proc onNewDataAvailable*(self: EventsHandler, handler: proc()) =
    self.newDataAvailableFn = handler

  proc handleApiEvents(self: EventsHandler, e: Args) =
    var data = WalletSignal(e)

    if self.walletEventHandlers.hasKey(data.eventType):
      let callback = self.walletEventHandlers[data.eventType]
      callback(data)
    elif self.eventHandlers.hasKey(data.eventType):
      var responseJson: JsonNode
      responseJson = parseJson(data.message)

      if responseJson.kind != JObject:
        error "unexpected json type", responseJson.kind
        return
      let callback = self.eventHandlers[data.eventType]
      callback(responseJson)
    else:
      discard

  proc setupWalletEventHandlers(self: EventsHandler) =
    let newDataAvailableCallback = proc (data: WalletSignal) =
      if self.newDataAvailableFn == nil:
        return

      if data.at > 0 and self.relevantTimestamp > 0 and data.at < self.relevantTimestamp:
        return

      # Check addresses if any was reported
      var contains = data.accounts.len == 0
      for address in data.accounts:
        if address in self.subscribedAddresses:
          contains = true
          break

      if contains:
        # TODO: throttle down the number of events to one per 1 seconds until the backend supports subscription
        self.newDataAvailableFn()

    self.walletEventHandlers[EventNewTransfers] = newDataAvailableCallback
    self.walletEventHandlers[EventPendingTransactionUpdate] = newDataAvailableCallback

  proc newEventsHandler*(events: EventEmitter): EventsHandler =
    new(result, delete)
    result.events = events
    result.eventHandlers = initTable[string, EventCallbackProc]()

    result.subscribedAddresses = initHashSet[string]()

    result.setup()

    result.setupWalletEventHandlers()

    # Register for wallet events
    let eventsHandler = result
    result.events.on(SignalType.Wallet.event, proc(e: Args) =
        eventsHandler.handleApiEvents(e)
    )

  proc updateRelevantTimestamp*(self: EventsHandler, timestamp: int) =
    self.relevantTimestamp = timestamp

  proc updateSubscribedAddresses*(self: EventsHandler, addresses: seq[string]) =
    self.subscribedAddresses.clear()
    for address in addresses:
      self.subscribedAddresses.incl(address)