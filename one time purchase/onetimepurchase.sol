pragma solidity ^0.4.8;

contract onetimepurchase
{
   
    address buyer;
    address seller;
    address mediator;
    address future_mediator;
    address future_seller;
    address future_buyer;
    
    uint mediator_fee;
    uint future_fee;
    uint mediation_invoked;
    uint mediator_aproved;
    uint seller_aproved;
    uint buyer_aproved;
    
    uint status;
    uint price;
    
    constructor(address _buyer, address _seller, address _mediator, uint _mediator_fee, uint _price) public payable{
        
        require( 
                ( _seller == msg.sender ) 
                ||
                ( _buyer == msg.sender )
            );
        
        status = 1;
        
        buyer = _buyer;
        seller = _seller;
        mediator = _mediator;
        mediator_fee = _mediator_fee;
        mediation_invoked = 0;
        
        mediator_aproved = 0;
        
        price = _price;
       
    }
    
    function deposit() payable public{
        
        require(seller == msg.sender);
        
    }
    
    function check_balance() public returns(uint){
        
        return this.balance;
        
    }
    
    function change_buyer(address _future_buyer) public{
        
        require(buyer == msg.sender);
        require(buyer_aproved == 1);
        require(status == 1);
        
        future_buyer = _future_buyer;
        buyer_aproved = 1;
        
    }
    
    function aprove_buyer() public{
        
        require(seller == msg.sender);
        require(buyer_aproved == 1);
        require(status == 1);
        
        buyer = future_buyer;
        
        buyer_aproved = 0;
        
    }
    
    function change_seller(address _future_seller) public{
        
        require(buyer == msg.sender);
        require(seller_aproved == 1);
        require(status == 1);
        
        future_seller = _future_seller;
        
        seller_aproved = 1;
        
    }
    
    function aprove_seller() public{
        
        require(seller == msg.sender);
        require(seller_aproved == 1);
        require(status == 1);
        
        seller = future_seller;
        
        seller_aproved == 0;
        
    }
    
    function set_mediator(address _mediator, uint _mediator_fee) public{
        
        require(buyer == msg.sender);
        require(status == 1 || status == 2);
        
        future_mediator = _mediator;
        future_fee = _mediator_fee;
        mediator_aproved = 1;
        
    }
    
    function aprove_mediator() public{
        
        require(seller == msg.sender);
        require(mediator_aproved == 1);
        require(status != 3);
        
        mediator = future_mediator;
        mediator_fee = future_fee;
        
        mediator_aproved = 0;
        
    }
    
    function complete_contract() public{
        
        require(buyer == msg.sender);
        require(status == 1);
        require( this.balance >= ( price + mediator_fee ) );
        
        seller.transfer(price);
        
        if(mediation_invoked == 1){
            
            mediator.transfer(mediator_fee);
            
        }
        
        status = 3;
    
    }
    
    function withdraw() public{
        
        require(buyer == msg.sender);
        require(status == 3);
       
        buyer.transfer(this.balance);
       
    }
    
    /// MEDIATION
    
    function invoke_mediation() public{
        
        require(buyer == msg.sender || seller == msg.sender);
        require(status == 1);
        
        status = 2;
        
        mediation_invoked = 1;
        
    }
    
    function mediation_complete_contract(uint _seller_fee, uint _buyer_fee) public{
     
        require(status == 2);
        require(msg.sender == mediator);
        require( ( _seller_fee + _buyer_fee ) == price );
        require( this.balance >= ( price + mediator_fee ) );
        
        seller.transfer(_seller_fee);
        buyer.transfer(_buyer_fee);
        mediator.transfer(mediator_fee);
        
        status = 3;
        
    }
    
    function mediation_change_buyer(address _buyer) public{
     
        require(status == 2);
        require(msg.sender == mediator);
        
        buyer = _buyer;
        
    }
    
    function mediation_change_seller(address _seller) public{
     
        require(status == 2);
        require(msg.sender == mediator);
        
        seller = _seller;
        
    }
    
    function mediation_change_price(uint _price) public{
     
        require(status == 2);
        require(msg.sender == mediator);
        
        price = _price;
        
    }
    
    function mediation_end() public{
     
        require(status == 2);
        require(msg.sender == mediator);
        
        status = 1;
        
    }
 
}