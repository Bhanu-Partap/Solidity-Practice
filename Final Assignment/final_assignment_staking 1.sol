// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ERC-20.sol";


contract Staking {

    ERC20Basic Token;

     constructor(ERC20Basic _addressERC20 ){
        Token=_addressERC20;
    }

}