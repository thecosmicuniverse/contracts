// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

interface IStandardERC20 is IERC165Upgradeable, IERC20Upgradeable {
    function mint(address to, uint256 amount, bytes memory data) external;
    function burn(address from, uint256 amount) external;
    function bridgeContract() external returns (address);
}