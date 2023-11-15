// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

interface IStandardERC1155 is IERC165Upgradeable, IERC1155Upgradeable {
    function mint(address to, uint256 id, uint256 amount, bytes memory data) external;
    function burn(address account, uint256 id, uint256 amount) external;
    function bridgeExtraData(uint256 id, uint256 amount) external view returns(bytes memory);
    function bridgeContract() external returns (address);
}