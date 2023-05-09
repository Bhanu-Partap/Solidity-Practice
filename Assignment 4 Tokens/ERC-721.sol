// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    constructor() ERC721("Nitro", "NSX") {}
    uint mintCount=3;


    function mintNFT(address recipient, string memory baseURI) public onlyOwner 
    {
        uint i=0;
        for(i;i<mintCount;i++){
            _tokenIds.increment();

            uint newItemId = _tokenIds.current();
            _mint(recipient, newItemId);
            _setTokenURI(newItemId, string(abi.encodePacked(baseURI,Strings.toString(newItemId),".json")));
            // return newItemId;
            console.log(string(abi.encodePacked(baseURI,Strings.toString(newItemId),".json")));
    }


    }
}