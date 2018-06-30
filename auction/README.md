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
