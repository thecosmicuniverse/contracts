// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableMapUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @dev Extension of ERC1155 that adds tracking of total supply per id.
 *
 * Useful for scenarios where Fungible and Non-fungible tokens have to be
 * clearly identified. Note: While a totalSupply of 1 might mean the
 * corresponding is an NFT, there is no guarantees that no other token with the
 * same id are not going to be minted.
 */
abstract contract ERC1155Supply is Initializable, ERC1155Upgradeable {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.UintToUintMap;

    EnumerableMapUpgradeable.UintToUintMap private _totalSupply;
    EnumerableSetUpgradeable.AddressSet private _owners;
    mapping(address => EnumerableSetUpgradeable.UintSet) private _ownerTokens;

    function __ERC1155Supply_init() internal onlyInitializing {

    }

    /**
     * @dev Total amount of tokens in with a given id.
     */
    function totalSupply(uint256 id) public view virtual returns (uint256) {
        uint256 t = 0;
        (, t) = _totalSupply.tryGet(id);
        return t;
    }

    /**
     * @dev Indicates whether any token exist with a given id, or not.
     */
    function exists(uint256 id) public view virtual returns (bool) {
        return totalSupply(id) > 0;
    }

    /**
     * @dev Array of tokenIds that have been used.
     */
    function activeIds() public view virtual returns(uint256[] memory) {
        uint256 length = _totalSupply.length();
        uint256[] memory ids = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            (ids[i],) = _totalSupply.at(i);
        }
        return ids;
    }

    function tokensOf(address owner) public view virtual returns(uint256[] memory tokenIds, uint256[] memory balances) {
        tokenIds = _ownerTokens[owner].values();
        balances = new uint256[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            balances[i] = balanceOf(owner, tokenIds[i]);
        }
    }

    function balanceOfAll() public view virtual returns(address[] memory owners, uint256[][] memory tokenIds, uint256[][] memory balances) {
        owners = _owners.values();
        tokenIds = new uint256[][](owners.length);
        balances = new uint256[][](owners.length);
        for (uint256 i = 0; i < owners.length; i++) {
            (tokenIds[i], balances[i]) = tokensOf(owners[i]);
        }
        return (owners, tokenIds, balances);
    }

    function removeFrom(address owner, uint256 tokenId, uint256 amount) internal {
        if (owner == address(0)) {
            return;
        }
        uint256 balance = balanceOf(owner, tokenId);
        if (balance - amount == 0) {
            _ownerTokens[owner].remove(tokenId);
        }
    }

    function addTo(address owner, uint256 tokenId) internal {
        if (owner == address(0)) {
            return;
        }
        _ownerTokens[owner].add(tokenId);
        _owners.add(owner);
    }

    function removeIfEmpty(address owner) internal {
        uint256[] memory tokenIds;
        (tokenIds,) = tokensOf(owner);
        if (tokenIds.length == 0) {
            _owners.remove(owner);
        }
    }
    /**
     * @dev See {ERC1155-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);

        if (from == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 supply;
                (, supply) = _totalSupply.tryGet(ids[i]);
                _totalSupply.set(ids[i], supply + amounts[i]);
            }
        }

        if (to == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                uint256 id = ids[i];
                uint256 amount = amounts[i];
                uint256 supply = _totalSupply.get(id);
                require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
                unchecked {
                    _totalSupply.set(id, supply - amount);
                }
            }
        }

        for (uint256 i = 0; i < ids.length; ++i) {
            removeFrom(from, ids[i], amounts[i]);
            addTo(to, ids[i]);
        }
        removeIfEmpty(from);
        removeIfEmpty(to);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[46] private __gap;
}