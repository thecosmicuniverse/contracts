// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
* @title Blacklistable v1.0.0
* @author @DirtyCajunRice
*/
abstract contract Blacklistable is Initializable {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    EnumerableSetUpgradeable.AddressSet private _blacklist;

    modifier notBlacklisted(address user) {
        require(!_blacklist.contains(user), "Blacklisted address");
        _;
    }

    function __Blacklistable_init() internal onlyInitializing {
    }

    function _addBlacklisted(address user) internal virtual {
        _blacklist.add(user);
    }

    function _removeBlacklisted(address user) internal virtual {
        _blacklist.remove(user);
    }

    function isBlacklisted(address user) public view virtual returns(bool) {
        return _blacklist.contains(user);
    }

    function getBlacklisted() public view virtual returns(address[] memory) {
        return _blacklist.values();
    }

    uint256[49] private __gap;
}