// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract SubscriptionProxy {

    mapping(address => uint256) public expiry;
    address public logic; 
    address public owner;

    constructor(address _logic) {
        logic = _logic;
        owner = msg.sender;
    }

    function upgradeLogic(address _newLogic) external {
        require(msg.sender == owner, "Not owner");
        logic = _newLogic;
    }

    fallback() external payable {
        (bool success, ) = logic.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }

    receive() external payable {}
}

contract SubscriptionLogicV1 {

    mapping(address => uint256) public expiry;
    address public logic;
    address public owner;

    function subscribe() external payable {
        require(msg.value == 0.01 ether, "Need 0.01 ETH");
        expiry[msg.sender] = block.timestamp + 30 days;
    }

    function isActive(address user) external view returns (bool) {
        return expiry[user] > block.timestamp;
    }
}

contract SubscriptionLogicV2 {
    mapping(address => uint256) public expiry;
    address public logic;
    address public owner;


    function subscribe(uint256 daysCount) external payable {
        require(msg.value == 0.005 ether * daysCount, "Incorrect fee");
        expiry[msg.sender] = block.timestamp + (daysCount * 1 days);
    }

    function isActive(address user) external view returns (bool) {
        return expiry[user] > block.timestamp;
    }


    function cancel() external {
        expiry[msg.sender] = block.timestamp; // expires immediately
    }
}
