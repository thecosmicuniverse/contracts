// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

abstract contract Constants {
    uint256 internal constant BASIS_POINTS = 10_000;
    uint256 internal constant MAX_BPS = 1000;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant AUTHORIZED_ROLE = keccak256("AUTHORIZED_ROLE");
}