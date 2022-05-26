// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract TreasuryUpgradeable is 
    Initializable,
    OwnableUpgradeable
{
    function initialize() public initializer {
        __Ownable_init();
    }

    function withdraw(address tokenAddress, uint256 balance) public onlyOwner {
        IERC20Upgradeable(tokenAddress).transfer(_msgSender(), balance);
    }   
}