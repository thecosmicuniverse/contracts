// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./mixins/Constants.sol";

contract TreasuryUpgradeable is Initializable, AccessControlEnumerableUpgradeable, Constants {
    function initialize() public initializer {
        __AccessControlEnumerable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(AUTHORIZED_ROLE, msg.sender);
    }

    function withdraw(address tokenAddress, uint256 balance) public onlyRole(ADMIN_ROLE) {
        IERC20Upgradeable(tokenAddress).transfer(_msgSender(), balance);
    }   
}