// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/BitMapsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
* @title ERC1155 Soulbound v1.0.0
* @author @DirtyCajunRice
* @dev Contract to lock items to wallets
*/
abstract contract ERC1155Soulbound is Initializable, AccessControlEnumerableUpgradeable {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
    using BitMapsUpgradeable for BitMapsUpgradeable.BitMap;

    bytes32 public constant SOULBOUND_WHITELIST_ROLE = keccak256("SOULBOUND_WHITELIST_ROLE");
    bytes32 private constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    BitMapsUpgradeable.BitMap private _soulbound;

    EnumerableSetUpgradeable.AddressSet private _globalWhitelist;

    modifier notSoulbound(uint256[] memory tokenIds, address from, address to) {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(
                ! _soulbound.get(tokenIds[i])
                || from == address(0)
                || to == address(0)
                || hasRole(SOULBOUND_WHITELIST_ROLE, from)
                || hasRole(SOULBOUND_WHITELIST_ROLE, to),
                "Token is soulbound"
            );
        }
        _;
    }
    function __ERC1155Soulbound_init() internal onlyInitializing {
        __AccessControlEnumerable_init();
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(SOULBOUND_WHITELIST_ROLE, _msgSender());
    }

    function setSoulbound(uint256 tokenId) public onlyRole(ADMIN_ROLE) {
        _soulbound.set(tokenId);
    }

    function unsetSoulbound(uint256 tokenId) public onlyRole(ADMIN_ROLE) {
        _soulbound.unset(tokenId);
    }


    uint256[46] private __gap;
}