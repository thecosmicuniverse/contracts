// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";

interface ICosmicElvesTicket is IERC721Upgradeable {
    function batchDiscountOf(uint256[] memory tokenIds) external view returns(uint256[] memory);
    function burn(uint256 tokenId) external;
    function lastTokenId() external view returns(uint256);
}