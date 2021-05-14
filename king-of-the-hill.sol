// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/* IMPORT STATEMENTS */
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";
//import "./Ownable.sol";                    //Je commente car l'héritage ne passe pas lorsque je l'utilise pour faire redescendre mes props du owner.

/* CONTRACT */
contract KingOfTheHill {
    
    // library usage
    using Address for address payable;
    
    /* STATE VARIABLES */
    mapping(address => uint256) private _balances;              //Solde du Smart Contract
    mapping(address => uint256) private _pot;                   //Pot dans le Smart Contract => address(this).balance - msg.value
    address private _owner;                                     //owner du Smart Contract (Start le Jeux avec une somme ETH)
    address private _ownerPot;                                  //owner du Pot (celui qui entre avec _pot*2), gagne 80% du pot
    uint256 private _offer;
    uint256 private _seed;                                      //10% du _pot

    /* EVENTS */
    event Offered(address indexed sender, uint256 value);
    
    /* CONSTRUCTOR */
    constructor(address ownerPot_, uint256 pot_) payable {
        _ownerPot = ownerPot_;
        _pot = pot_;
    }
    
    /* FUNCTIONS */
    
    // FUNCTION MODIFIERS
    modifier onlyOwner() {
        require(msg.sender == _owner, "Ownable: Only owner can call this function");
        _;
    }
    modifier ownerPot() {
        require(msg.value >= address(this).balance * 2, "KingOfTheHill: The offer must be greater than 2 pot");
        _;
    }
    
    modifier blockTimer() {
        require(block.number <= 15, "KingOfTheHill: block already finished !");
        _;
    }
    
    // FUNCTION RECEIVE/FULLBACK
    receive() external payable {                                //Transmet un montant en ETH (msg.value) du Wallet vers un "Pot" dans notre Smart Contract 
        _offer(msg.sender, msg.value);                          
    }
    
    // FUNCTION EXTERNAL
    function offer() external payable ownerPot {                         //Envoie "offer_" = msg.value dans "_offer" = msg.sender => Wallet vers Smart contract
        emit _offer(msg.sender, msg.value);
    }
    
    // FUNCTION PUBLIC
    function balanceOf(address account) public view onlyOwner returns (uint256) {     //Affichera le solde du Smart Contract
        return _balances[account];
    }
    
     function ownerBal() public view returns (uint256) {            //Affichera le solde du owner qui à deploy le Smart Contract
        return _balances[_owner];
    }
    
     function ownerPotBal() public view returns (uint256) {         //Affichera le solde du ownerPot Leader de la partie
        return _pot[_ownerPot];
    }
    
    // FUNCTION INTERNAL
    
    // FUNCTION PRIVATE
    function _offerForPot(address sender, uint256 amount) private {       //Incrémentera le solde du Smart contract du montant passé en offer
        _balances[sender] += amount;
        emit Offered(sender, amount);
    }
}