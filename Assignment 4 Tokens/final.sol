// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC-20.sol";
import "./ERC-721.sol";
import "./ERC-1155.sol";


contract finaL  {

 ERC20Basic a;
 MyToken b;
 ERC1155MYTOKEN c;

    
    struct itemD{
        string name;
        uint256 id;
        address owner;
        uint256 lastBid;
        uint256 highestBid;
        address highestBider;
        uint256 auction_time;
        address lastHighestBider;
    }
    uint itemID =1;

    struct listItem{
        uint256 id;
        uint256 listedItemPrice;
        address addr;
        string nft_type;
    }

        // mapping
        mapping(uint => itemD) public itemDetails;
        mapping(uint => listItem) public ListItem;

        // events
        event createItem(address owner,uint id,string name);
        event Bid(address _address, uint256 _bidamount);
        event transfer(address _from, address _to, itemD  _item);
    
    function CreateItem( string memory _nft_type, address _addr, uint256 _listedItemPrice, uint256 id) public {
        require(msg.sender != address(0) ,"Not Valid");
       if(){

        ListItem[id].nft_type = _nft_type;
        ListItem[id].addr = _addr;
        ListItem[id].listedItemPrice = _listedItemPrice;
       }
       else{
           
       }

        
    }




    function placeBid(uint256 id) public payable  {
        require(itemDetails[id].owner != msg.sender," owner can't bid");
        require(itemDetails[id].auction_time > block.timestamp,"not started yet");
        require(msg.value >= itemDetails[id].lastBid, "Increase the Amount");
        itemDetails[id].lastBid=itemDetails[id].highestBid;
        itemDetails[id].lastHighestBider=itemDetails[id].highestBider;
        itemDetails[id].highestBid=msg.value;
        itemDetails[id].highestBider=msg.sender;
        payable(itemDetails[id].lastHighestBider).transfer(itemDetails[id].lastBid);
        emit Bid(msg.sender, msg.value);

    }

    function getHighestBid( uint256 id) public view returns(uint256) {
        return itemDetails[id].highestBid;
    }

    function getWinningBidder(uint256 id) public view returns(address){
        return itemDetails[id].highestBider;
    }

    function cancelAuction( uint256 id) public  {
        require(msg.sender == itemDetails[id].owner," Only Owner can cancel the Auction");
        payable (itemDetails[id].highestBider).transfer(itemDetails[id].highestBid);
        delete itemDetails[id];

    }

    function auctionEnd(uint256 id) public payable {
        require(block.timestamp > itemDetails[id].auction_time);
        require(msg.sender == itemDetails[id].owner, " Onle The owner of the Item can access.");
        payable(itemDetails[id].owner).transfer(itemDetails[id].highestBid);
        itemDetails[id].owner= itemDetails[id].highestBider;
        delete itemDetails[id];
    }

}