// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract finaL  {
    struct itemD{
        string name;
        uint256 lastBid;
        uint256 highestBid;
        address highestBider;
        uint256 auction_time;
        address lastHighestBider;
    }

        // mapping
        mapping(address => mapping(uint256 =>itemD)) public itemDetails;

        // events
        event createItem(address owner,uint id,string name);
        event Bid(address _address, uint256 _bidamount);
        event transfer(address _from, address _to, itemD  _item);
    
    function CreateItem(uint256 id, string memory _name) public {
        require(msg.sender != address(0) ,"Not Valid");
        itemDetails[msg.sender][id].name=_name;
        itemDetails[msg.sender][id].lastBid=0;
        itemDetails[msg.sender][id].highestBid=0;
        itemDetails[msg.sender][id].highestBider=address(0);
        itemDetails[msg.sender][id].lastHighestBider=address (0);
        itemDetails[msg.sender][id].auction_time=block.timestamp + 3600;
        emit createItem(msg.sender, id , _name);
    }

    function placeBid(address _address,uint256 id)public payable  {
        require(_address != msg.sender," owner can't bid");
        require(itemDetails[_address][id].auction_time > 0," Nothing to Place the Bid ");
        require(msg.value > itemDetails[_address][id].highestBid," Increase the amount by 1 ether");
        itemDetails[_address][id].lastBid=msg.value;
        itemDetails[_address][id].highestBid=itemDetails[_address][id].lastBid;
        itemDetails[_address][id].lastHighestBider=msg.sender;
        itemDetails[_address][id].highestBider=msg.sender;
        payable(itemDetails[_address][id].lastHighestBider).transfer(itemDetails[_address][id].highestBid);
        emit Bid(msg.sender, msg.value);

    }

    function getHighestBid(address _address, uint256 id)public view returns(uint256) {
        return itemDetails[_address][id].highestBid;
    }

    function getWinningBidder(address _address,uint256 id)public view returns(address){
        return itemDetails[_address][id].highestBider;
    }

    function cancelAuction(address _address,uint256 id)public {
        require(condition);
        payable (itemDetails[_address][id].highestBider).transfer(itemDetails[_address][id].highestBid);

    }

    function ownershipTransfer(address _address,uint256 id)public {

    }
}