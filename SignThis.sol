// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SignThis {
    mapping(address => bool) public hasEntered;
    address public eventOrganizer; 


    constructor(address _organizer) {
        eventOrganizer = _organizer;
    }

    function enterEvent(address attendee, bytes memory signature) external {
        require(!hasEntered[attendee], "Already entered");

        bytes32 messageHash = keccak256(abi.encodePacked(attendee));
        bytes32 ethSignedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash));

        
        address signer = recoverSigner(ethSignedHash, signature);
        require(signer == eventOrganizer, "Invalid signature");

        hasEntered[attendee] = true;
    }

    function recoverSigner(bytes32 _ethSignedHash, bytes memory _signature) public pure returns(address) {
        require(_signature.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }

        return ecrecover(_ethSignedHash, v, r, s);
    }
}
