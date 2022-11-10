// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";

import "./extensions/ERC721EnumerableExtendedUpgradeable.sol";
import "./extensions/ERC721BurnableExtendedUpgradeable.sol";
import "./extensions/CosmicAttributeStorageUpgradeable.sol";
import "./extensions/ERC721URITokenJSON.sol";
import "../utils/TokenConstants.sol";
import "../utils/Blacklistable.sol";

/**
* @title Cosmic Elves v1.0.0
* @author @DirtyCajunRice
*/
contract CosmicElves is Initializable, ERC721Upgradeable, PausableUpgradeable, AccessControlEnumerableUpgradeable,
ERC721BurnableExtendedUpgradeable, ERC721EnumerableExtendedUpgradeable,
ERC721URITokenJSON, CosmicAttributeStorageUpgradeable, Blacklistable, TokenConstants  {
    using StringsUpgradeable for uint256;
    using TokenMetadata for string;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __ERC721_init("Cosmic Elves", "ELVES");
        __ERC721EnumerableExtended_init();
        __ERC721URITokenJSON_init();
        __Pausable_init();
        __AccessControlEnumerable_init();
        __ERC721BurnableExtended_init();
        __CosmicAttributeStorage_init();

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());
    }

    function mint(address to, uint256 tokenId) public onlyRole(MINTER_ROLE) {
        _safeMint(to, tokenId);
    }

    function batchMint(address to, uint256[] memory tokenIds) public onlyRole(MINTER_ROLE) {
    for (uint256 i = 0; i < tokenIds.length; i++) {
            _safeMint(to, tokenIds[i]);
        }
    }

    function tokenURIJSON(uint256 tokenId) public view virtual override returns(string memory) {
        uint256 gender = getSkill(tokenId, 0, 0);
        string memory name = string(abi.encodePacked('Cosmic ', gender == 0 ? 'Male' : 'Female', ' Elf #', tokenId.toString()));
        TokenMetadata.Attribute[] memory attributes = new TokenMetadata.Attribute[](26);

        // base (11)
        uint256 baseSkillNameId = gender == 0 ? 0 : 11;
        for (uint256 i = 0; i < 11; i++) {
            attributes[i] = TokenMetadata.Attribute(getSkillName(0, i), '', getSkillName(1000 + i, baseSkillNameId + getSkill(tokenId, 0, i)), false);
        }
        // Elven Adventures / Expeditions (3)
        for (uint256 i = 0; i < 3; i++) {
            attributes[i + 11] = TokenMetadata.Attribute(getSkillName(3, i), '', getSkill(tokenId, 3, i) == 0 ? 'False' : 'True', false);
        }
        // Professions (12)
        for (uint256 i = 0; i < 12; i++) {
            attributes[i + 14] = TokenMetadata.Attribute(getSkillName(1, i), 'number', getSkill(tokenId, 1, i).toString(), false);
        }

        return makeMetadataJSON(tokenId, name, 'A Cosmic Elf', attributes);
    }

    // PAUSER_ROLE Functions

    /**
    * @notice Pause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to stop the execution of
    *      updateSkill and transferFrom functions
    */
    function pause() public onlyRole(ADMIN_ROLE) {
        _pause();
    }

    /**
    * @notice Unpause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to resume the execution of
    *      the upgrade2DWizards and transferFrom functions
    */
    function unpause() public onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    function setImageBaseURI(string memory _imageBaseURI) public onlyRole(ADMIN_ROLE) {
        imageBaseURI = _imageBaseURI;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721URITokenJSON, ERC721Upgradeable) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721Upgradeable) {
        super._burn(tokenId);
    }

    function _exists(uint256 tokenId) internal view virtual
    override(ERC721Upgradeable, ERC721BurnableExtendedUpgradeable) returns (bool) {
        return super._exists(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    whenNotPaused
    notBlacklisted(from)
    notBlacklisted(to)
    override(ERC721Upgradeable, ERC721EnumerableExtendedUpgradeable, ERC721BurnableExtendedUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view
    override(
        ERC721Upgradeable,
        ERC721EnumerableExtendedUpgradeable,
        AccessControlEnumerableUpgradeable,
        ERC721BurnableExtendedUpgradeable
    ) returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}