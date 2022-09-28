// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./mixins/MarketCoreUpgradeable.sol";

contract ERC20 is 
    Initializable,
    OwnableUpgradeable,
    ERC20Upgradeable
{
    string private currentBaseURI;

    function initialize() public initializer {
        __Ownable_init();
        __ERC20_init("COCOS", "COCOS");
    }

    function mint(uint256 amount) public onlyOwner {
        _mint(_msgSender(), amount);
    }
}