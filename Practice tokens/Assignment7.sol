// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdFunding{

    struct projectDetails{
        string name;
        string description;
        uint funding_goal;
        uint deadLine;
    }

    uint id;
    projectDetails[] public project;

    // mapping
    mapping(uint => projectDetails) public userProjects;


    function setProjectDetails() public {

    }



}