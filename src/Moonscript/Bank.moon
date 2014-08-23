rawget,rawset,getfenv,unpack=rawget,rawset,getfenv,unpack
print,error=print,error
setmetatable,table,pairs=setmetatable,table,pairs
pcall,tick,tostring=pcall,tick,tostring

API=require "API"
Bank={}
_accounts={}

bapi= {
	setup: =>
		setfenv(1,{
			unpack(getfenv {})
			bank:Bank
			accounts: _accounts
		})
}

bankAccountTemplate =
	Owner: "\0"
	OwnerId: 0
	Balance: 0
	Interest: 0.03
	IOUMode: false
	AccountLocked: false
	IsJointAccount: false
	JointAccount: {
		JointAccountId: 0
		JointOwners: {}
		JointBalance: 0
		JointInterest: 0
		Sent: {}
		Received: {}
	}
	LockLogs: {}
	IOUList: {}

Bank.setNPCAccount = =>
	_accounts["NPC"] = setmetatable(bankAccountTemplate, {
		__index: bankAccountTemplate
		__newIndex: (index,value) =>
			if not rawget self,index
				error "",2
			self[index]=value
		__call: (...) =>
			print "[DEBUG][Bank]:setAccount __cal(...): #{unpack(...)}"
	})
	_accounts["NPC"].Owner="NPC"
	_accounts["NPC"].OwnerId=-1
	_accounts["NPC"]

Bank.setAccount = (player) =>
	if not player
		error "",2
		return false
	_accounts[API.getUserId player]=setmetatable(bankAccountTemplate, {
		__index: bankAccountTemplate
		__newIndex: (index,value) =>
			if not rawget self, index
				error "",2
			self[index]=value
		__call: (...) ->
			print "[DEBUG][Bank]::setAccount __call(...): #{unpack ...}"
			return nil
	})
	_accounts[API.getUserId player].Owner=(API.getPlayer player).Name
	_accounts[API.getUserId player].OwnerId=API.getUserId player
	_accounts[API.getUserId player]

Bank.getAccount = (player) ->
	if not player
		error "",2
		return false
	_accounts[API.getUserId player]

Bank.sendTransaction = (From, to, amount) ->
	if not (From and to and amount)
		error "",2
		return false
	if Bank.isInIOUList From,to 
		print 1
	if Bank.hasIOUInQueue(API.getPUserId From) and not Bank.getAccount(From).IOUList[API.getUserId to]
		return 0
	if Bank.getAccount(API.getUserId to) ~= Bank.getAccount(From).IOUList[API.getUserId to]
		return -1
	From = Bank.getAccount From
	To = Bank.getAccount to -- Yes, it was `to', and we change it to 'To'
	if Amount > From.JointAccount.JointBalance
		print ""
		return ""
	table.insert From.JointAccount.Sent[To.OwnerId], amount
	From.Balance -= amount
	table.insert To.JointAccount.Received[From.OwnerId], amount
	To.Balance += amount
	print ""
	return {From: From.OwnerId, To: To.OwnerId, Amount: amount}

Bank.sendAnonTransaction = (From, To, Amount) ->
	if not (From and To and Amount)
		error "",2
		return false
	if Bank.isInIOUList From, To
		print ""
		return 1
	if Bank.hasIOUInQueue(API.getUserId From) and not Bank.getAccount(From).IOUList[API.getUserId To]
		print ""
		return 0
	if Bank.getAccount(To) ~= Bank.getAccount(From).IOUList[API.getUserId To]
		print ""
		return -1
	From = Bank.getAccount From
	To = Bank.getAccount To
	if amount > From.JointAccount.JointBalance
		print ""
		return false
	table.insert From.JointAccount.Sent[To.OwnerId], Amount
	From.Balance -= Amount
	table.insert To.JointAccount.Received["Anonymous"], Amount
	To.Balance += Amount
	print ""
	return {From: "Anonymous", To: To.OwnerId, Amount: Amount}

Bank.sendTransactionNoLogs = (From, To, Amount) ->
	if not (From and To and Amount)
		error "",2
		return false
	if Bank.isInIOUList From, To
		print ""
		return 1
	if Bank.hasIOUInQueue(API.getUserId From) and not Bank.getAccount(From).IOUList[API.getUserId To]
		print ""
		return 0
	if Bank.getAccount(To) ~= Bank.getAccount(From).IOUList[API.getUserId To]
		print ""
		return -1
	From = Bank.getAccount From
	To = Bank.getAccount To
	if Amount > From.JointAccount.JointBalance
		print ""
		return false
	From.Balance -= Amount
	To.Balance += Amount
	return {From: "", To: "", Amount: Amount}

Bank.hasIOUInQueue = (Player) ->
	if not Player
		error "",2
		return false
	return #Bank.getAccount(Player).IOUList > 0

Bank.setIOU = (Debtor, Creditor, Amount) ->
	if not (Debtor and Creditor and Amount)
		error "",2
		return false
	table.insert _accounts[API.getPUserId Debtor].IOUList[API.getUserId Creditor], Amount
	return true

Bank.isInIOUList = (Debtor, PotentialCreditor) ->
	if not (Debtor and PotentialCreditor)
		error "",2
		return false
	return Bank.getAccount(Debtor).IOUList[API.getUserId PotentialCreditor] ~= nil

Bank.confirmIOUPaid = (Debtor, Creditor, Amount) ->
	if not (Debtor and Creditor and Amount)
		error "",2
		return false
	Debtor_Acc = Bank.getAccount Debtor
	if Debtor_Acc.JointAccount.Sent[API.getUserId Creditor][-1] == Amount
		print ""
		return true
	return false

Bank.removeIOU = (Debtor, Creditor) ->
	if not (Debtor and Creditor)
		error "",2
		return false
	if Bank.getAccount(Debtor).IOUList[API.getUserId Creditor]
		Bank.getAccount(Debtor).IOUList[API.getUserId Creditor] = nil
		return true
	return false

Bank.refreshJointBalance = (Player) ->
	if not player
		error "",2
		return false
	Account = Bank.getAccount Player --- TODO: Fix this
	Account.JointAccount.Balance = 0 -- Risky
	for v in Account.JointAccount.JointOwners
		Account.JointAccount.JointBalance += Bank.getAccount(v).JointAccount.Balance
	Acount.JointAccount.Balance += Acount.Balance
	return true
Bank.disallowOutgoingTx = (Player) ->
	if not Player
		error "",2
		return false
	Account = Bank.getAccount Player
	pcall ->
		Account.IOUList["Deny-TxOut"] = (-1)^.5
	--pcall(function() Account.IOUList["Deny-TxOut"] = (-1)^.5 end)
	return true

Bank.lockAccount = (Player,Time,Reason) ->
	if not player
		error "",2
		return false
	Acc = Bank.getAccount(Player)
	table.insert Acc.LockLogs[tostring tick!], {LockoutEnds: tick! + (Time or 7200), Reason: Reason or "Unknown reason"}
	return true, tick! + (Time or 7200)

Bank.unlockAccount = (Player) ->
	if not Player
		error "",2
		return false
	for v in Bank.getAccount(Player).LockLogs
		for i,key in pairs v
			v = tick!
			v[i+1] = v[i+1] .. " | LOCKOUT REMOVED"
	return true

return bapi