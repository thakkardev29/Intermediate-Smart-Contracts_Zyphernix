// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Insurance {
    AggregatorV3Interface public rainfallOracle;
    address public insurer;
    uint256 public premium;
    uint256 public payout;
    int256 public rainfallThreshold; 

    struct Policy {
        address farmer;
        bool active;
        bool claimed;
    }

    mapping(address => Policy) public policies;

    constructor(address _oracleAddress, uint256 _premium, uint256 _payout, int256 _rainfallThreshold) {
        insurer = msg.sender;
        rainfallOracle = AggregatorV3Interface(_oracleAddress);
        premium = _premium;
        payout = _payout;
        rainfallThreshold = _rainfallThreshold;
    }

    function buyInsurance() external payable {
        require(msg.value == premium, "Must pay exact premium");
        require(!policies[msg.sender].active, "Policy already active");

        policies[msg.sender] = Policy(msg.sender, true, false);
    }

    function claimInsurance() external {
        Policy storage policy = policies[msg.sender];
        require(policy.active, "No active policy");
        require(!policy.claimed, "Already claimed");

        (, int256 rainfall, , , ) = rainfallOracle.latestRoundData();
        require(rainfall < rainfallThreshold, "Rainfall sufficient, no payout");

        policy.claimed = true;
        payable(msg.sender).transfer(payout);
    }

    function fundContract() external payable {}
}
