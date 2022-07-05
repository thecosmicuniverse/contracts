// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20ExtendedUpgradeable is IERC20Upgradeable {
    function cap() external view returns (uint256);
    function mint(address to, uint256 amount) external;
    function burn(address account, uint256 amount) external;
}