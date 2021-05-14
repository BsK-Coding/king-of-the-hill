// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/* CONTRACT */
contract Ownable {
    
    /* STATE VARIABLES */
    address private _owner;                         //owner du Smart Contract (Start le Jeux avec une somme ETH)
    
    /* FUNCTIONS */
    
    // FUNCTION MODIFIERS
    modifier onlyOwner() {
        require(msg.sender == _owner, "Ownable: Only owner can call this function");
        _;
    }

    // FUNCTION PUBLIC
    function owner() public view returns(address) {
        return _owner;
    }
}