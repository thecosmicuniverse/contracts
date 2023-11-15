// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";

interface IStandardERC721 is IERC165Upgradeable, IERC721Upgradeable {
    function mint(address to, uint256 tokenId, bytes memory data) external;
    function burn(uint256 tokenId) external;
    function bridgeExtraData(uint256 tokenId) external view returns(bytes memory);
    function bridgeContract() external returns (address);
}