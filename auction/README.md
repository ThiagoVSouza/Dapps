# DAPP: Auction

## Overview

This app is designed to provide an auction system, where one user can sell a product or service to the highest bidder.

## Deployment

When you deploy this Dapp you must provide 3 parameters:

```
constructor(address _mediator, uint _mediator_fee, uint _max_bid) public payable
```

**Parameters:**

* _mediator : *the address of the user that will be the mediator*
* _mediator_fee : *the fee that the mediator will receive in case a mediation happens*
* _max_bid : *the maximun bid that can conclude the auction*

**Notes:**

The Dapp can be deployed with all the ether that will be used to pay the mediation fee.
In case the ether is not provided on the deployment it is possible to send ether to the contract by using the function deposit().
In the initial configuration the status of the contract is set  to 1 (active). Other status are 2 (when the contract is under mediation) and 3 (when the contract has been completed).
The _max_bid can be set to 0 if there's no desire to set a maximun bid.

## Check Balance

This function can be called to check how much ether the Dapp holds.

```
function check_balance() public returns(uint)
```

## Deposit

It is possible to send ether via this function.

```
function deposit() payable public
```

**Notes:**

Any user can send ether to this contract.
This function can be used when there's a need for sending ether to complete the mediator fee.

## Change the Seller

Method used to change the seller

```
function change_seller(address _future_seller) public
```

**Parameters:**

* _future_seller : *the address of the new seller of the contract*

**Notes:**

This method essentially transfer the ownership if the Dapp to a different address.

## Change the Mediator

This function can be used to change the address of the mediator

```
function change_mediator(address _future_mediator, uint _future_fee) public
```

**Parameters:**

* _future_mediator : *the address of the new mediator of the contract*
* _future_fee : *the amount of ether that will be paid to the mediator in case the mediation is invoked*

**Notes:**

This function can only be invoked by the contract seller. In order to complete the change the other party in the contract (current highest bidder) must approve this by using the aprove_mediation function.
The status of the contract cannot be 3 (completed).
This option can also be used during the mediation if both the seller and current bidder agree that the mediator is either unresponsive or failing in his job.

## Aprove the Mediator

Function used to conclude the change in the mediator address

```
function aprove_mediator() public
```

**Notes:**

This function can only be used by the current highest bidder.

## Bid

Function used to bid in the Dapp

```
function bid() public payable
```

**Notes:**

The bid must be higher then the current highest bid.
When the bid is valid, the ether stored by the last bidder is sent back to him.
If there's a maximum bid set, then the contract can be completed by the bidder by using the confirm_bid function.

## Get highest Bid

This function can be use to retrieve the current highest bid in place.

```
function get_highest_bid() public returns(uint)
```

**Notes:**

This function returns the current bid in ether.

## Accept Bid

This function can be used by the seller to accept current bid

```
function accept_bid() public{
```

**Notes:**

Only the seller can use this function. It is used to accept the current bid in order to complete the contract
In order to complete the auction the bidder has to confirm his bid by using the confirm_bid function.

## Confirm Bid

Function used to complete the auction

```
function confirm_bid() public

```

















