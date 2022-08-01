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
    uint256 public deadline = block.timestamp + 30 seconds;

    
    event Stake(address sender);

    function stake() public payable returns (uint) {
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender);
        return balances[msg.sender];
    }


    bool openForWithdraw;
    
    modifier notCompleted() {
        require(openForWithdraw == false);
        _;
    }


    function execute() public notCompleted{
        if (deadline > block.timestamp && address(this).balance > threshold) {
            exampleExternalContract.complete{value: address(this).balance}();
        } else {
            openForWithdraw = true;
        }
    }

    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        } else {
            return deadline - block.timestamp;
        }
    }

    function withdraw() public notCompleted{
        require(openForWithdraw == true, "Can't withdraw yet!");
        payable(msg.sender).transfer(address(this).balance);
        }
        // below are more specfic withdraw function parameters
        //require(balances[msg.sender] >= _amount, "Insufficent Funds");
        //balances[msg.sender] -= _amount;
        //(bool sent, ) = msg.sender.call{value: _amount}(
        //    "Funds sent successfully"
        //);
        //require(sent, "Failed to Complete");
        
     // Receive Ether Function to collect & stake ETH sent directly to the contract address   
     receive() external payable {
        stake();
        }
        
}
    
    
