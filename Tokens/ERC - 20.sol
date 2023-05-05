// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20{
    string public  name;
    string public  symbol;
    uint8 public  decimals;
    uint256 public totalSupply;


    //mapping
    mapping(address => uint256) balances;
    mapping(address => mapping(address=>uint256)) allowance;

    //events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(string memory _name, string memory _symbol, uint256 _totalSupply){
        name=_name;
        symbol = _symbol;
        decimals = 18;
        totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }

}