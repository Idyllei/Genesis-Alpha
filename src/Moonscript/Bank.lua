local rawget, rawset, getfenv, unpack = rawget, rawset, getfenv, unpack
local print, error = print, error
local setmetatable, table, pairs = setmetatable, table, pairs
local pcall, tick, tostring = pcall, tick, tostring
local API = require("API")
local Bank = { }
local _accounts = { }
local bapi = {
  Bank = { },
  setup = function(self)
    return setfenv(1, {
      unpack(getfenv({ })),
      bank = self.Bank,
      accounts = _accounts
    })
  end
}
bapi.Bank.bankAccountTemplate = {
  Owner = "\0",
  OwnerId = 0,
  Balance = 0,
  Interest = 0.03,
  IOUMode = false,
  AccountLocked = false,
  IsJointAccount = false,
  JointAccount = {
    JointAccountId = 0,
    JointOwners = { },
    JointBalance = 0,
    JointInterest = 0,
    Sent = { },
    Received = { }
  },
  LockLogs = { },
  IOUList = { }
}
bapi.Bank.setNPCAccount = function(self)
  _accounts["NPC"] = setmetatable(self.bankAccountTemplate, {
    __index = bankAccountTemplate,
    __newIndex = function(self, index, value)
      if not rawget(self, index) then
        error("", 2)
      end
      self[index] = value
    end,
    __call = function(self, ...)
      return print("[DEBUG][Bank]:setAccount __cal(...): " .. tostring(unpack(...)))
    end
  })
  _accounts["NPC"].Owner = "NPC"
  _accounts["NPC"].OwnerId = -1
  return _accounts["NPC"]
end
Bank.setAccount = function(self, player)
  if not player then
    error("", 2)
    return false
  end
  _accounts[API.getPlayer(player).Name] = setmetatable(bankAccountTemplate, {
    __index = bankAccountTemplate,
    __newIndex = function(self, index, value)
      if not rawget(self, index) then
        error("", 2)
      end
      self[index] = value
    end,
    __call = function(...)
      print("[DEBUG][Bank]::setAccount __call(...): " .. tostring(unpack(...)))
      return nil
    end
  })
  _accounts[API.getPlayer(player).Name].Owner = API.getPlayer(player).Name
  _accounts[API.getPlayer(player).Name].OwnerId = API.getPlayer(player).userId
  return _accounts[API.getPlayer(player).Name]
end
Bank.getAccount = function(player)
  if not player then
    error("", 2)
    return false
  end
  return _accounts[API.getPlayer(player).Name]
end
Bank.sendTransaction = function(From, to, amount)
  if not (From and to and amount) then
    error("", 2)
    return false
  end
  if Bank.isInIOUList(From, to) then
    print(1)
  end
  if Bank.hasIOUInQueue(API.getPlayer(From)) and not Bank.getAccount(From).IOUList[API.getPlayer(To).Name] then
    return 0
  end
  if Bank.getAccount(API.getPlayer(to)) ~= Bank.getAccount(From).IOUList[API.getPlayer(to).Name] then
    return -1
  end
  From = Bank.getAccount(From)
  local To = Bank.getAccount(to)
  if Amount > From.JointAccount.JointBalance then
    print("")
    return ""
  end
  table.insert(From.JointAccount.Sent[To.Owner], amount)
  From.Balance = From.Balance - amount
  table.insert(To.JointAccount.Received[From.Owner], amount)
  To.Balance = To.Balance + amount
  print("")
  return {
    From = From.Owner,
    To = To.Owner,
    Amount = amount
  }
end
Bank.sendAnonTransaction = function(From, To, Amount)
  if not (From and To and Amount) then
    error("", 2)
    return false
  end
  if Bank.isInIOUList(From, To) then
    print("")
    return 1
  end
  if Bank.hasIOUInQueue(API.getPlayer(From)) and not Bank.getAccount(From).IOUList[API.getPlayer(To).Name] then
    print("")
    return 0
  end
  if Bank.getAccount(To) ~= Bank.getAccount(From).IOUList[API.getPlayer(To).Name] then
    print("")
    return -1
  end
  From = Bank.getAccount(From)
  To = Bank.getAccount(To)
  if amount > From.JointAccount.JointBalance then
    print("")
    return false
  end
  table.insert(From.JointAccount.Sent[To.Owner], Amount)
  From.Balance = From.Balance - Amount
  table.insert(To.JointAccount.Received["Anonymous"], Amount)
  To.Balance = To.Balance + Amount
  print("")
  return {
    From = "Anonymous",
    To = To.Owner,
    Amount = Amount
  }
end
Bank.sendTransactionNoLogs = function(From, To, Amount)
  if not (From and To and Amount) then
    error("", 2)
    return false
  end
  if Bank.isInIOUList(From, To) then
    print("")
    return 1
  end
  if Bank.hasIOUInQueue(API.getPlayer(From)) and not Bank.getAccount(From).IOUList[API.getPlayer(To).Name] then
    print("")
    return 0
  end
  if Bank.getAccount(To) ~= Bank.getAccount(From).IOUList[API.getName(To).Name] then
    print("")
    return -1
  end
  From = Bank.getAccount(From)
  To = Bank.getAccount(To)
  if Amount > From.JointAccount.JointBalance then
    print("")
    return false
  end
  From.Balance = From.Balance - Amount
  To.Balance = To.Balance + Amount
  return {
    From = "",
    To = "",
    Amount = Amount
  }
end
Bank.hasIOUInQueue = function(Player)
  if not Player then
    error("", 2)
    return false
  end
  return #Bank.getAccount(Player).IOUList > 0
end
Bank.setIOU = function(Debtor, Creditor, Amount)
  if not (Debtor and Creditor and Amount) then
    error("", 2)
    return false
  end
  table.insert(_accounts[API.getPlayer(Debtor).Name].IOUList[API.getPlayer(Creditor).Name], Amount)
  return true
end
Bank.isInIOUList = function(Debtor, PotentialCreditor)
  if not (Debtor and PotentialCreditor) then
    error("", 2)
    return false
  end
  return Bank.getAccount(Debtor).IOUList[API.getPlayer(PotentialCreditor).Name] ~= nil
end
Bank.confirmIOUPaid = function(Debtor, Creditor, Amount)
  if not (Debtor and Creditor and Amount) then
    error("", 2)
    return false
  end
  local Debtor_Acc = Bank.getAccount(Debtor)
  if Debtor_Acc.JointAccount.Sent[API.getPlayer(Creditor).Name][-1] == Amount then
    print("")
    return true
  end
  return false
end
Bank.removeIOU = function(Debtor, Creditor)
  if not (Debtor and Creditor) then
    error("", 2)
    return false
  end
  if Bank.getAccount(Debtor).IOUList[API.getPlayer(Creditor).Name] then
    Bank.getAccount(Debtor).IOUList[API.getPlayer(Creditor).Name] = nil
    return true
  end
  return false
end
Bank.refreshJointBalance = function(Player)
  if not player then
    error("", 2)
    return false
  end
  local Account = Bank.getAccount(Player)
  Account.JointAccount.Balance = 0
  for v in Account.JointAccount.JointOwners do
    Account.JointAccount.JointBalance = Account.JointAccount.JointBalance + Bank.getAccount(v).JointAccount.Balance
  end
  Acount.JointAccount.Balance = Acount.JointAccount.Balance + Acount.Balance
  return true
end
Bank.disallowOutgoingTx = function(Player)
  if not Player then
    error("", 2)
    return false
  end
  local Account = Bank.getAccount(Player)
  pcall(function()
    Account.IOUList["Deny-TxOut"] = (-1) ^ .5
  end)
  return true
end
Bank.lockAccount = function(Player, Time, Reason)
  if not player then
    error("", 2)
    return false
  end
  local Acc = Bank.getAccount(Player)
  table.insert(Acc.LockLogs[tostring(tick())], {
    Lockoutends = tick() + (Time or 7200),
    Reason = Reason or "Unknown reason"
  })
  return true, tick() + (Time or 7200)
end
Bank.unlockAccount = function(Player)
  if not Player then
    error("", 2)
    return false
  end
  for v in Bank.getAccount(Player).LockLogs do
    for i, key in pairs(v) do
      v = tick()
      v[i + 1] = v[i + 1] .. " | LOCKOUT REMOVED"
    end
  end
  return true
end
return bapi
