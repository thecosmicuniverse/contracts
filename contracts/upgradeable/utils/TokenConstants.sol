// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

abstract contract TokenConstants {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256[49] private __gap;
}