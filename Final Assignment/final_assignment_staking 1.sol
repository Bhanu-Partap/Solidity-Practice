// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ERC-20.sol";
import "hardhat/console.sol";

contract Staking_Token {
    ERC20Basic Token;

    constructor(ERC20Basic _addressERC20) {
        Token = _addressERC20;
    }

    struct Stake {
        uint256 stake_amount;
        string stake_type;
        uint256 stake_time;
        uint256 starting_stake_time;
        bool isFixed;
        address owner;
        bool isClaimed;
    }

    address mapping_address;
    uint256 expirytime_forfixedstaking = block.timestamp + 300;
    uint256 penality_stake = 4; // percent 4%
    uint256 fixedinterest_rate = 6;
    uint256 unfixedinterest_rate = 2;
    uint256 stake_reward;
    uint256 Interest;
    uint256 totalIntrestAmount;
    uint256 finalAmount;

    mapping(address => Stake) public Stake_details;
    // mapping(address => uint256) public balances;

    event tokensStaked(address from, uint256 amount, uint256 _duration);


    function staking(uint256 _amount,string memory _type,uint256 _duration, bool _isFixed) public {
        require(Token.balanceOf(msg.sender) >= _amount, "Insufficient Balance");
        if ( keccak256(abi.encodePacked(_type)) == keccak256(abi.encodePacked("fixed")) ) {
            require( _amount > 0," Stake can not be 0 , Enter some amount of tokens");
            Stake_details[msg.sender].stake_amount = _amount;
            Stake_details[msg.sender].stake_type = _type;
            Stake_details[msg.sender].stake_time = expirytime_forfixedstaking + _duration;
            Stake_details[msg.sender].isFixed = _isFixed;
            Stake_details[msg.sender].owner =msg.sender;
            Stake_details[msg.sender].isClaimed =false;
            Stake_details[msg.sender].starting_stake_time = block.timestamp;
            Token.transferFrom(msg.sender, address(this), _amount);
            emit tokensStaked(msg.sender, _amount, block.timestamp);
        } 
        else if (keccak256(abi.encodePacked(_type)) == keccak256(abi.encodePacked("unfixed")) ) {
            Stake_details[msg.sender].stake_amount = _amount;
            Stake_details[msg.sender].stake_type = _type;
            Stake_details[msg.sender].isFixed = _isFixed;
            Stake_details[msg.sender].owner =msg.sender;
            Stake_details[msg.sender].isClaimed =false;
            Stake_details[msg.sender].starting_stake_time = block.timestamp;
            Token.transferFrom(msg.sender, address(this), _amount);
            emit tokensStaked(msg.sender, _amount, block.timestamp);
        }
    }

    function unstaking(address _address) public returns (uint256) {
        console.log("hello");
        require(msg.sender == Stake_details[msg.sender].owner,"Stake has not been initiated");
        if (Stake_details[_address].isFixed == true) {
            // require(Stake_details[_address].stake_time > expirytime_forfixedstaking );
            if (block.timestamp > Stake_details[msg.sender].stake_time ) {
                console.log("inside the fixed stake after complete time");
                // uint256 fixed_time_after=  expirytime_forfixedstaking - Stake_details[_address].starting_stake_time ;
                Interest =(Stake_details[_address].stake_amount *fixedinterest_rate ) /100;
                totalIntrestAmount =Stake_details[_address].stake_amount + Interest;
                console.log(totalIntrestAmount);
                Token.transfer(_address, totalIntrestAmount);
                delete Stake_details[_address];
                Stake_details[msg.sender].isClaimed =true;
                return totalIntrestAmount;
            }

            //unstaked before fixed time so the penality will be taken
            else if (block.timestamp < Stake_details[msg.sender].stake_time) {
                console.log("inside the fixed stake before complete time and got penality");
                // uint256 fixed_time_before=block.timestamp - Stake_details[_address].starting_stake_time;
                require( block.timestamp <  expirytime_forfixedstaking,"" );
                Interest = (Stake_details[_address].stake_amount * fixedinterest_rate )/ 100 ;
                console.log(Interest);
                totalIntrestAmount = (Interest * 96) / 100;
                console.log(totalIntrestAmount);
                finalAmount =totalIntrestAmount +Stake_details[_address].stake_amount;
                console.log(finalAmount);
                Token.transfer(_address, finalAmount);
                delete Stake_details[_address];
                Stake_details[msg.sender].isClaimed =true;
                return finalAmount;
            }
        } 
        else if (Stake_details[_address].isFixed == false) {
            console.log("not fixed loop");
            Interest =(Stake_details[_address].stake_amount *unfixedinterest_rate) /100 ;
                console.log(Interest);
                totalIntrestAmount =Stake_details[_address].stake_amount + Interest;
                console.log(totalIntrestAmount);
                Token.transfer(_address, totalIntrestAmount);
                delete Stake_details[_address];
                Stake_details[msg.sender].isClaimed =true;
                return totalIntrestAmount;
        }
    }

    function TokenBalance(address _address) public view returns (uint256) {
        return Token.balanceOf(_address);
    }


    function claimedRewards(address _address) public view returns (uint256) {
    if (Stake_details[_address].isFixed == true) {
        if (block.timestamp > Stake_details[msg.sender].stake_time) {
            return Stake_details[_address].stake_amount + Interest;
        } else {
            return Stake_details[_address].stake_amount;
        }
    }
    else if(block.timestamp < Stake_details[msg.sender].stake_time){
         return finalAmount - totalIntrestAmount;
    
    }
     else {
        return Stake_details[_address].stake_amount + Interest;
    }
}

function unclaimedRewards(address _address) public view  returns (uint256) {
    if (Stake_details[_address].isFixed == true) {
        if (Stake_details[_address].isClaimed == true) {
            return 0;
        } else {
            return Interest;
        }
    } else {
        if (Stake_details[_address].isClaimed == true) {
            return 0;
        } else {
            return Interest;
        }
    }
}


    function getcontractaddress() public returns (address) {
        return address(this);
    }
}
