pragma solidity 0.4.25;

contract dbvn {
    
    struct Users {
        
        uint8 role;
        uint weight;
        
    }
    
    uint total_weight = 0;
    
    mapping(address => Users) public users;
    
    address[] public users_array;
    
    struct Votes {
        
        uint choice;
        
    }
    
    
    struct Assets {
        
        uint8 status;
        string name;
        uint funds;
        address request_target;
        uint request_asset;
        uint request_amount;
        uint vote_id;
        uint vote_yes;
        uint vote_no;
        
        mapping(address => uint) votes;
    
    }
    
    uint assets_key = 0;
    mapping(uint => Assets) public assets;
    
    constructor (uint _weight) public {
    
        users[msg.sender].role = 1;
        users[msg.sender].weight = _weight;
        
        users_array.push(msg.sender);
        
        total_weight += _weight;
        
    }
    
    function add_user(address _new_user, uint8 _role, uint _weight) public{
        
        /* Only owner can add new users */
        
        require( 
        
            (
                
               users[msg.sender].role == 1 && _role < 4 
             
            )
            
        );
        
        require( users[_new_user].role != 1 && users[_new_user].role != 2 && users[_new_user].role != 3);
       
        users[_new_user] = Users({ role: _role, weight : _weight });
        
        total_weight += _weight;
        
        users_array.push(_new_user);
       
      
    }
    
    function remove_user(address _user) public{
        
        require( 
        
            (
                
               users[msg.sender].role == 1 
             
            )
            
        );
        
        total_weight -=  users[_user].weight;
        
        users[_user].role = 0;
        users[_user].weight = 0;
        
    }
    
    function change_user(address _user, uint8 _role, uint _weight ) public{
        
       require( 
        
            (
                
               users[msg.sender].role == 1 && _role < 4
             
            )
            
        );
        
        require(users[_user].role == 1 || users[_user].role == 2 || users[_user].role == 3);
        
        if(users[_user].weight != _weight){
            
            total_weight -=  users[_user].weight;
            total_weight +=  _weight;
            
            users[_user].weight = _weight;
        
        }
        
        if(users[_user].role != _role){
            
            users[_user].role = _role;
            
        }
        
    }
    
    function create_asset(
        
        uint8 _status,
        string _name,
        address _request_target,
        uint _request_asset,
        uint _request_amount
        
    ) public payable{
        
        require( 
        
            (
                
               users[msg.sender].role == 1 ||  users[msg.sender].role == 2 
             
            )
            
        );
        
        require( _status == 1 || _status == 2 );
        
        assets[assets_key].status = _status;
        assets[assets_key].name = _name;
        assets[assets_key].funds = msg.value;
        assets[assets_key].request_target = _request_target;
        assets[assets_key].request_asset = _request_asset;
        assets[assets_key].request_amount = _request_amount;
        assets[assets_key].vote_id = 0;
        assets[assets_key].vote_yes = 0;
        assets[assets_key].vote_no = 0;
        
        assets_key++;
        
    }
    
    function change_asset( uint _asset_key, uint8 _status, string _name ) public{
        
        require( 
        
            (
                
               users[msg.sender].role == 1 ||  users[msg.sender].role == 2 
             
            )
            
        );
        
        require (  assets[_asset_key].status == 1 ||  assets[_asset_key].status == 2 );
        
        
        if( assets[_asset_key].status != _status ){
            
            assets[_asset_key].status = _status;
            
        }
        
        assets[_asset_key].name = _name;
        
    }
    
    function request_funds(uint _asset_key, uint _request_amount, address _request_target, uint _request_asset ) public payable{
        
        require (  assets[_asset_key].status == 1 );
        
        require (  assets[_asset_key].funds <= _request_amount );
        
        require( 
        
            (
                
               users[msg.sender].role == 1 ||  users[msg.sender].role == 2 
             
            )
            
        );
        
        assets[_asset_key].status = 3;
        assets[_asset_key].request_target = _request_target;
        assets[_asset_key].request_asset = _request_asset;
        assets[_asset_key].request_amount = _request_amount;
        assets[assets_key].vote_id = 0;
        assets[assets_key].vote_yes = 0;
        assets[assets_key].vote_no = 0;
        
        /* Loop through the voting mapping */
        
        uint users_length = users_array.length;
        
        for (uint i=0; i< users_length; i++) {
            
            assets[assets_key].votes[users_array[i]] = 0;
            
        }
        
        
    }
    
    function send_fund(uint _asset_key) public payable{
        
       require (  assets[_asset_key].status == 1 );
        
       assets[_asset_key].funds += msg.value;
        
    }
    
    function cast_vote(uint _asset_key, uint8 _vote) payable{
        
       require (  assets[_asset_key].status == 3 );
       
       require ( _vote == 1 || _vote == 2 );
       
       require( 
        
            (
                
               users[msg.sender].role == 1 ||  users[msg.sender].role == 2  ||  users[msg.sender].role == 3 
             
            )
            
        );
        
       require ( assets[_asset_key].votes[msg.sender] != 1 );
       
       if( _vote == 1){
           
            assets[_asset_key].vote_yes += users[msg.sender].weight;
          
       }else if(_vote == 2){
           
            assets[_asset_key].vote_yes += users[msg.sender].weight;
           
       }
       
       assets[_asset_key].votes[msg.sender] = 1;
       
       uint flag = 0;
           
       if(assets[_asset_key].vote_yes >= ( total_weight / 2 ) ){
           
           // release funds
           
           if(assets[_asset_key].request_target != 0){
               
               // transfer fund to another address
               
               assets[_asset_key].request_target.send(assets[_asset_key].request_amount);
               assets[_asset_key].funds -= assets[_asset_key].request_amount;
                   
             
           }else{
               
               if(assets[_asset_key].request_asset != 0){
                   
                   // transfer fund to a different asset
                   
                   assets[assets[_asset_key].request_asset].funds += assets[_asset_key].request_amount;
                   
                   assets[_asset_key].funds -= assets[_asset_key].request_amount;
                   
               }
               
           }
           
           flag = 1;
           
       }else if(assets[_asset_key].vote_no >= ( total_weight / 2 ) ){
           
           // cancel vote
           
           flag = 1;
           
       }
       
       if(flag == 1){
           
           // clear the vote
           
            uint users_length = users_array.length;
            
            for (uint i=0; i< users_length; i++) {
                
                assets[assets_key].votes[users_array[i]] = 0;
                
            }
            
            assets[assets_key].status = 1;
            assets[assets_key].request_amount = 0;
            assets[assets_key].request_target = 0;
            assets[assets_key].request_asset = 0;
           
       }
       
    }
    
}
