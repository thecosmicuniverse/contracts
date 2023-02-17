// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IStandardERC721.sol";
import "../../common/SharedStructs.sol";

interface ICosmicTools is IStandardERC721, SharedStructs {
    struct Tool {
        uint256 skillId;
        uint256 durability;
        Rarity rarity;
    }

    function mint(address to, bytes calldata data) external;
    function setMaxDurability(uint256 tokenId) external;
    function getDurability(uint256 tokenId) external view returns(uint256 current, uint256 max);
    function getTool(uint256 tokenId) external view returns(Tool memory);
    function removeDurability(uint256 tokenId, uint256 amount) external;
}