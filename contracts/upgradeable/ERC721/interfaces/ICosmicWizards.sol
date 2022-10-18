// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";

interface ICosmicWizards is IERC721Upgradeable {
    function mint(address to, uint256 tokenId) external;
    function getAllTokenIds() external view returns(uint256[] memory);
    function batchTokenURI(uint256[] memory tokenIds) external view returns(string[] memory);
    function batchMint(address to, uint256[] memory tokenIds) external;
    function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) external;
    function batchUpdateSkillsOfToken(uint256 tokenId, uint256 treeId, uint256[] memory skillIds, uint256[] memory values) external;
    function updateString(uint256 tokenId, uint256 customId, string memory value) external;
    function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) external view returns (uint256 value);
    function getSkillsByTree(uint256 tokenId, uint256 treeId, uint256[] memory skillIds) external view returns (uint256[] memory);
    function getString(uint256 tokenId, uint256 customId) external view returns (string memory value);
    function getStrings(uint256 tokenId, uint256[] memory customIds) external view returns (string[] memory);
    function getStringOfTokens(uint256[] memory tokenIds, uint256 customId) external view returns (string[] memory);
}