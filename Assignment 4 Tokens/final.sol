// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC-20.sol";
import "./ERC-721.sol";
import "./ERC-1155.sol";


contract finaL  {

 ERC20Basic token;
 NFT nft;
 ERC1155MYTOKEN nftwithsupply;

    
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

    constructor(address addr1, address addr2 ){
         nft=NFT (addr1);
         nftwithsupply = ERC1155MYTOKEN(addr2);
         token = new ERC20Basic();

    }
        // mapping
        mapping(uint => itemD) public itemDetails;
        mapping(uint => listItem) public ListItem;

        // events
        event createItem(address owner,uint id,string name);
        event Bid(address _address, uint256 _bidamount);
        event transfer(address _from, address _to, itemD  _item);
    
    //functions

    function buyTokens() public payable {
        uint256 amounttoBuy = msg.value;
        uint256 ContractBalance = token.balanceOf(address(this));
        require(amounttoBuy > 0,"send some more ethers");
        require(amounttoBuy <= ContractBalance,"not enough tokens" );
        

    }




    function Register( string memory _nft_type, address _addr, uint256 _listedItemPrice, uint256 id, string memory checkListAuction) public {
       require(msg.sender != address(0) ,"Not Valid");
        if(keccak256(abi.encodePacked(_nft_type)) == keccak256(abi.encodePacked("ERC721"))){
            if(keccak256(abi.encodePacked(checkListAuction))== keccak256(abi.encodePacked("Auction"))){
                itemDetails[itemID].owner=msg.sender;
                itemDetails[itemID].lastBid=0;
                itemDetails[itemID].highestBid=0;
                itemDetails[itemID].highestBider=address(0);
                itemDetails[itemID].lastHighestBider=address (0);
                itemDetails[itemID].auction_time=block.timestamp + 3600;
                itemID+=1;
                }
            else if(keccak256(abi.encodePacked(checkListAuction))==keccak256(abi.encodePacked("Fixed_Price"))){
                ListItem[id].listedItemPrice=  _listedItemPrice;
                ListItem[id].addr=  _addr;
                ListItem[id].nft_type=  _nft_type;                
                }
        }
        else if(keccak256(abi.encodePacked(_nft_type)) == keccak256(abi.encodePacked("ERC1155"))){
             if(keccak256(abi.encodePacked(checkListAuction))== keccak256(abi.encodePacked("Auction"))){                itemDetails[itemID].owner=msg.sender;
                itemDetails[itemID].lastBid=0;
                itemDetails[itemID].highestBid=0;
                itemDetails[itemID].highestBider=address(0);
                itemDetails[itemID].lastHighestBider=address (0);
                itemDetails[itemID].auction_time=block.timestamp + 3600;
                itemID+=1;
                }
            else if(keccak256(abi.encodePacked(checkListAuction))==keccak256(abi.encodePacked("Fixed_Price"))){
                ListItem[id].listedItemPrice=  _listedItemPrice;
                ListItem[id].addr=  _addr;
                ListItem[id].nft_type=  _nft_type;                
                }   
        }
    }

    function placeBid(uint256 id) public payable returns(string memory)  {
        require(itemDetails[id].auction_time > block.timestamp,"not started yet");
        require(msg.value >= itemDetails[id].lastBid, "Increase the Amount");
        if(itemDetails[id].highestBid == 0){
            require(itemDetails[id].owner != msg.sender," owner can't bid");
            itemDetails[id].highestBid=msg.value;
            itemDetails[id].highestBider=msg.sender;
        }
        else if(itemDetails[id].highestBid != 0){
            itemDetails[id].highestBid=msg.value;
            itemDetails[id].highestBider=msg.sender;
            itemDetails[id].lastBid=itemDetails[id].highestBid;
            itemDetails[id].lastHighestBider=itemDetails[id].highestBider;
            payable(itemDetails[id].lastHighestBider).transfer(itemDetails[id].lastBid);
        }
        emit Bid(msg.sender, msg.value);
        return "Bid successfully Completed";

    }


    function LowerthePrice(uint256 id, uint256 loweredamount) public payable{
         ListItem[id].listedItemPrice = loweredamount;
    }


    function getHighestBid( uint256 id) public view returns(uint256) {
        return itemDetails[id].highestBid;
    }


    function cancelListing(uint256 id) public {
        
    }
 
    // function cancelAuction( uint256 id) public  {
    //     require(msg.sender == itemDetails[id].owner," Only Owner can cancel the Auction");
    //     payable (itemDetails[id].highestBider).transfer(itemDetails[id].highestBid);
    //     delete itemDetails[id];

    // }



    function getcontractaddress() public view returns(address){
      return address(this);
    }

}