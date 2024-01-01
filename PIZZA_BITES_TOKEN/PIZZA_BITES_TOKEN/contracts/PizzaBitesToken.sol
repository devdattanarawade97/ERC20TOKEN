// SPDX-License-Identifier: MIT

pragma solidity >=0.8.20;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
  PizzaBitesToken is a blockchain-based digital currency designed for use within the
 PizzaBites restaurant ecosystem, facilitating secure and transparent transactions for virtual pizza purchases.

**/
contract PizzaBitesToken is ERC20, AccessControl {

    //variables
    //@notice role name for minter address
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE"); 
    //@notice role name for burner address
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
     //@notice role name for spend allowancer address
    bytes32 public constant SPEND_ALLOWANCER = keccak256("SPEND_ALLOWANCER");

    //@notice logs the transaction events
    event tokenPurchaseLogs(address, string);
    //@notice  logs for minted coins
    event tokenMintLogs(address, string, uint256);
    
    //@notice keeps the record  token for individual address
    mapping(address => uint256) public tokenBalanceLeadger;


// constructor
    constructor()
        ERC20("PizzaBitesToken", "PBT")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());
        _grantRole(BURNER_ROLE, _msgSender());
        _grantRole(SPEND_ALLOWANCER, _msgSender());
    }

    //@notice only minter can creates the tokens to receiver address
    //@params _to is token receiver address , amount is number of tokens to be minted to receiver address
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        require(to!=address(0),"Invalid Spender Address" );
        
        _mint(to, amount*10**decimals());
        tokenBalanceLeadger[to]=amount*10**decimals();
        emit tokenMintLogs(to, "token minted Successfully to Account", amount);
    }
   
    //@notice 
    function buyPizza(uint256 numOfPizza)  external  {
        // require(tokenBalanceLeadger[_msgSender()]>=numOfPizza*10**decimals() , "Insufficent Balance");
        require(numOfPizza%1==0, "invalid Pizza count");
        _burn(_msgSender(), numOfPizza*10**decimals());
        emit tokenPurchaseLogs(_msgSender(), "Pizza Purchased Successfully");
    }
     

  //@notice spender can spend the allowed token to the receiver address
    //@params _spender is token sender address, _value is number of tokens, _to is token receiver address
    function spendAllowance(address _spender, uint256 _value, address _to) public onlyRole(SPEND_ALLOWANCER) {
        require(_spender!=address(0),"Invalid Spender Address" );
        require(_to!=address(0),"Invalid Receiver Address" );
        
        _spendAllowance(_msgSender(), _spender, _value*10**decimals());
        _transfer(_spender, _to, _value*10**decimals());
    }
 


}