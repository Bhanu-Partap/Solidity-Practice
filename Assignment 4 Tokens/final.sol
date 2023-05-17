// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract finaL  {
    struct itemD{
        string name;
        address owner;
        uint256 lastBid;
        uint256 highestBid;
        address highestBider;
        uint256 auction_time;
        address lastHighestBider;
    }
    uint itemID =1;


        // mapping
        mapping(uint => itemD) public itemDetails;


        // events
        event createItem(address owner,uint id,string name);
        event Bid(address _address, uint256 _bidamount);
        event transfer(address _from, address _to, itemD  _item);
    
    function CreateItem( string memory _name) public {
        require(msg.sender != address(0) ,"Not Valid");
        itemDetails[itemID].name=_name;
        itemDetails[itemID].owner=msg.sender;
        itemDetails[itemID].lastBid=0;
        itemDetails[itemID].highestBid=0;
        itemDetails[itemID].highestBider=address(0);
        itemDetails[itemID].lastHighestBider=address (0);
        itemDetails[itemID].auction_time=block.timestamp + 3600;
        emit createItem(msg.sender, itemID , _name);
        itemID+=1;
    }

    function placeBid(uint256 id) public payable  {
        require(itemDetails[id].owner != msg.sender," owner can't bid");
        require(itemDetails[id].auction_time > block.timestamp," Nothing to Place the Bid ");
        require(msg.value >= itemDetails[id].lastBid, "Increase the Amount");
        // require(msg.value > itemDetails[id].highestBid," Increase the amount by 1 ether");
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

    }

    function ownershipTransfer(address payable  _address,uint256 id, uint256 id2) public {
        require(msg.sender == itemDetails[id].owner, " Onle The owner of the Item can access.");
        itemDetails[id].lasBid.transfer(itemDetails[id].highestBid);
        itemDetails[itemDetails[_address][id].highestBider]= itemDetails[_address][id];
        delete itemDetails[_address][id];
    }

}