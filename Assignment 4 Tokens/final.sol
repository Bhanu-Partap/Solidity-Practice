// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract finaL is ERC721{
    struct itemD{
        string name;
        uint256 lastBid;
        uint256 highestBid;
        address highestBider;
        address lastHighestBider;
        uint256 auction_time;
    }
        address payable public auctioneer;

        // mapping
        mapping(address => mapping(uint256 =>itemD)) public itemDetails;

        // events
        event Createitem(address owner,uint id,string name, string description);
        event Bid(address _address, uint256 _bidamount);
        event transfer(address _from, address _to, itemD  _item);
    
    function createItem(uint256 id, string memory _name) public {
        itemDetails[msg.sender][id].name=_name;
        itemDetails[msg.sender][id].lastBid=0;
        itemDetails[msg.sender][id].hiighestBid=0;
        itemDetails[msg.sender][id].highestBider=address(0);
        itemDetails[msg.sender][id].lastHighestBider=address (0);
        itemDetails[msg.sender][id].auction_time=block.timestamp + 120;


        
    }

    function placeBid(uint256 id)public payable  {
        itemDetails[msg.sender][id] = ;
    }

    function getHighestBid(address _bidder,uint256 _amount)public {
        
    }

    function getWinningBidder(address _bidder,uint256 _amount)public {
        
    }

    function cancelAuction(address _bidder,uint256 _amount)public {
        
    }

    function ownershipTransfer(address _bidder,uint256 _amount)public {
        
    }
}