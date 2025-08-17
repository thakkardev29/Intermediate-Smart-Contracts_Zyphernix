// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./MyFirstToken.sol"; 

contract PreorderTokens {
    MyFirstToken public token;
    uint256 public pricePerToken; 

    address payable public owner;

    constructor(address _tokenAddress, uint256 _pricePerToken) {
        token = MyFirstToken(_tokenAddress);
        pricePerToken = _pricePerToken;
        owner = payable(msg.sender);
    }

    function buyTokens(uint256 numberOfTokens) public payable {
        require(msg.value == numberOfTokens * pricePerToken, "Incorrect ETH sent");
        require(token.balanceOf(address(this)) >= numberOfTokens, "Not enough tokens in contract");

        token.transfer(msg.sender, numberOfTokens);
    }

    function withdrawFunds() public {
        require(msg.sender == owner, "Only owner can withdraw");
        owner.transfer(address(this).balance);
    }
}
