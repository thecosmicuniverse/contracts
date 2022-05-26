// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

/**
* @title Cosmic Universe Game Storage interface v1.2.0
* @author @DirtyCajunRice
*/
interface IGameStorageUpgradeable {
    function updateSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) external;
    function getSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId) external view returns (uint256 value);
    function updateTokenString(address nftAddress, uint256 tokenId, uint256 customId, string memory value) external;
    function getSkillsByTree(address nftAddress, uint256 tokenId, uint256 treeId, uint256[] memory skillIds) external view returns (uint256[] memory);
    function getTokenString(address nftAddress, uint256 tokenId, uint256 customId) external view returns (string memory value);
    function getTokenStrings(address nftAddress, uint256 tokenId, uint256[] memory customIds) external view returns (string[] memory);
}