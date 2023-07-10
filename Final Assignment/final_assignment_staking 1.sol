// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ERC-20.sol";
import "hardhat/console.sol";

contract Staking_Token {

    ERC20Basic Token;

     constructor(ERC20Basic _addressERC20 ){
        Token=_addressERC20;
    }

    struct Stake{
        uint stake_amount;
        string stake_type;
        uint stake_time;
        uint starting_stake_time;
    }

    address mapping_address;
    uint expirytime_forfixedstaking = block.timestamp + 300 ;
    uint penality_stake = 4; // percent 4%
    uint fixedinterest_rate = 6;
    uint unfixedinterest_rate = 2;
    uint stake_reward;
    uint Interest;
    uint totalIntrestAmount;
    uint finalAmount;


    mapping(address =>Stake) public Stake_details;
    // mapping(address => uint256) public balances;


    event tokensStaked(address from, uint256 amount, uint _duration);

    // function balanceToken(address _address) public  {
    //     Token.balanceOf(msg.sender);
    // }


    function staking(uint _amount, string memory _type, uint _duration) public  {
        require(Token.balanceOf(msg.sender)>=_amount,"Insufficient Balance");
        if(keccak256(abi.encodePacked(_type)) == keccak256(abi.encodePacked("fixed"))){
            require(_amount >0," Stake can not be 0 , Enter some amount of tokens");
            Stake_details[msg.sender].stake_amount = _amount;
            Stake_details[msg.sender].stake_type = _type;
            Stake_details[msg.sender].stake_time = block.timestamp + _duration;
            Stake_details[msg.sender].starting_stake_time = block.timestamp;
        Token.transferFrom(msg.sender, address(this), _amount);
        emit tokensStaked(msg.sender, _amount, block.timestamp);
        }

        else if(keccak256(abi.encodePacked(_type)) == keccak256(abi.encodePacked("unfixed"))){
            Stake_details[msg.sender].stake_amount = _amount;
            Stake_details[msg.sender].stake_type = _type;
            Token.transferFrom(msg.sender, address(this), _amount);
            Stake_details[msg.sender].starting_stake_time = block.timestamp;
            Token.transferFrom(msg.sender, address(this), _amount);
        emit tokensStaked(msg.sender, _amount, block.timestamp);
        }
    }

    function unstaking(address _address) public returns(uint){
        console.log("hello");
        if (Stake_details[_address].stake_time > expirytime_forfixedstaking){
            console.log("inside the loop");
        Interest = Stake_details[_address].stake_amount * fixedinterest_rate * (block.timestamp - Stake_details[_address].starting_stake_time );
        totalIntrestAmount = (Stake_details[_address].stake_amount + Interest) /100;
        return totalIntrestAmount;
        }

        //unstaked before fixed time so the penality will be taken 

        else if(Stake_details[_address].stake_time < expirytime_forfixedstaking){
            require(Stake_details[_address].stake_time < expirytime_forfixedstaking, "");
        Interest = (Stake_details[_address].stake_amount * fixedinterest_rate * (block.timestamp - Stake_details[_address].starting_stake_time ));    
             console.log(Interest);
        totalIntrestAmount = (Interest * 96) /100 ;
             console.log(totalIntrestAmount);
        // finalAmount = totalIntrestAmount -(totalIntrestAmount * penality_stake / 100) ;
        finalAmount = totalIntrestAmount + Stake_details[_address].stake_amount;
             console.log(finalAmount);
        return finalAmount;
        }      
    }


    function TokenBalance(address _address) public view  returns(uint){
       return  Token.balanceOf(_address);
        
    }

 function getcontractaddress() public returns(address){
      return address(this);
      }

}


