// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface IDepositBox {
    function storeSecret(string calldata _secret) external;
    function getSecret() external view returns (string memory);
    function transferOwnership(address newOwner) external;
    function owner() external view returns (address);
}

contract BasicBox is IDepositBox {
    address private _owner;
    string private _secret;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not the owner!");
        _;
    }

    constructor(address initialOwner) {
        _owner = initialOwner;
    }

    function storeSecret(string calldata _secretIn) external onlyOwner {
        _secret = _secretIn;
    }

    function getSecret() external view override returns (string memory) {
        return _secret;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        _owner = newOwner;
    }

    function owner() external view returns (address) {
        return _owner;
    }
}

contract TimeLockBox is IDepositBox {
    address private _owner;
    string private _secret;
    uint256 public unlockTime;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not the owner!");
        _;
    }

    modifier isUnlocked() {
        require(block.timestamp >= unlockTime, "Secret is still locked!");
        _;
    }

    constructor(address initialOwner, uint256 _unlockTime) {
        _owner = initialOwner;
        unlockTime = _unlockTime;
    }

    function storeSecret(string calldata _secretIn) external onlyOwner {
        _secret = _secretIn;
    }

    function getSecret() external view override isUnlocked returns (string memory) {
        return _secret;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        _owner = newOwner;
    }

    function owner() external view returns (address) {
        return _owner;
    }
}

contract PremiumBox is IDepositBox {
    address private _owner;
    string[] private secrets;
    mapping(address => bool) public whitelist;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not the owner!");
        _;
    }

    modifier onlyWhitelisted() {
        require(msg.sender == _owner || whitelist[msg.sender], "Not allowed!");
        _;
    }

    constructor(address initialOwner) {
        _owner = initialOwner;
    }

    function storeSecret(string calldata _secretIn) external onlyOwner {
        secrets.push(_secretIn);
    }

    function getSecret() external view override onlyWhitelisted returns (string memory) {
        require(secrets.length > 0, "No secrets stored yet");
        return secrets[secrets.length - 1];
    }

    function getAllSecrets() external view onlyWhitelisted returns (string[] memory) {
        return secrets;
    }

    function addToWhitelist(address user) external onlyOwner {
        whitelist[user] = true;
    }

    function removeFromWhitelist(address user) external onlyOwner {
        whitelist[user] = false;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        _owner = newOwner;
    }

    function owner() external view returns (address) {
        return _owner;
    }
}

contract VaultManager {
    IDepositBox[] public boxes;

    function createBasicBox() external returns (address) {
        BasicBox box = new BasicBox(msg.sender);
        boxes.push(box);
        return address(box);
    }

    function createTimeLockBox(uint256 _unlockTime) external returns (address) {
        TimeLockBox box = new TimeLockBox(msg.sender, _unlockTime);
        boxes.push(box);
        return address(box);
    }

    function createPremiumBox() external returns (address) {
        PremiumBox box = new PremiumBox(msg.sender);
        boxes.push(box);
        return address(box);
    }

    function getBoxCount() external view returns (uint256) {
        return boxes.length;
    }

    function getBox(uint256 index) external view returns (address) {
        return address(boxes[index]);
    }
}
