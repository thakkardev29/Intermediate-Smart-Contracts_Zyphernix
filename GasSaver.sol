// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract GasSaver {
    struct Proposal {
        string name;
        uint256 voteCount;
    }

    Proposal[] public proposals;
    mapping(address => bool) public hasVoted;

    constructor(string[] memory proposalNames) {
        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function vote(uint256 proposalIndex) external {
        require(!hasVoted[msg.sender], "Already voted");
        hasVoted[msg.sender] = true;
        Proposal storage proposal = proposals[proposalIndex];
        proposal.voteCount += 1;
    }

    function winningProposal() external view returns (string memory winnerName, uint256 votes) {
        uint256 winningVoteCount;
        uint256 proposalsLength = proposals.length; 

        for (uint256 i = 0; i < proposalsLength; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winnerName = proposals[i].name;
                votes = winningVoteCount;
            }
        }
    }
}
