// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IProfessionStakingAvalanche {
    function isOwner(uint256 tokenId, address owner) external view returns (bool);
}