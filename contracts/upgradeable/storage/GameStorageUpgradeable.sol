// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
* @title Cosmic Universe Game Storage v1.2.0
* @author @DirtyCajunRice
* @dev Central storage contract for Cosmic Universe NFTs 
*/
contract GameStorageUpgradeable is Initializable, PausableUpgradeable, AccessControlUpgradeable {

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");

    // nftAddress > tokenId > treeId  > skillId > value
    mapping(address => mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256)))) private _store;

    // nftAddress > tokenId > customId  > stringValue
    mapping(address => mapping(uint256 => mapping(uint256 => string))) private _textStore;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() public initializer {
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

    function updateTokenString(
        address nftAddress,
        uint256 tokenId,
        uint256 customId,
        string memory value
    ) public whenNotPaused onlyRole(UPDATER_ROLE) {
        _textStore[nftAddress][tokenId][customId] = value;
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

    function getSkillsByTree(
        address nftAddress,
        uint256 tokenId,
        uint256 treeId,
        uint256[] memory skillIds
    ) public view returns (uint256[] memory) {
        uint256[] memory values = new uint256[](skillIds.length);
        for (uint256 i = 0; i < skillIds.length; i++) {
            values[i] = _store[nftAddress][tokenId][treeId][skillIds[i]];
        }
        return values;
    }

    function getTokenString(
        address nftAddress,
        uint256 tokenId,
        uint256 customId
    ) public view returns (string memory value) {
        return _textStore[nftAddress][tokenId][customId];
    }

    function getTokenStrings(
        address nftAddress,
        uint256 tokenId,
        uint256[] memory customIds
    ) public view returns (string[] memory) {
        string[] memory values = new string[](customIds.length);
        for (uint256 i = 0; i < customIds.length; i++) {
            values[i] = _textStore[nftAddress][tokenId][customIds[i]];
        }
        return values;
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