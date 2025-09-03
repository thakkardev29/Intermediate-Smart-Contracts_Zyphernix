// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


contract PluginStore {
    struct Profile {
        string name;
        string avatar;
        mapping(bytes4 => address) plugins; 
        uint256 achievementPoints;         
    }

    mapping(address => Profile) private profiles;

    event ProfileSet(address indexed player, string name, string avatar);
    event PluginInstalled(address indexed player, bytes4 indexed selector, address plugin);
    event PluginRemoved(address indexed player, bytes4 indexed selector);

    function setProfile(string calldata _name, string calldata _avatar) external {
        profiles[msg.sender].name = _name;
        profiles[msg.sender].avatar = _avatar;
        emit ProfileSet(msg.sender, _name, _avatar);
    }

    function getProfile(address player) external view returns (string memory, string memory, uint256) {
        Profile storage p = profiles[player];
        return (p.name, p.avatar, p.achievementPoints);
    }

    function addPlugin(bytes4 _selector, address _pluginAddress) external {
        profiles[msg.sender].plugins[_selector] = _pluginAddress;
        emit PluginInstalled(msg.sender, _selector, _pluginAddress);
    }

    function removePlugin(bytes4 _selector) external {
        delete profiles[msg.sender].plugins[_selector];
        emit PluginRemoved(msg.sender, _selector);
    }

    function pluginFor(address player, bytes4 selector) external view returns (address) {
        return profiles[player].plugins[selector];
    }

    function addAchievement(uint256 points) external {
        profiles[msg.sender].achievementPoints += points;
    }

    function getAchievements(address player) external view returns (uint256) {
        return profiles[player].achievementPoints;
    }

    function executePlugin(bytes4 _funcSelector, bytes calldata _data) external returns (bytes memory) {
        address plugin = profiles[msg.sender].plugins[_funcSelector];
        require(plugin != address(0), "Plugin not installed");

        (bool success, bytes memory result) = plugin.delegatecall(_data);
        require(success, "Plugin execution failed");
        return result;
    }
}
