// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract finaL {
    struct auction{
        uint256 amount;
        address owner;
        uint256 lastbid;
        uint256 highbid;
        address highbider;
        address lasthigherbider;
        uint256 auction_time;
        string _nft_type;
    }

    constructor(string memory name, string memory symbol) ERC721(name, symbol){

    }

}