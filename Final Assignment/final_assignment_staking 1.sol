// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ERC-20.sol";

contract Staking_Token {

    ERC20Basic Token;

     constructor(ERC20Basic _addressERC20 ){
        Token=_addressERC20;
    }

    struct Stake{
        uint stake_amount;
        string stake_type;
        uint stake_time;
    }

    address mapping_address;
    uint experttime_forfixedstaking = block.timestamp + 300 ;
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
        Token.transferFrom(msg.sender, address(this), _amount);
        emit tokensStaked(msg.sender, _amount, block.timestamp);

        }

        else if(keccak256(abi.encodePacked(_type)) == keccak256(abi.encodePacked("unfixed"))){
            Stake_details[msg.sender].stake_amount = _amount;
            Stake_details[msg.sender].stake_type = _type;
            Token.transferFrom(msg.sender, address(this), _amount);


        }
    

    }


    function interestCalculated(address _address) public returns(uint){
        if (Stake_details[msg.sender].stake_time > experttime_forfixedstaking){
        Interest = Stake_details[msg.sender].stake_amount * fixedinterest_rate * Stake_details[msg.sender].stake_time;
        totalIntrestAmount = (Stake_details[msg.sender].stake_amount + Interest) /100;
        }
        else if(Stake_details[msg.sender].stake_time < experttime_forfixedstaking){
            // require();
        Interest = (Stake_details[msg.sender].stake_amount * fixedinterest_rate * (Stake_details[msg.sender].stake_time -(Stake_details[msg.sender].stake_time - block.timestamp)));    
        totalIntrestAmount = Stake_details[msg.sender].stake_amount + Interest;
        finalAmount = (totalIntrestAmount - penality_stake) / 100 ;
        }
        
    }




    function unstaking()public returns(string memory){

    }

 function getcontractaddress() public returns(address){
      return address(this);
      }

}


