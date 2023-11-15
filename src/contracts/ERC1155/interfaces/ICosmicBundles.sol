// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

interface ICosmicBundles is IERC1155Upgradeable {
    function mint(address account, uint256 id, uint256 amount, bytes memory data) external;
    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) external;
    function mintBatchOf(uint256 id, address[] memory to, uint256[] memory amounts) external;
    function burnBatch(address from, uint256[] memory ids, uint256[] memory amounts) external;
    function uri(uint256 tokenId) external view returns(string memory);
}