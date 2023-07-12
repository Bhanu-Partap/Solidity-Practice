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

    mapping(address => Stake[]) public Stake_details;
    // mapping(address => uint256) public balances;

    event tokensStaked(address from, uint256 amount, uint256 _duration);


    function staking(uint256 _amount,string memory _type,uint256 _duration, bool _isFixed, uint _index) public {
        require(Token.balanceOf(msg.sender) >= _amount, "Insufficient Balance");
        if ( keccak256(abi.encodePacked(_type)) == keccak256(abi.encodePacked("fixed")) ) {
            require( _amount > 0," Stake can not be 0 , Enter some amount of tokens");
            Stake_details[msg.sender][_index].stake_amount = _amount;
            Stake_details[msg.sender][_index].stake_type = _type;
            Stake_details[msg.sender][_index].stake_time = block.timestamp + _duration;
            Stake_details[msg.sender][_index].isFixed = _isFixed;
            Stake_details[msg.sender][_index].starting_stake_time = block.timestamp;
            Token.transferFrom(msg.sender, address(this), _amount);
            emit tokensStaked(msg.sender, _amount, block.timestamp);
        } 
        else if (keccak256(abi.encodePacked(_type)) == keccak256(abi.encodePacked("unfixed")) ) {
            Stake_details[msg.sender][_index].stake_amount = _amount;
            Stake_details[msg.sender][_index].stake_type = _type;
            Stake_details[msg.sender][_index].isFixed = _isFixed;
            Token.transferFrom(msg.sender, address(this), _amount);
            Stake_details[msg.sender][_index].starting_stake_time = block.timestamp;
            Token.transferFrom(msg.sender, address(this), _amount);
            emit tokensStaked(msg.sender, _amount, block.timestamp);
        }
    }

    function unstaking(address _address,uint256 _index) public returns (uint256) {
        console.log("hello");

        if (Stake_details[_address][_index].isFixed == true) {
            // require(Stake_details[_address].stake_time > expirytime_forfixedstaking );
            if (block.timestamp > expirytime_forfixedstaking ) {
                console.log("inside the fixed stake after complete time");
                Interest =(Stake_details[_address][_index].stake_amount *fixedinterest_rate *(Stake_details[_address][_index].stake_time)) /100;
                totalIntrestAmount =(Stake_details[_address][_index].stake_amount + Interest)/365 days;
                console.log(totalIntrestAmount);
                Token.transfer(_address, totalIntrestAmount);
                return totalIntrestAmount;
            }

            //unstaked before fixed time so the penality will be taken
            else if (block.timestamp < expirytime_forfixedstaking) {
                console.log("inside the fixed stake before complete time and got penality");
                require(  Stake_details[_address][_index].stake_time <  expirytime_forfixedstaking,"" );
                Interest = (Stake_details[_address][_index].stake_amount * fixedinterest_rate *(block.timestamp -Stake_details[_address][_index].starting_stake_time))/ 100 ;
                console.log(Interest);
                totalIntrestAmount = (Interest * 96) / 100;
                console.log(totalIntrestAmount);
                finalAmount =totalIntrestAmount +Stake_details[_address][_index].stake_amount;
                console.log(finalAmount);
                Token.transfer(_address, finalAmount);
                return finalAmount;
            }
        } 
        else if (Stake_details[_address][_index].isFixed == false) {
            console.log("not fixed loop");
            // uint256 unfixed_time_cal=block.timestamp - Stake_details[_address].starting_stake_time;
            Interest =(Stake_details[_address][_index].stake_amount *unfixedinterest_rate) /100 ;
                console.log(Interest);
                totalIntrestAmount =Stake_details[_address][_index].stake_amount + Interest;
                console.log(totalIntrestAmount);
                Token.transfer(_address, totalIntrestAmount);
                return totalIntrestAmount;
        }
    }

    function TokenBalance(address _address) public view returns (uint256) {
        return Token.balanceOf(_address);
    }

    function getcontractaddress() public returns (address) {
        return address(this);
    }
}
