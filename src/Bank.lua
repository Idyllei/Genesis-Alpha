-- Genesis/src/Bank.lua

--- @author Spencer Tupis
-- @copyright Spencer Tupis,branefreez
-- @release Module$Core2$Module_DataBase$Bank$ModuleScript
-- @class module

-- INSTRUCTIONS: In order to use the Bank API/Database, you must do the following:
-- > require("Bank").setup()
--   [DEBUG][Bank]::setup() Setting up Bank DBAPI Environment.
--   [DEBUG][Bank]::setup() Finished setting up Bank DBAPI Environment.

-- TODO: Make compatible with NPCs

local rawget,rawset,getfenv,unpack=rawget,rawset,getfenv,unpack;
local print,error=print,error;
local setmetatable,table,pairs=setmetatable,table,pairs;
local pcall,tick,tostring=pcall,tick,tostring

local API=require("API");
local Bank={};
local _accounts={};

local bapi={
  setup = function(self) 
    print("[DEBUG][Bank]::setup()|Start ",self.setup);
    print("[DEBUG][Bank]::setup() Setting up Bank DBAPI Environment.");
    setfenv(1,{unpack(getfenv({})),bank=Bank,accounts=_accounts});
    print("[DEBUG][Bank]::setup() Finished setting up Bank DBAPI Environment.");
    print("[DEBUG][Bank]::setup()|End ",self.setup);
  end
};

local bankAccountTemplate = {
  Owner = "\000",
  OwnerId=0,
  Balance = 0,
  Interest = 0.03, -- n / 100; 3 / 100
  IOUMode = false, -- Used for ensuring IOU's get paid;
  AccountLocked = false, -- for moderation
  IsJointAccount = true, -- usually false;
  JointAccount = {
    JointAccountId = 0,
    JointOwners = {},
    JointBalance = 0,
    JointInterest = 0, -- JointInterest = Avg. of all owners' interest;
    Sent = {}, -- Even if NOT joint account, `Sent' is placed in here;
    -- Transactions in `Sent' are archived by the Send To Name or JointAccountId and then in chronological order.
    Received = {} -- Even if NOT joint account, `Received' is placed in here;
    -- Transactions in `Received' are archived by alphabetical order of Sender's Name or JointAccountId
  },
  LockLogs = {}, -- Reasons for Locks go in here; chronological sorting
  -- LockLogs[tostring(tick())] = { LockoutEnds = tick() + Ticks, Reason = Reason};
  IOUList = {}
  -- Sorted Alphabetically to whom the money is owed.
  -- [k] = v -> [Creditor] = Amount
  -- A special key value of ["Deny-TxOut"] and Value of (-1)^.5 (-1.#IND) is put in the IOUList to prevent sending any money, but can be easily removed by a specified key sequence: "QWERTY" or "qwerty";
  -- Testing the value to make sure it is NaN can be done by the following:
  --  IsNaN(x)
};

function Bank:setNPCAccount()
  print("[DEBUG][local][Bank]|Start ",Bank.setNPCAccount);
  print("[DEBUG][Bank]::setNPCAccount|Setting up NPC bank account.");
  _accounts["NPC"] = setmetatable(bankAccountTemplate, {
    __index=bankAccountTemplate,
    __newindex=function(self,index,value)
      if (not rawget(self,index)) then
        error("[DEBUG][ERROR][Bank]::setAccount __newindex Attempt to set an invalid index.",2);
        return;
      end
      self[index]=value;
    end,
    __call=function(...)
      print("[DEBUG][Bank]::setAccount __call(...): ", unpack(...));
      return;
    end
  });
  print("[DEBUG][Bank]::setAccount|Progress:1/3");
  print("[DEBUG][Bank]::setAccount|Setting `account.Owner' to 'NPC'.");
  _accounts["NPC"].Owner="NPC";
  print("[DEBUG][Bank]::setAccount|Progress:2/3");
  print("[DEBUG][Bank]::setAccount|Setting `account.OwnerId' to pNPC userId: -1");
  _accounts["NPC"].OwnerId=-1
  print("[DEBUG][Bank]::setAccount|Progress:3/3\nFinished setting up account for 'NPC'");
  print("[DEBUG][local][Bank]|Start",Bank.setNPCAccount);
  return _accounts["NPC"];
end

function Bank:setAccount(Player) -- BankAccount
  print("[DEBUG][Bank]::setAccount()|Start ",Bank.setAccount);
  if (not Player) then 
    error("[DEBUG][ERROR][Bank]::setAccount | Attempt to set account for non-existent player.",2);
    print("[DEBUG][local][Bank]|End ",Bank.setAccount);
    return false; 
  end
  print("[DEBUG][Bank]::setAccount Setting up account for player '"..API.getPlayer(Player).."'");
  _accounts[API.getPlayer(Player).Name] = setmetatable(bankAccountTemplate, {
    __index=bankAccountTemplate,
    __newindex=function(self,index,value)
      if (not rawget(self,index)) then
        error("[DEBUG][ERROR][Bank]::setAccount __newindex Attempt to set an invalid index.",2);
        return;
      end
      self[index]=value;
    end,
    __call=function(...)
      print("[DEBUG][Bank]::setAccount __call(...): ", unpack(...));
      return;
    end
  });
  print("[DEBUG][Bank]::setAccount|Progress:1/3");
  print("[DEBUG][Bank]::setAccount|Setting `account.Owner' to player's name.");
  _accounts[API.getPlayer(Player).Name].Owner=API.getPlayer(Player).Name;
  print("[DEBUG][Bank]::setAccount|Progress:2/3");
  print("[DEBUG][Bank]::setAccount|Setting `account.OwnerId' to player's userId");
  _accounts[API.getPlayer(Player).Name].OwnerId=API.getPlayer(Player).userId;
  print("[DEBUG][Bank]::setAccount|Progress:3/3\nFinished setting up account for player '"..API.getPlayer(Player).."'");
  print("[DEBUG][local][Bank]|End ",Bank.setAccount);
  return _accounts[API.getPlayer(Player).Name];
end

function Bank:getAccount(Player) -- BankAccount
  print("DEBUG][local][Bank]|Start ",Bank.getAccount);
  if (not Player) then 
    error("[DEBUG][ERROR][Bank]::getAccount | Attempt to get account of non-existent player.",2);
    print("[DEBUG][local][Bank]|End ",Bank.getAccount);
    return false; 
  end
  print("[DEBUG][Bank]::getAccount|Fetching account of player '"..API.getPlayer(Player).Name.."'");
  print("[DEBUG][local][Bank]|End ",Bank.getAccount);
  return _accounts[API.getPlayer(Player).Name];
end

function Bank:sendTransaction(From, To, Amount) -- Boolean (false) for failure, 1: DenyTxOut, 0: Able to send Tx to IOU Creditor, -1: To is not in IOUList,string:not enough money to send amount amt, table: Details of Tx.
  print("[DEBUG][Bank]::sendTransaction()|Start ",Bank.sendTransaction);
  if (not (From and To and Amount)) then 
    error("[DEBUG][ERROR][Bank]::sendTransaction | Attempt to call `sendTransaction' with invalid parameters (nil param).",2);
    print("[DEBUG][local][Bank]|End ",Bank.sendTransaction);
    return false; 
  end
  if Bank.isInIOUList("Deny_TxOut") then 
    print("[DEBUG][Bank]::sendTxOut|"..From.Owner..":  Deny_TxOut");
    print("[DEBUG][local][Bank]|End ",Bank.sendTransaction);
    return 1; 
  end
  if Bank.hasIOUInQueue(API.getPlayer(From)) and (not Bank.getAccount(From).IOUList[Bank.getAccount(To).Name]) then
    print("[DEBUG][Bank]::sendTransaction|"..From.Owner..": Sending to IOU Creditor."); 
    print("[DEBUG][local][Bank]|End ",Bank.sendTransaction);
    return 0; 
  end
  if Bank.getAccount(To) ~= Bank.getAccount(From).IOUList[API.getName(To).Name] then 
    print("[DEBUG][Bank]::sendTransaction|"..From.Owner..": `To' is not in player's IOUList.");
    print("[DEBUG][local][Bank]|End ",Bank.sendTransaction);
    return -1; 
  end
  From = Bank.getAccount(From);
  To = Bank.getAccount(To);
  if (Amount > From.JointAccount.JointBalance) then 
    print("[DEBUG][Bank]|"..From.Owner..": Not enough money to send amount "..Amount..".");
    print("[DEBUG][local][Bank]|End ",Bank.sendTransaction);
    return ""; 
  end
  table.insert(From.JointAccount.Sent[To.Owner], Amount);
  From.Balance = From.Balance - Amount;
  table.insert(To.JointAccount.Received[From.Owner], Amount);
  To.Balance = To.Balance + Amount;
  print("[DEBUG][Bank]::sendTransaction|"..From.Owner..": successfully paid "..Amount.." to "..To.Owner..".");
  print("[DEBUG][local][Bank]|End ",Bank.sendTransaction);
  return {From = From.Owner, To = To.Owner, Amount = Amount};
end

function Bank:sendAnonTransaction(From, To, Amount) -- Boolean (false) for failure, 1: DenyTxOut, 0: Able to send Tx to IOU Creditor, -1: To is not in IOUList, table: Details of Tx.
  print("[DEBUG][Bank]::sendAnonTransaction()|Start ",Bank.sendAnonTransaction);
  if (not (From and To and Amount)) then 
    error("[DEBUG][ERROR][Bank]::sendAnonTransaction | Attempt to call `sendAnonTransaction' with invalid parameters (nil param).",2);
    print("[DEBUG][Bank]::sendAnonTransaction()|End ",Bank.sendAnonTransaction);
    return false; 
  end
  if Bank.isInIOUList("Deny_TxOut") then 
    print("[DEBUG][Bank]::sendTxOut|"..From.Owner..":  Deny_TxOut");
    print("[DEBUG][Bank]::sendAnonTransaction()|End ",Bank.sendAnonTransaction);
    return 1; 
  end
  if Bank.hasIOUInQueue(API.getPlayer(From)) and (not Bank.getAccount(From).IOUList[Bank.getAccount(To).Name]) then 
    print("[DEBUG][Bank]::sendTransaction|"..From.Owner..": Sending to IOU Creditor."); 
    print("[DEBUG][Bank]::sendAnonTransaction()|End ",Bank.sendAnonTransaction);
    return 0; 
  end
  if Bank.getAccount(To) ~= Bank.getAccount(From).IOUList[API.getName(To).Name] then 
    print("[DEBUG][Bank]::sendTransaction|"..From.Owner..": `To' is not in player's IOUList.");
    print("[DEBUG][Bank]::sendAnonTransaction()|End ",Bank.sendAnonTransaction);
    return -1; 
  end
  From = Bank.getAccount(From);
  To = Bank.getAccount(To);
  if Amount > From.JointAccount.JointBalance then 
    print("[DEBUG][Bank]|"..From.Owner..": Not enough money to send amount "..Amount..".");
    print("[DEBUG][Bank]::sendAnonTransaction()|End ",Bank.sendAnonTransaction);
    return false; 
  end
  table.insert(From.JointAccount.Sent[To.Owner], Amount);
  From.Balance = From.Balance - Amount;
  table.insert(To.JointAccount.Received["Anonymous"], Amount);
  To.Balance = To.Balance + Amount;
  print("[DEBUG][Bank]::sendTransaction|"..From.Owner..": successfully paid "..Amount.." to "..To.Owner..".");
  print("[DEBUG][Bank]::sendAnonTransaction()|End ",Bank.sendAnonTransaction);
  return {From = "Anonymous", To = To.Owner, Amount = Amount};
end

function Bank:sendTransactionNoLogs(From, To, Amount) -- Boolean  (false) for failure, 1: DenyTxOut, 0: Able to send Tx to IOU Creditor, -1: To is not in IOUList, table: Details of Tx.
  print("[DEBUG][Bank]::sendTransactionNoLogs()|Start ",Bank.sendTransactionNoLogs);
  if (not (From and To and Amount)) then 
    error("[DEBUG][ERROR][Bank]::sendTransactionNoLogs | Attempt to call `sendTransactionNoLogs' with invalid parameters (nil param).",2);
    print("[DEBUG][Bank]::SendTransacterNoLogs()|End ",Bank.sendTransactionNoLogs);
    return false; 
  end
  if Bank.isInIOUList("Deny_TxOut") then
    print("[DEBUG][Bank]::sendTxOut|"..From.Owner..":  Deny_TxOut"); 
    print("[DEBUG][Bank]::SendTransacterNoLogs()|End ",Bank.sendTransactionNoLogs);
    return 1; 
  end
  if Bank.hasIOUInQueue(API.getPlayer(From)) and (not Bank.getAccount(From).IOUList[Bank.getAccount(To).Name]) then 
    print("[DEBUG][Bank]::sendTransaction|"..From.Owner..": Sending to IOU Creditor."); 
    print("[DEBUG][Bank]::SendTransacterNoLogs()|End ",Bank.sendTransactionNoLogs);
    return 0; 
  end
  if Bank.getAccount(To) ~= Bank.getAccount(From).IOUList[API.getName(To).Name] then 
    print("[DEBUG][Bank]::sendTransaction|"..From.Owner..": `To' is not in player's IOUList.");
    print("[DEBUG][Bank]::SendTransacterNoLogs()|End ",Bank.sendTransactionNoLogs);
    return -1; 
  end
  From = Bank.getAccount(From);
  To = Bank.getAccount(To);
  if Amount > From.JointAccount.JointBalance then 
    print("[DEBUG][Bank]|"..From.Owner..": Not enough money to send amount "..Amount..".");
    print("[DEBUG][Bank]::SendTransacterNoLogs()|End ",Bank.sendTransactionNoLogs);
    return false; 
  end
  table.insert(From.JointAccount.Sent["******"], Amount);
  From.Balance = From.Balance - Amount;
  table.insert(To.JointAccount.Received["Anonymous"], Amount);
  To.Balance = To.Balance + Amount;
  print("[DEBUG][Bank]::sendTransaction|"..From.Owner..": successfully paid "..Amount.." to "..To.Owner..".");
  print("[DEBUG][Bank]::SendTransacterNoLogs()|End ",Bank.sendTransactionNoLogs);
  return {From = "Anonymous", To = "******", Amount = Amount};
end

function Bank:hasIOUInQueue(Player) -- Boolean, has IOUs
  print("[DEBUG][Bank]::hasIOUInQueue()|Start ",Bank.hasIOUInQueue);
  if (not Player) then 
    error("[DEBUG][ERROR][Bank]::hasIOUInQueue | Attempt to call `hasIOUInQueue' with invalid parameters (nil param).",2);
    print("[DEBUG][Bank]::hasIOUInQueue()|End ",Bank.hasIOUInQueue);
    return false; 
  end
  print("[DEBUG][Bank]::hasIOUInQueue()|End ",Bank.hasIOUInQueue);
  return #Bank.getAccount(Player).IOUList > 0;
end

function Bank:setIOU(Debtor, Creditor, Amount) -- Boolean, success 
  print("[DEBUG][Bank]::setIOU|Start ",Bank.setIOU);
  if (not (Debtor and Creditor and Amount)) then 
    error("[DEBUG][ERROR][Bank]::setIOU | Attempt to call `setIOU' with invalid parameters (nil param).",2);
    print("[DEBUG][Bank]::setIOU|End ",Bank.setIOU);
    return false; 
  end
  print("[DEBUG][Bank]::setIOU|Set IOU for player "..Debtor.." to player "..Creditor.."for amount "..Amount..".");
  table.insert(_accounts[API.getPlayer(Debtor).Name].IOUList[API.getPlayer(Creditor).Name], Amount);
  print("[DEBUG][Bank]::setIOU|End ",Bank.setIOU);
  return true;
end

function Bank:isInIOUList(Debtor, PotentialCreditor) -- Boolean, is PotentialCreditor in Debtor's IOUList?
  print("[DEBUG][Bank]::isInIOUList()|Start ",Bank.isInIOUList);
  if (not (Debtor and PotentialCreditor)) then 
    error("[DEBUG][ERROR][Bank]::isInIOUList | Attempt to call `isInIOUList' with invalid parameters (nil param).",2);
    print("[DEBUG][Bank]::isInIOUList()|End ",Bank.isInIOUList);
    return false; 
  end
  print("[DEBUG][Bank]::isInIOUList()|End ",Bank.isInIOUList);
  return not Bank.getAccount(Debtor).IOUList[API.getPlayer(PotentialCreditor).Name];
end

function Bank:confirmIOUPaid(Debtor, Creditor, Amount) -- Boolean, IOU to Creditor of amount Amount has been paid by Debtor;
  print("[DEBUG][Bank]::confirmIOUPaid()|Start ",Bank.confirmIOUPaid);
  if (not (Debtor and Creditor and Amount)) then 
    error("[DEBUG][ERROR][Bank]::confirmIOUPaid | Attempt to call `confirmIOUPaid' with invalid parameters (nil param).",2);
    print("[DEBUG][Bank]::confirmIOUPaid()|End ",Bank.confirmIOUPaid);
    return false; 
  end
  local Debtor_Acc = Bank.getAccount(Debtor);
  if Debtor_Acc.JointAccount.Sent[API.getPlayer(Creditor).Name][-1] == Amount then
    print("[DEBUG][Bank]::confirmIOUPaid|IOU Paid by "..Debtor.." to "..Creditor.." for amount "..Amount..".");
    print("[DEBUG][Bank]::confirmIOUPaid()|End ",Bank.confirmIOUPaid);
    return true;
  end
  print("[DEBUG][Bank]::confirmIOUPaid()|End ",Bank.confirmIOUPaid);
  return false;
end

function Bank:removeIOU(Debtor, Creditor) -- Boolean, IOU to Creditor in Debtor's IOUList has been removed;
  print("[DEBUG][Bank]::removeIOU()|Start ",Bank.removeIOU);
  if (not (Debtor and Creditor)) then 
    error("[DEBUG][ERROR][Bank]::removeIOU | Attempt to call `removeIOU' with invalid parameter (nil param).",2);
    print("[DEBUG][Bank]::removeIOU()|End ",Bank.removeIOU);
    return false; 
  end
  if Bank.getAccount(Debtor).IOUList[API.getPlayer(Creditor).Name] then
    print("[DEBUG][Bank]::removeIOU|Removing IOU of player "..Debtor.." to player "..Creditor..".");
    Bank.getAccount(Debtor).IOUList[API.getPlayer(Creditor).Name] = nil;
    print("[DEBUG][Bank]::removeIOU()|End ",Bank.removeIOU);
    return true;
  end
  print("[DEBUG][Bank]::removeIOU()|End ",Bank.removeIOU);
  return false;
end

function Bank:refreshJointBalance(Player) -- Boolean, JointBalance has been refreshed;
  print("[DEBUG][Bank]::refreshJointBalance()|Start ",Bank.refreshJoinBalance);
  if (not Player) then 
    error("[DEBUG][ERROR][Bank]::refreshJointBalance | Attempt to call `refreshJointBalance' with invalid parameters (nil param).",2);
    print("[DEBUG][Bank]::refreshJointBalance()|End ",Bank.refreshJointBalance);
    return false; 
  end
  local Account = Bank.getAccount(Player);
  Account.JointAccount.JointBalance = 0;
  for _,v in pairs(Account.JointAccount.JointOwners) do
    Account.JointAccount.JointBalance = Account.JointAccount.Balance + Bank.getAccount(v).Balance;
  end
  Account.JointAccount.JointBalance = Account.JointAccount.JointBalance + Account.Balance;
  print("[DEBUG][Bank]::refreshJointBalance()|End ",Bank.refreshJointBalance);
  return true;
end

function Bank:disallowOutgoingTx(Player) -- Outgoing Tx's have been disabled;
  print("[DEBUG][Bank]::dissallowOutgoingTx()|Start ",Bank.dissallowOutgoingTx);
  if (not Player) then 
    error("[DEBUG][ERROR][Bank]::disallowOutgoingTx | Attempt to call `disallowOutgoingTx' with invalid parameters (nil param)",2);
    print("[DEBUG][Bank]::dissallowOutgoingTx()|End ",Bank.dissallowOutgoingTx);
    return false; 
  end
  local Account = Bank.getAccount(Player);
  print("[DEBUG][Bank]::disallowOutgoingTx|Successfully disallowed outgoing Tx's.");
  pcall(function() Account.IOUList["Deny-TxOut"] = (-1)^.5; end);
  print("[DEBUG][Bank]::dissallowOutgoingTx()|End ",Bank.dissallowOutgoingTx);
  return true;
end

function Bank:lockAccount(Player, Ticks, Reason) -- Boolean, EndTime; Success, Time that lockout ends [tick() + Ticks]
  print("[DEBUG][Bank]::lockAccount()|Start ",Bank.lockAccount);
  if (not Player) then 
    error("[DEBUG][ERROR][Bank]::lockAccount | Attempt to call `lockAccount' with invalid parameters (nil param).",2);
    print("[DEBUG][Bank]::locakAccount()|End ",Bank.lockAccount);
    return false;     -- Player doesn't exist
  end 
  local Acc = Bank.getAccount(Player);
  Acc.AccountLocked = true;
  table.insert(Acc.LockLogs[tostring(tick())], {LockoutEnds = tick() + (Ticks or 7200), Reason = (Reason or "Unknown Reason")});
  print("[DEBUG][Bank]::lockAccount|Successfully locked account of player "..Player..".");
  print("[DEBUG][Bank]::locakAccount()|End ",Bank.lockAccount);
  return true, tick() + (Ticks or 7200);
end

function Bank:unlockAccount(Player) -- Boolean, account of Player has been unlocked;
  print("[DEBUG][Bank]::unlockAccount()|Start ",Bank.unlockAccount);
  if (not Player) then 
    error("[DEBUG][ERROR][Bank]::unlockAccount | Attempt to call `unlockAccount' with invalid parameters (nil param).",2);
    print("[DEBUG][Bank]::unlockAccount()|End ",Bank.unlockAccount);
    return false; 
  end
  for _,v in pairs(Bank.getAccount(Player).LockLogs) do --LockLogs[tostring(tick())]
    for i,key in pairs(v) do --LockLogs[tostring(tick()][1] -> LockLogs[tostring(tick())][#LockLogs[tostring(tick())]]
      if tostring(i) == 'LockoutEnd' then
        v = tick(); -- Ends NOW;
        v[i + 1] = v[i + 1] .. " | LOCKOUT REMOVED";
      end
    end
  end
  print("[DEBUG][Bank]::unlockAccount|Successfully unlocked account of player "..Player..".");
  print("[DEBUG][Bank]::unlockAccount()|End ",Bank.unlockAccount);
  return true;
end

return bapi;