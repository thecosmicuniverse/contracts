// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
* @title Cosmic Universe Game Storage v1.0.0
* @author @DirtyCajunRice
*/
contract GameStorageUpgradeable is Initializable, PausableUpgradeable, AccessControlUpgradeable {

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");

    // nftAddress > tokenId > treeId  > skillId > value
    mapping(address => mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256)))) private _store;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() initializer public {
        __Pausable_init();
        __AccessControl_init();

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(PAUSER_ROLE, _msgSender());
        _grantRole(UPDATER_ROLE, _msgSender());
    }

    /**
    * @dev Update a single skill to value
    *
    * @param nftAddress Address of the NFT collection
    * @param tokenId ID of the NFT
    * @param treeId ID of the storage tree
    * @param skillId ID of the skill
    * @param value new skill value
    */
    function updateSkill(
        address nftAddress,
        uint256 tokenId,
        uint256 treeId,
        uint256 skillId,
        uint256 value
    ) public whenNotPaused onlyRole(UPDATER_ROLE) {
        _store[nftAddress][tokenId][treeId][skillId] = value;
    }

    /**
    * @dev Get a single skill value
    *
    * @param nftAddress Address of the NFT collection
    * @param tokenId ID of the NFT
    * @param treeId ID of the storage tree
    * @param skillId ID of the skill
    *
    * @return value skill value
    */
    function getSkill(
        address nftAddress,
        uint256 tokenId,
        uint256 treeId,
        uint256 skillId
    ) public view returns (uint256 value) {
        return _store[nftAddress][tokenId][treeId][skillId];
    }

    /**
    * @dev Pause contract write functions
    */
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /**
    * @dev Unpause contract write functions
    */
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }
}