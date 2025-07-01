// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AlertLogger {
    event AlertLogged(string message, uint256 timestamp);

    function logAlert(string memory message) public {
        emit AlertLogged(message, block.timestamp);
    }
}
