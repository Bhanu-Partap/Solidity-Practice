// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdFunding {
    struct projectDetails {
        string name;
        string description;
        uint256 funding_goal;
        uint256 deadline;
        uint funding;
    }

    uint256 id;
    projectDetails[]  project;

    // mapping
    mapping(uint256 => projectDetails) public userProjects;


    function setProjectDetails( uint256 _id, string memory _name,string memory _description,uint256 _funding_goal, uint256 _deadline ) public {
        userProjects[_id].name = _name;
        userProjects[_id].description = _description;
        userProjects[id].funding_goal = _funding_goal;
        userProjects[id].deadline = block.timestamp + _deadline;

    }
}
