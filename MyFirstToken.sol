// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyFirstToken is ERC20 {

    constructor(uint256 initialSupply) ERC20("Thakkar", "Dev") {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
}
