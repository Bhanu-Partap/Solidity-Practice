// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdFunding {
    struct projectDetails {
        string name;
        string description;
        uint256 funding_goal;
        uint256 deadline;
        address _owner;
        userbalance[]   balance;
    }

    struct userbalance{
        address _address;
        uint _balance;
    }

    
    uint256 id;

    // mapping
    mapping(uint256 => projectDetails) public userProjects;
    

    function setProjectDetails( uint256 _id, string memory _name,string memory _description,uint256 _funding_goal, uint256 _deadline ) public {
        userProjects[_id].name = _name;
        userProjects[_id].description = _description;
        userProjects[_id].funding_goal = _funding_goal;
        userProjects[_id]._owner = msg.sender;
        userProjects[_id].deadline = block.timestamp + _deadline;
    }

    function contribute(uint _id) public payable {
        require(msg.sender != userProjects[_id]._owner," Owner can't contribute");
        require(msg.value <= userProjects[_id].funding_goal,"Amount can not be greater than goal amount");
        userProjects[_id].balance.push(userbalance(msg.sender,msg.value));

    }

    function conditionNotMet(uint _id) public  {
        require(userProjects[_id]._owner == msg.sender, "only can refund");

        require(block.timestamp >= userProjects[_id].deadline," Still have some time left for funding" );
        for(uint i=0; i< userProjects[_id].balance.length;i++){
        payable(userProjects[_id].balance[i]._address).transfer(userProjects[_id].balance[i]._balance);
        delete userProjects[_id].balance[i];
        }
    }

    function fundingComplete(uint _id) public payable{
        require(msg.sender == userProjects[_id]._owner," Only Owner can widthdraw");
        for(uint i=0; i < userProjects[_id].balance.length;i++){
        payable(userProjects[_id]._owner).transfer(userProjects[_id].balance[i]._balance);
    }
    }
}
