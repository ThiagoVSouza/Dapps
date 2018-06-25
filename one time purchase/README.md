# DAPP : One time purchase

This dapp can be used by individuals willing to trade a product or service with a one time payment in ether.

## Dapp Deployment

When you deploy this Dapp you can provide 5 optional parameters:

```
constructor(address _buyer, address _seller, address _mediator, uint _mediator_fee, uint _price) public payable
```

**Parameters:**

* _buyer : *the address of the user that will pay the price for the good or service*
* _seller : *the address of the user who will receive the payment*
* _mediator : *the address of the user that will be the mediator*
* _mediator_fee : *the fee in ether that will be payed to the mediator in case it is requested*
* _price : *the amount of ether that will be paid by the buyer to the seller at the contract conclusion.*

**Notes:**

It is a requirement for the deployment to be successful that the user deploying the Dapp must also be the buyer or the seller. 
Optionally the Dapp can be deployed with all the ether that will be used to pay the seller and the mediator fee.
In case the ether is not provided on the deployment it is possible to send ether to the contract by using the function deposit().
In the initial configuration the status of the contract is set  to 1 (active). Other status are 2 (when the contract is under mediation) and 3 (when the contract has been completed).

## Deposit

It is possible to send ether via this function.

```
function deposit() payable public
```

**Notes:**

Any user can send ether to this contract.
This function can also be used when there's a request to increase the price before the end of the contract.
Real life example: The buyer requested a service to be made but after the seller had started he requested additional changes to the service that would add more cost.
As a result of this change the seller may request an increase in the final price.
If the buyer refuses to pay the price surcharge any of the users can invoke a mediation using the invoke_mediation function.
The mediation process is explained in that function notes.

## Check Balance

Used to retrieve the current amount of ether in the contract

```
function check_balance() public returns(uint)
```

**Notes:**

This function will return the ammount of ether in the contract.

## Change Buyer

Function used to change the buyer

```
function change_buyer(address _future_buyer) public
```

**Parameters:**

* _future_buyer : *the address of the new buyer of the contract*

**Notes:**

This function can only be invoked by the seller. In order to complete the change the buyer must approve this by using the aprove_buyer function.
The status of the contract must be 1 (active).

## Aprove Buyer

Function used to conclude the change in the buyer address

```
function aprove_buyer() public
```

**Notes:**

This function can only be used by the buyer and the status of the contract must be 1 (active).


## Change Seller

Function used to change the seller

```
function change_seller(address _future_seller) public
```

**Parameters:**

* _future_seller : *the address of the new seller of the contract*

**Notes:**

This function can only be invoked by the seller. In order to complete the change the buyer must approve this by using the aprove_seller function.
The status of the contract must be 1 (active).

## Aprove Seller

Function used to conclude the change in the seller address

```
function aprove_seller() public
```

**Notes:**

This function can only be used by the buyer and the status of the contract must be 1 (active).

## Change Mediator

Function used to change the mediator

```
function set_mediator(address _mediator, uint _mediator_fee) public
```

**Parameters:**

* _mediator : *the address of the new owner of the contract*
* _mediator_fee : *the amount of ether that will be paid to the mediator in case the mediation is invoked*

**Notes:**

This function can only be invoked by the contract owner. In order to complete the change the other party in the contract (seller or buyer) must approve this by using the aprove_mediation function.
The status of the contract cannot be 3 (completed).
This option can also be used during the mediation if both the seller and buyer agree that the mediator is either unresponsive or failing in his job.

## Aprove Mediator

Function used to conclude the change in the mediator address

```
function aprove_mediator() public
```

**Notes:**

This function can only be used by the other party in the contract following a call by the owner of the change_meditor function.

## Complete contract

Ends the contract and release the payment to the seller and the fee of the mediator

```
function complete_contract() public
```

**Notes:**

This function may only be invoked by the buyer when he is satisfied and the purchase of the product or service is completed.
Also as a requirement the contract balance must be equal or more than the price and the mediator_fee combined.
The fee to the mediator is only sent if mediation is invoked in any time during the Dapp execution.
If the fee is not used, the ether left can be recovered with the withdraw function.

## Withdraw

Function used to retrieve all ether left on the Dapp

```
function withdraw() public
```

**Notes:**

Only the buyer can use this function. 
The contract also must be with the status as concluded (status = 3).

## Invoke Mediation

Function used to start a mediation

```
function invoke_mediation() public
```

**Notes:**

Mediation can be invoked only by the seller or the owner and when the contract is active (status = 1).
By enabling mediation all functions associated with mediation will become available to the mediator.
Also after calling this function for the first time the mediator will receive the mediator_fee on the conclusion of the contract.

## Mediation: complete contract

This function can be called by the mediator to complete the contract

```
function mediation_complete_contract(uint _seller_fee, uint _buyer_fee) public
```

**Parameters:**

* _seller_fee : *amount in ether to be sent to the seller*
* _buyer_fee : *amount in ether to be sent to the buyer*

**Notes:**

Only the mediator may call this function when the contract is under mediation (status = 2).
The amount of ether informed as the seller_fee and the _buyer_fee must be equal to the price.
If necessary the mediator may call the change_price function to adjust the amount he believes is fair for both parties.
Calling this function will result in the contract ending and the ether beeing sent to both the seller. Also the mediator will receive the mediator_fee.
The contract status will then change to complete (status = 3), enabling the buyer to withdraw any ehter left using the withdraw function.

## Mediation: change buyer

Function to change the buyer buy the mediator

```
function mediation_change_buyer(address _buyer) public
```

**Parameters:**

* _buyer : *address of the new buyer*

**Notes:**

Only the mediator may call this function when the contract is under mediation (status = 2).
This function does not end the mediation. The mediation_end function must be called for the contract to be resumed (status = 1) 
Real case example: The change of the buyer may be necessary when he is no longer interested in buying the product.

## Mediation: change seller

Function to change the seller buy the mediator

```
function mediation_change_seller(address _seller) public
```

**Parameters:**

* _seller : *address of the new seller*

**Notes:**

Only the mediator may call this function when the contract is under mediation (status = 2).
This function does not end the mediation. The mediation_end function must be called for the contract to be resumed (status = 1) 
Real case example: The change of the seller may be necessary when he is no longer interested in selling the product.

## Mediation: change price

Function to change the price of the contract

```
function mediation_change_price(uint _price) public
```

**Parameters:**

* _seller : *address of the new seller*

**Notes:**

Only the mediator may call this function when the contract is under mediation (status = 2).
This function does not end the mediation. The mediation_end function must be called for the contract to be resumed (status = 1) 
This function is usefull to adjust the price of the contract either to reduce or increase.
It can also be used to impose penalties to faulty parties.
For example: the seller did provide the product but not 100% as agreed, as a result the buyer may request that a penaltie be imposed for this fault.

## Mediation: end mediation

Function to end the mediation process

```
function mediation_end() public
```

**Notes:**

Only the mediator may call this function when the contract is under mediation (status = 2).
this function returns the contract to active (status = 1)