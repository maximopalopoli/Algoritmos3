!classDefinition: #PortfolioTest category: 'ServiciosFinancieros-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!PortfolioTest methodsFor: 'tests' stamp: 'MP 11/10/2022 20:11:28'!
test01PortfolioWithoutAccountsHasABalanceOfZero
	|aPortfolio|
	aPortfolio := Portfolio new.
	
	self assert: aPortfolio balance equals: 0.! !

!PortfolioTest methodsFor: 'tests' stamp: 'MP 11/10/2022 20:13:04'!
test02PortfolioWithOneAccountHasSameBalanceAsAccount
	|aPortfolio anAccount|
	
	anAccount := ReceptiveAccount new.
	Deposit register: 100 on: anAccount.
	aPortfolio := Portfolio with: anAccount.
	
	self assert: aPortfolio balance equals: 100.! !

!PortfolioTest methodsFor: 'tests' stamp: 'MP 11/10/2022 20:17:36'!
test03MamushkaPortfolioBalanceIsTheSumOfItsAccountsBalances
	|aPortfolio anAccount anotherPortfolio anotherAccount|
	
	anAccount := ReceptiveAccount new.
	Deposit register: 100 on: anAccount.
	
	aPortfolio := Portfolio with: anAccount.
	
	anotherAccount := ReceptiveAccount new.
	Withdraw register: 50 on: anotherAccount.	
	
	anotherPortfolio := Portfolio with: anotherAccount.
	
	aPortfolio add: anotherPortfolio.
	
	self assert: aPortfolio balance equals: 50.! !

!PortfolioTest methodsFor: 'tests' stamp: 'MP 11/10/2022 20:20:08'!
test04PortfolioWithoutAccountsDoesNotRegisterTransactions
	|aPortfolio|
	
	aPortfolio := Portfolio new.
	
	self assert: (aPortfolio hasRegistered: (Deposit for: 100)) equals: false.! !

!PortfolioTest methodsFor: 'tests' stamp: 'MP 11/10/2022 20:23:48'!
test05PortfolioWithOneAccountRegistersATransactionOfThatAccount
	|aPortfolio anAccount aTransaction |
	
	aPortfolio := Portfolio new.
	
	anAccount := ReceptiveAccount new.
	
	aPortfolio add: anAccount.
	
	aTransaction := Deposit register: 100 on: anAccount.
	
	self assert: (aPortfolio hasRegistered: aTransaction). ! !

!PortfolioTest methodsFor: 'tests' stamp: 'MP 11/10/2022 21:39:32'!
test06MamushkaPorfolioRegistersTransactionInCompositePortfolioAccount

	|componentPortfolio compositePortfolioAccountTransaction compositePortfolioAccount compositePortfolio |
	
	componentPortfolio := Portfolio new.
	
	componentPortfolio add: ReceptiveAccount new.
	
	compositePortfolioAccount := ReceptiveAccount new.
	compositePortfolioAccountTransaction := Withdraw register: 100 on: compositePortfolioAccount.	
	
	compositePortfolio := Portfolio with: compositePortfolioAccount.
	
	componentPortfolio add: compositePortfolio.
	
	self assert: (componentPortfolio hasRegistered: compositePortfolioAccountTransaction).! !

!PortfolioTest methodsFor: 'tests' stamp: 'MP 11/10/2022 21:48:33'!
test07PortfolioWithoutAccountsDoesNotHaveTransactions
	
	self assert: (Portfolio new transactions isEmpty).! !

!PortfolioTest methodsFor: 'tests' stamp: 'MP 11/10/2022 21:55:10'!
test08PortfolioWithOneAccountIncludesItsAccountTransaction

	|aPortfolio anAccount aTransaction |
	
	aPortfolio := Portfolio new.
	
	anAccount := ReceptiveAccount new.
	
	aPortfolio add: anAccount.
	
	aTransaction := Deposit register: 100 on: anAccount.
	
	self assert: (aPortfolio transactions includes: aTransaction).! !

!PortfolioTest methodsFor: 'tests' stamp: 'MP 11/10/2022 22:00:13'!
test09MamushkaPortfolioRegistersAllOfItsAccountsTransactions

	|componentPortfolio compositePortfolioAccountTransaction componentPortfolioAccount componentPortfolioAccountTransaction compositePortfolioAccount compositePortfolio componentPortfolioTransactions |
	
	componentPortfolio := Portfolio new.
	
	componentPortfolioAccount := ReceptiveAccount new.
	componentPortfolio add: componentPortfolioAccount.
	componentPortfolioAccountTransaction := Deposit register: 50 on: componentPortfolioAccount.
	
	compositePortfolioAccount := ReceptiveAccount new.
	compositePortfolioAccountTransaction := Withdraw register: 100 on: compositePortfolioAccount.	
	
	compositePortfolio := Portfolio with: compositePortfolioAccount.
	
	componentPortfolio add: compositePortfolio.
	
	componentPortfolioTransactions := componentPortfolio transactions.
	self assert: (componentPortfolioTransactions includes: compositePortfolioAccountTransaction).
	self assert: (componentPortfolioTransactions includes: componentPortfolioAccountTransaction).	
	self assert: componentPortfolioTransactions size equals: 2.
	! !


!PortfolioTest methodsFor: 'tests - extra' stamp: 'MP 11/11/2022 16:43:24'!
test10PortfolioCanNotAddTheSameAccountTwice

	|aPortfolio anAccount|
	
	aPortfolio := Portfolio new.
	anAccount := ReceptiveAccount new.
	
	aPortfolio add: anAccount .
	
	self should: [aPortfolio add: anAccount] raise: Error withExceptionDo: [:anError | 
		self assert: (anError messageText) equals: Portfolio canNotAddTheSameAccountTwiceErrorMessage.
		self assert: (aPortfolio accountsSize) equals: 1.
		].
		! !

!PortfolioTest methodsFor: 'tests - extra' stamp: 'MP 11/11/2022 16:45:22'!
test11CanNotAddAnAccountToAComponentPortfolioThatAlreadyIncludesThatAccountInItsSons

	|componentPortfolio anAccount compositePortfolio|
	
	componentPortfolio := Portfolio new.

	anAccount := ReceptiveAccount new.
	compositePortfolio := Portfolio with: anAccount.
	componentPortfolio add: compositePortfolio.
	
	self should: [componentPortfolio add: anAccount] raise: Error withExceptionDo: [:anError | 
		self assert: (componentPortfolio includesAccount: compositePortfolio).
		self assert: (componentPortfolio accountsSize) equals: 1.
		self assert: (anError messageText) equals: Portfolio canNotAddTheSameAccountTwiceErrorMessage.		
		].
		! !


!classDefinition: #ReceptiveAccountTest category: 'ServiciosFinancieros-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:10:43'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:14:20'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 * peso on: account.
		
	self assert: 100 * peso equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:14:24'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 * peso on: account.
	Withdraw register: 50 * peso on: account.
		
	self assert: 50 * peso equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:10:14'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50 * peso.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:10:22'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 * peso on: account.
	withdraw := Withdraw register: 50 * peso on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:12:14'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100 * peso.
	withdraw := Withdraw for: 50 * peso.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:12:23'!
test07AccountKnowsItsTransactions 

	| account deposit |
	
	account := ReceptiveAccount new.
	
	deposit := Deposit register: 50 * peso on: account.
		
	self assert: 1 equals: account transactions size.
	self assert: (account transactions includes: deposit).
! !


!classDefinition: #TransferTest category: 'ServiciosFinancieros-Ejercicio'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!TransferTest methodsFor: 'tests' stamp: 'MP 11/11/2022 16:49:07'!
test01ATransactionWithAnAmmountWhenBothAccountsAreZeroLeavesTheOriginWithTheAmmountNegativeAndTheDestinationWithThePositive

	| originAccount destinationAccount |
	
	originAccount := ReceptiveAccount new.
	destinationAccount := ReceptiveAccount new.
	 
	Transfer register: 100*peso from: originAccount to: destinationAccount.
		
	self assert: originAccount balance equals: -100*peso.
	self assert: destinationAccount balance equals: 100*peso.! !

!TransferTest methodsFor: 'tests' stamp: 'MP 11/6/2022 21:05:26'!
test02TransferLegsAreRegisteredInTheAccountTransactions

	| originAccount destinationAccount transfer|
	
	originAccount := ReceptiveAccount new.
	destinationAccount := ReceptiveAccount new.
	 
	transfer := Transfer register: 100*peso from: originAccount to: destinationAccount.
		
	self assert: (originAccount hasRegistered: transfer withdrawLeg).
	self assert: (destinationAccount hasRegistered: transfer depositLeg).! !

!TransferTest methodsFor: 'tests' stamp: 'MP 11/6/2022 21:07:57'!
test03DepositLegKnowsWithdrawLeg
	| transfer|
	
	transfer := Transfer for: 100*peso.

	self assert: transfer withdrawLeg equals: transfer depositLeg withdrawLeg.! !

!TransferTest methodsFor: 'tests' stamp: 'MP 11/6/2022 21:07:35'!
test04WithdrawLegKnowsDepositLeg
	| transfer|
	
	transfer := Transfer for: 100*peso.

	self assert: transfer depositLeg equals: transfer withdrawLeg depositLeg.! !

!TransferTest methodsFor: 'tests' stamp: 'MP 11/6/2022 21:09:50'!
test05AnAccountCanNotTransferToItself

	| originAccount |
	
	originAccount := ReceptiveAccount new.
	 
	self should: [Transfer register: 100*peso from: originAccount to: originAccount] 
	raise: Error
	withExceptionDo:[:anError | 
			self assert: originAccount transactionsIsEmpty.
			self assert: anError messageText equals: Transfer accountCanNotTransferToItselfErrorMessage.
		] .! !

!TransferTest methodsFor: 'tests' stamp: 'MP 11/6/2022 21:11:30'!
test06AnAccountCanNotTransferNegativeOrZeroValues

	| originAccount destinationAccount |
	
	originAccount := ReceptiveAccount new.
	destinationAccount := ReceptiveAccount new.
	 
	self should: [Transfer register: -10*peso from: originAccount to: destinationAccount] 
	raise: Error
	withExceptionDo:[:anError | 
			self assert: originAccount transactionsIsEmpty.
			self assert: anError messageText equals: Transfer accountCanNotTransferNegativeOrZeroErrorMessage.
		] .! !


!classDefinition: #Account category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Account methodsFor: 'main protocol' stamp: 'MP 11/11/2022 14:55:52'!
balance

	self subclassResponsibility.! !

!Account methodsFor: 'main protocol' stamp: 'MP 11/11/2022 14:55:45'!
hasRegistered: aTransaction

	self subclassResponsibility.! !

!Account methodsFor: 'main protocol' stamp: 'MP 11/11/2022 14:55:58'!
transactions

	self subclassResponsibility.! !


!classDefinition: #Portfolio category: 'ServiciosFinancieros-Ejercicio'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Portfolio methodsFor: 'initialization' stamp: 'MP 11/8/2022 20:58:43'!
initialize

	accounts := OrderedCollection new.! !

!Portfolio methodsFor: 'initialization' stamp: 'MP 11/8/2022 20:48:16'!
initializeWith: anAccount

	accounts := OrderedCollection with: anAccount.! !


!Portfolio methodsFor: 'main protocol' stamp: 'MP 11/11/2022 16:04:13'!
add: anAccount

	(self anyPortfolioIncludes: anAccount) ifTrue: [self error: self class canNotAddTheSameAccountTwiceErrorMessage].

	accounts add: anAccount.! !

!Portfolio methodsFor: 'main protocol' stamp: 'MP 11/8/2022 20:53:47'!
balance
	|totalBalance|
	totalBalance := 0.
	accounts do: [:anAccount | totalBalance := totalBalance + anAccount balance].
	^totalBalance.! !

!Portfolio methodsFor: 'main protocol' stamp: 'MP 11/10/2022 20:30:04'!
hasRegistered: aTransaction

	^accounts anySatisfy: [:anAccount | anAccount hasRegistered: aTransaction].! !

!Portfolio methodsFor: 'main protocol' stamp: 'MP 11/10/2022 21:33:00'!
transactions 
	|totalTransactions|
	totalTransactions := OrderedCollection new.
	accounts do:[:anAccount | totalTransactions addAllLast: anAccount transactions].
	^totalTransactions.! !


!Portfolio methodsFor: 'extra' stamp: 'MP 11/11/2022 15:10:38'!
accountsSize

	^accounts size.! !

!Portfolio methodsFor: 'extra' stamp: 'MP 11/11/2022 16:40:22'!
anyPortfolioIncludes: anAccount

	^accounts anySatisfy: [:aPortfolioSon | aPortfolioSon includesTheAccount: anAccount].! !

!Portfolio methodsFor: 'extra' stamp: 'MP 11/11/2022 15:52:41'!
includesAccount: anAccount

	^accounts includes: anAccount.! !

!Portfolio methodsFor: 'extra' stamp: 'MP 11/11/2022 16:39:15'!
includesTheAccount: anAccount

	^ self = anAccount or: 	[ accounts anySatisfy: [ :eachAccount | (eachAccount includesTheAccount: anAccount)]].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'ServiciosFinancieros-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'instance creation' stamp: 'MP 11/11/2022 15:13:26'!
with: anAccount

	^self new initializeWith: anAccount.! !


!Portfolio class methodsFor: 'error messages' stamp: 'MP 11/11/2022 15:12:28'!
canNotAddTheSameAccountTwiceErrorMessage

	^'cannot add the same account twice'! !


!classDefinition: #ReceptiveAccount category: 'ServiciosFinancieros-Ejercicio'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'main protocol' stamp: 'MP 11/6/2022 15:58:32'!
balance
	|aBalance|
	aBalance := 0.
	
	transactions do: [ :aTransaction | 		aBalance := aTransaction modifyBalance: aBalance		].
	
	^aBalance.! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'MP 11/6/2022 19:25:45'!
transactionsIsEmpty

	^transactions isEmpty.! !


!ReceptiveAccount methodsFor: 'extra' stamp: 'MP 11/11/2022 16:17:22'!
includesTheAccount: anAccount

	^self = anAccount.! !


!classDefinition: #AccountTransaction category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'MP 11/6/2022 15:58:31'!
modifyBalance: aBalance

	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'MP 11/6/2022 16:03:42'!
modifyBalance: aBalance

	^aBalance + value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'ServiciosFinancieros-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferLeg category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction subclass: #TransferLeg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!TransferLeg methodsFor: 'initialization' stamp: 'MP 11/6/2022 18:36:45'!
initializeAsLegOf: aTransfer

	transfer := aTransfer.! !


!TransferLeg methodsFor: 'value' stamp: 'MP 11/6/2022 18:36:50'!
value

	^transfer value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferLeg class' category: 'ServiciosFinancieros-Ejercicio'!
TransferLeg class
	instanceVariableNames: ''!

!TransferLeg class methodsFor: 'instance creation' stamp: 'MP 11/6/2022 18:37:38'!
asLegOf: aTransfer

	^self new initializeAsLegOf: aTransfer.! !


!classDefinition: #DepositLeg category: 'ServiciosFinancieros-Ejercicio'!
TransferLeg subclass: #DepositLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!DepositLeg methodsFor: 'balance' stamp: 'MP 11/6/2022 18:36:38'!
modifyBalance: aBalance

	^aBalance + self value! !


!DepositLeg methodsFor: 'legs' stamp: 'MP 11/6/2022 18:54:27'!
withdrawLeg

	^transfer withdrawLeg. ! !


!classDefinition: #WithdrawLeg category: 'ServiciosFinancieros-Ejercicio'!
TransferLeg subclass: #WithdrawLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!WithdrawLeg methodsFor: 'balance' stamp: 'MP 11/6/2022 18:36:23'!
modifyBalance: aBalance

	^aBalance - self value! !


!WithdrawLeg methodsFor: 'legs' stamp: 'MP 11/6/2022 18:54:36'!
depositLeg

	^transfer depositLeg.! !


!classDefinition: #Withdraw category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'MP 11/6/2022 16:03:34'!
modifyBalance: aBalance

	^aBalance - value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'ServiciosFinancieros-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Transfer category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #Transfer
	instanceVariableNames: 'value depositLeg withdrawLeg'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Transfer methodsFor: 'value' stamp: 'MP 11/6/2022 18:32:07'!
value

	^value! !


!Transfer methodsFor: 'legs' stamp: 'MP 11/6/2022 18:31:42'!
depositLeg

	^depositLeg! !

!Transfer methodsFor: 'legs' stamp: 'MP 11/6/2022 18:32:13'!
withdrawLeg

	^withdrawLeg! !


!Transfer methodsFor: 'initialization' stamp: 'MP 11/6/2022 18:32:01'!
initializeFor: aTransferValue

	value := aTransferValue.
	depositLeg := DepositLeg asLegOf: self.
	withdrawLeg := WithdrawLeg asLegOf: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'ServiciosFinancieros-Ejercicio'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'MP 11/11/2022 14:51:48'!
assertTransferValue: aTransferValue isPositiveAndThe: originAccount isNotThe: destinationAccount

	originAccount = destinationAccount ifTrue: [self error: self accountCanNotTransferToItselfErrorMessage].
	(aTransferValue >0) ifFalse: [self error: self accountCanNotTransferNegativeOrZeroErrorMessage ]! !

!Transfer class methodsFor: 'instance creation' stamp: 'MP 11/6/2022 18:38:20'!
for: aTransferValue.

	^self new initializeFor: aTransferValue.! !

!Transfer class methodsFor: 'instance creation' stamp: 'MP 11/11/2022 14:51:48'!
register: aTransferValue from: originAccount to: destinationAccount

	| transaction |
	
	self assertTransferValue: aTransferValue isPositiveAndThe: originAccount isNotThe: destinationAccount.
	
	transaction := self for: aTransferValue.
	originAccount register: transaction withdrawLeg.
	destinationAccount register: transaction depositLeg.
		
	^ transaction	.! !


!Transfer class methodsFor: 'error messages' stamp: 'MP 11/6/2022 20:40:39'!
accountCanNotTransferNegativeOrZeroErrorMessage

	^'An account can not transfer a zero or negative ammount'! !

!Transfer class methodsFor: 'error messages' stamp: 'MP 11/6/2022 19:27:09'!
accountCanNotTransferToItselfErrorMessage

	^'An account can not transfer to itself'! !
