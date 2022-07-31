// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    error TimestampNotPassedError(uint blockTimestmap, uint timestamp);

    ExampleExternalContract public exampleExternalContract;

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(
            exampleExternalContractAddress
        );
    }
    mapping(address => uint256) public balances;
    uint256 public constant threshold = 1 ether;
    
    event Stake(address sender);

    function stake() public payable returns (uint) {
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender);
        return balances[msg.sender];
    }


    uint256 public deadline = block.timestamp + 30 seconds;
    
    function execute() public {
      if (block.timestamp > deadline && threshold > 1) {
        exampleExternalContract.complete{value: address(this).balance}();
      }
    }
