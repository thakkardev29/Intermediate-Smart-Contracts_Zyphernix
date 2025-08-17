// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

    import "./Ownable.sol"; 

contract MasterKey is Ownable {
    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    function deposit() external payable {
        require(msg.value > 0, "Vault: zero deposit");
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0), "Vault: zero recipient");
        require(amount <= address(this).balance, "Vault: insufficient balance");
        emit Withdrawn(to, amount);
    }

    function balance() external view returns (uint256) {
        return address(this).balance;
    }
}
