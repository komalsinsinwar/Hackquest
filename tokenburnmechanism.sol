//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DeflationaryToken {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    string public name = "DeflationaryToken";
    string public symbol = "DFT";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 * (10 ** uint256(decimals));
    
    address public owner;
    uint256 public burnRate = 2; // 2% burn per transfer

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        
        uint256 burnAmount = (amount * burnRate) / 100;
        uint256 sendAmount = amount - burnAmount;
        
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += sendAmount;
        totalSupply -= burnAmount;
        
        emit Transfer(msg.sender, to, sendAmount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(allowance[from][msg.sender] >= amount, "Allowance exceeded");

        uint256 burnAmount = (amount * burnRate) / 100;
        uint256 sendAmount = amount - burnAmount;

        balanceOf[from] -= amount;
        balanceOf[to] += sendAmount;
        totalSupply -= burnAmount;
        allowance[from][msg.sender] -= amount;

        emit Transfer(from, to, sendAmount);
        return true;
    }
}
