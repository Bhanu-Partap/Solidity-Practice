// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ERC-20.sol";


contract Staking_Token {

    ERC20Basic Token;

     constructor(ERC20Basic _addressERC20 ){
        Token=_addressERC20;
    }

    struct Stake{
        uint stake_amount;
        uint stake_reward;
        string stake_type;
        uint stake_time;
    }

}