// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IlMagic is IERC20Upgradeable {
    function cap() external view returns (uint256);
    function mint(address to, uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;
    function burn(address account, uint256 amount) external;
}