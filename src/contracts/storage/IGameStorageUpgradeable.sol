// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

/**
* @title Cosmic Universe Game Storage interface v1.3.0
* @author @DirtyCajunRice
*/
interface IGameStorageUpgradeable {
    function getSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId) external view returns (uint256 value);
    function getSkillsByTree(address nftAddress, uint256 tokenId, uint256 treeId, uint256[] memory skillIds) external view returns (uint256[] memory);
    function updateSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) external;
    function getString(address nftAddress, uint256 tokenId, uint256 customId) external view returns (string memory value);
    function getStrings(address nftAddress, uint256 tokenId, uint256[] memory customIds) external view returns (string[] memory);
    function getStringOfTokens(address nftAddress, uint256[] memory tokenIds, uint256 customIds) external view returns (string[] memory);
    function updateString(address nftAddress, uint256 tokenId, uint256 customId, string memory value) external;
}