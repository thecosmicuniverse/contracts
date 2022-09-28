// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableMapUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../interfaces/CosmicStructs.sol";
/**
* @title ERC1155 Attribute Storage v1.0.0
* @author @DirtyCajunRice
* @dev Central storage contract for Cosmic Universe NFTs
*/
abstract contract ERC1155AttributeStorage is Initializable, AccessControlEnumerableUpgradeable, CosmicStructs {
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.UintToUintMap;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");

    // tokenId > attributeId > value
    mapping(uint256 => EnumerableMapUpgradeable.UintToUintMap) private _store;
    // tokenId > attributeId > name
    // id 1000 is always name, and id 1001 is always description, which do not map to _store
    mapping(uint256 => mapping(uint256 => string)) private _storeNames;

    event ValueUpdated(uint256 indexed tokenId, uint256 attributeId, uint256 value);
    event ValuesUpdated(uint256 indexed tokenId, uint256[] attributeIds, uint256[] values);
    event NameUpdated(uint256 indexed tokenId, uint256 attributeId, string name);
    event NamesUpdated(uint256 indexed tokenId, uint256[] attributeIds, string[] names);

    function __ERC1155AttributeStorage_init() internal onlyInitializing {
        __AccessControlEnumerable_init();
        _grantRole(CONTRACT_ROLE, _msgSender());
    }


    function setAttribute(uint256 tokenId, uint256 attributeId, uint256 value) public onlyRole(CONTRACT_ROLE) {
        _store[tokenId].set(attributeId, value);
        emit ValueUpdated(tokenId, attributeId, value);
    }

    function batchSetAttribute(
        uint256 tokenId,
        uint256[] memory attributeIds,
        uint256[] memory values
    ) public onlyRole(CONTRACT_ROLE) {
        for (uint256 i = 0; i < attributeIds.length; i++) {
            _store[tokenId].set(attributeIds[i], values[i]);
        }
        emit ValuesUpdated(tokenId, attributeIds, values);
    }

    function getAttribute(uint256 tokenId, uint256 attributeId) public view returns (uint256) {
        return _store[tokenId].get(attributeId);
    }


    function batchGetAttribute(uint256 tokenId, uint256[] memory attributeIds) public view returns (uint256[] memory) {
        uint256[] memory attributes = new uint256[](attributeIds.length);
        for (uint256 i = 0; i < attributeIds.length; i++) {
            attributes[i] = _store[tokenId].get(attributeIds[i]);
        }
        return attributes;
    }

    function getAllAttributes(uint256 tokenId) internal view returns (uint256[] memory, uint256[] memory, string[] memory) {
        uint256 count = _store[tokenId].length();
        uint256[] memory attributeIds = new uint256[](count);
        uint256[] memory attributeValues = new uint256[](count);
        string[] memory attributeNames = new string[](count);
        for (uint256 i = 0; i < count; i++) {
            (attributeIds[i], attributeValues[i]) = _store[tokenId].at(i);
            attributeNames[i] = _storeNames[tokenId][attributeIds[i]];
        }
        return (attributeIds, attributeValues, attributeNames);
    }

    function getAttributeName(uint256 tokenId, uint256 attributeId) internal view returns (string memory) {
        return _storeNames[tokenId][attributeId];
    }
    function batchGetAttributeName(uint256 tokenId, uint256[] memory attributeIds) internal view returns (string[] memory) {
        string[] memory attributeNames = new string[](attributeIds.length);
        for (uint256 i = 0; i < attributeIds.length; i++) {
            attributeNames[i] = _storeNames[tokenId][attributeIds[i]];
        }
        return attributeNames;
    }

    function setAttributeName(
        uint256 tokenId,
        uint256 attributeId,
        string memory name
    ) public onlyRole(CONTRACT_ROLE) {
        _storeNames[tokenId][attributeId] = name;
        emit NameUpdated(tokenId, attributeId, name);
    }

    function batchSetAttributeName(
        uint256 tokenId,
        uint256[] memory attributeIds,
        string[] memory names
    ) public onlyRole(CONTRACT_ROLE) {
        for (uint256 i = 0; i < attributeIds.length; i++) {
            _storeNames[tokenId][attributeIds[i]] = names[i];
        }
        emit NamesUpdated(tokenId, attributeIds, names);
    }

    uint256[47] private __gap;
}