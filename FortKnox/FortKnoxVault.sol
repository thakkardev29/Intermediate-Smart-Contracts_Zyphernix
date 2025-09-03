// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GoldVault is ReentrancyGuard {
    IERC20 public goldToken;
    mapping(address => uint256) public balances;

    constructor(address _goldToken) {
        goldToken = IERC20(_goldToken);
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(goldToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        require(goldToken.transfer(msg.sender, amount), "Transfer failed");
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
