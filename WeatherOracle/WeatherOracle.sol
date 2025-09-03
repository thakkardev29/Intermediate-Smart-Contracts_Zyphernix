// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract WeatherOracle is AggregatorV3Interface {
    int256 private latestRainfall;

    function setRainfall(int256 value) external {
        latestRainfall = value;
    }

    function latestRoundData() 
        external 
        view 
        override 
        returns (uint80, int256, uint256, uint256, uint80) 
    {
        return (0, latestRainfall, 0, block.timestamp, 0);
    }

    function decimals() external pure override returns (uint8) { return 0; }
    function description() external pure override returns (string memory) { return "MockRainfall"; }
    function version() external pure override returns (uint256) { return 1; }
    function getRoundData(uint80) external pure override returns (
        uint80, int256, uint256, uint256, uint80
    ) { revert("Not implemented"); }
}
