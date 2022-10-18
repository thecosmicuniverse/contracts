// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

abstract contract ContractConstants {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant CONTRACT_ROLE = keccak256("MINTER_ROLE");

    uint256[48] private __gap;
}