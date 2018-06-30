pragma solidity ^0.4.8;

contract auction
{
   
    	address seller;
    	address bidder;
   	address mediator;
    
	address future_mediator;
    
	uint mediator_fee;
    	uint future_fee;
    	uint mediation_invoked;
    	uint mediator_aproved;

	
	uint current_bid;
	uint max_bid;
	uint status;
	uint end_auction;
	
	
    	constructor(address _mediator, uint _mediator_fee, uint _max_bid) public payable{
    
	    seller = msg.sender;
	    
	    status = 1;
	    
	    mediator = _mediator;
	    mediator_fee = _mediator_fee;
	    max_bid = _max_bid;
	
    	}
	
    	function check_balance() public returns(uint){
        
        	return this.balance;
        
    	}
    
    	function deposit() payable public{
        
        	require(status != 3);
        
    	}
	
    	function change_seller(address _future_seller) public{
        
		require(seller == msg.sender);
		require(status == 1);

		seller = _future_seller;

	}
	
	function change_mediator(address _future_mediator, uint _future_fee) public{
        
		require(seller == msg.sender);
		require(status == 1 || status == 2);

		future_mediator = _future_mediator;
		future_fee = _future_fee;
		mediator_aproved = 1;
        
    	}
	
    	function aprove_mediator() public{
        
		require(bidder == msg.sender);
		require(mediator_aproved == 1);
		require(status != 3);

		mediator = future_mediator;
		mediator_fee = future_fee;

		mediator_aproved = 0;

    	}
	
	/// Bid
	
	function bid() public payable{
    
	    require(status == 1);
	    require(msg.value > current_bid);
	    
	    bidder.transfer(current_bid);
	    
	    current_bid = msg.value;
	    bidder = msg.sender;
	    
	    if(max_bid != 0){
	        
	        if(msg.value >= max_bid){
	            
	            end_auction = 1;
	            
	        }
	        
	    }
	    
	}
	
	function accept_bid() public{
    
		require(seller == msg.sender);
		require(status == 1);
		require( this.balance >= ( current_bid + mediator_fee ) );

	    	end_auction = 1;
	    
	}
	
	function confirm_bid() public{
    
		require(bidder == msg.sender);
		require(status == 1);
		require(end_auction == 1);
		require( this.balance >= ( current_bid + mediator_fee ) );

		seller.transfer(current_bid);
        
		if(mediation_invoked == 1){

		    mediator.transfer(mediator_fee);

		}
        
		status = 3;

		end_auction == 0;
		
	}
	
	function withdraw() public{
        
		require(seller == msg.sender);
		require(status == 3);

		seller.transfer(this.balance);
       
    	}
		
	// MEDIATION
	
	function invoke_mediation() public{
        
		require(seller == msg.sender || bidder == msg.sender);
		require(status == 1);
		require( this.balance >= ( current_bid + mediator_fee ) );

		seller.transfer(current_bid);

		if(mediation_invoked == 1){

		    mediator.transfer(mediator_fee);

		}

		status = 2;

		mediation_invoked = 1;

	}
    
    	function mediation_end_auction(uint _seller_fee, uint _bidder_fee) public{
     
		require(status == 2);
		require(msg.sender == mediator);
			require( this.balance >= ( _seller_fee + _bidder_fee + mediator_fee ) );


		seller.transfer(_seller_fee);
		bidder.transfer(_bidder_fee);
		mediator.transfer(mediator_fee);

		status = 3;
        
    	}
	
	function mediation_remove_bidder() public{
     
		require(status == 2);
		require(msg.sender == mediator);

		bidder = 0x0;
		current_bid = 0;
        
    	}
	
	function mediation_end() public{
     
		require(status == 2);
		require(msg.sender == mediator);

		status = 1;
        }
	
 }
