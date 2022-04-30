// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/**
* @title Cosmic Universe Game Storage interface
* @author @DirtyCajunRice
*/
interface IGameStorageUpgradeable  {
    function updateSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) external;
    function getSkill(
        address nftAddress,
        uint256 tokenId,
        uint256 treeId,
        uint256 skillId
    ) external view returns (uint256 value);
}