// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./mixins/MarketCoreUpgradeable.sol";

contract ERC1155 is 
    Initializable,
    OwnableUpgradeable,
    ERC1155Upgradeable
{
    function initialize() public initializer {
        __Ownable_init();
        __ERC1155_init("");
    }

    function batchMint(uint256[] memory ids, uint256[] memory amounts) public onlyOwner {
        _mintBatch(_msgSender(), ids, amounts, "");
    }
}