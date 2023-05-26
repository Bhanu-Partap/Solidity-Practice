// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC-20.sol";
import "./ERC-721.sol";
import "./ERC-1155.sol";

contract finaL {
    ERC20Basic token;
    NFT nft;
    ERC1155MYTOKEN nftwithsupply;

    struct itemD {
        string name;
        address owner;
        uint256 lastBid;
        uint256 highestBid;
        address highestBider;
        uint256 auction_time;
        address lastHighestBider;
    }
    uint256 itemID = 1;

    struct listItem {
        uint256 listedItemPrice;
        address addr;
        string nft_type;
    }

    constructor(
        address addr1,
        address addr2,
        address addr3
    ) {
        nft = NFT(addr1);
        nftwithsupply = ERC1155MYTOKEN(addr2);
        token = ERC20Basic(addr3);
    }

    // mapping
    mapping(uint256 => itemD) public itemDetails;
    mapping(uint256 => listItem) public ListItem;

    // events
    event createItem(address owner, uint256 id, string name);
    event Bid(address _address, uint256 _bidamount);
    event transfer(address _from, address _to, itemD _item);

    //functions

    function buyTokens() public payable {
        uint256 amounttoBuy = msg.value;
        uint256 ContractBalance = token.balanceOf(address(this));
        require(amounttoBuy > 0, "send some more ethers");
        require(amounttoBuy <= ContractBalance, "not enough tokens");
        token.transfer(msg.sender, amounttoBuy);
    }

    function Register(
        string memory _name,
        string memory _nft_type,
        address _addr,
        uint256 _listedItemPrice,
        uint256 id,
        string memory checkListAuction
    ) public {
        if (keccak256(abi.encodePacked(checkListAuction)) ==keccak256(abi.encodePacked("Auction"))) {
            require(nft.ownerOf(id) == msg.sender ||nftwithsupply.balanceOf(msg.sender, id) > 0, "not authorized" );
            require(token.balanceOf(msg.sender) > 0, "Insufficient tokens");
            if ( keccak256(abi.encodePacked(_nft_type)) ==keccak256(abi.encodePacked("ERC721"))) {
                itemDetails[itemID].name = _name;
                itemDetails[itemID].owner = msg.sender;
                itemDetails[itemID].lastBid = 0;
                itemDetails[itemID].highestBid = 0;
                itemDetails[itemID].highestBider = address(0);
                itemDetails[itemID].lastHighestBider = address(0);
                itemDetails[itemID].auction_time = block.timestamp + 3600;
                itemID += 1;
            } 
            else if(keccak256(abi.encodePacked(_nft_type)) == keccak256(abi.encodePacked("ERC1155"))) {
                itemDetails[itemID].name = _name;
                itemDetails[itemID].owner = msg.sender;
                itemDetails[itemID].lastBid = 0;
                itemDetails[itemID].highestBid = 0;
                itemDetails[itemID].highestBider = address(0);
                itemDetails[itemID].lastHighestBider = address(0);
                itemDetails[itemID].auction_time = block.timestamp + 3600;
                itemID += 1;
            }
        } 
        else if (keccak256(abi.encodePacked(checkListAuction)) ==keccak256(abi.encodePacked("Fixed_Price")) ) {
            if (keccak256(abi.encodePacked(checkListAuction)) ==keccak256(abi.encodePacked("ERC721")) ) {
                ListItem[itemID].listedItemPrice = _listedItemPrice;
                ListItem[itemID].addr = _addr;
                ListItem[itemID].nft_type = _nft_type;
                itemID += 1;
            }
             else if (keccak256(abi.encodePacked(checkListAuction)) ==keccak256(abi.encodePacked("ERC1155")) ) {
                ListItem[itemID].listedItemPrice = _listedItemPrice;
                ListItem[itemID].addr = _addr;
                ListItem[itemID].nft_type = _nft_type;
                itemID += 1;
            }
        }
    }

    function placeBid(uint256 id, uint256 _amount)
        public
        payable
        returns (string memory)
    {
        require(
            itemDetails[id].auction_time > block.timestamp,
            "not started yet"
        );
        require(_amount > itemDetails[id].lastBid, "Increase the Amount");
        require(itemDetails[id].owner != msg.sender, " owner can't bid");
        itemDetails[id].lastBid = itemDetails[id].highestBid;
        itemDetails[id].lastHighestBider = itemDetails[id].highestBider;
        itemDetails[id].highestBid = _amount;
        itemDetails[id].highestBider = msg.sender;
        payable(itemDetails[id].lastHighestBider).transfer(
            itemDetails[id].lastBid
        );
        emit Bid(msg.sender, _amount);
        return "Bid successfully Completed";
    }

    function LowerthePrice(uint256 id, uint256 loweredamount) public payable {
        require(
            msg.sender == ListItem[id].addr,
            "Only owner can lower the price"
        );
        require(
            loweredamount < ListItem[id].listedItemPrice,
            "Amount should be smaller then the previous one "
        );
        ListItem[id].listedItemPrice = loweredamount;
    }

    function getHighestBid(uint256 id) public view returns (uint256) {
        return itemDetails[id].highestBid;
    }

    function cancelListing(uint256 id) public {
        // require(ListItem[id].listedItemPrice > 0 ,"Item did't exist");
        require(
            msg.sender == ListItem[id].addr,
            "Only owner can cancel listing"
        );
        payable(ListItem[id].addr).transfer(ListItem[id].listedItemPrice);
        delete ListItem[id];
    }

    function cancelAuction(uint256 id) public {
        require(itemDetails[id].highestBid > 0, "Auctioned item didnt exist");
        require( msg.sender == itemDetails[id].owner," Only Owner can cancel the Auction" );
        payable(itemDetails[id].highestBider).transfer( itemDetails[id].highestBid );
        delete itemDetails[id];
    }

    function getcontractaddress() public view returns (address) {
        return address(this);
    }
}
