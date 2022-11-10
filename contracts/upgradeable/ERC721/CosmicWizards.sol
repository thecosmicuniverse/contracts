// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "./extensions/ERC721EnumerableExtendedUpgradeable.sol";
import "./extensions/ERC721URIStorageExtendedUpgradeable.sol";
import "./extensions/ERC721BurnableExtendedUpgradeable.sol";
import "./extensions/CosmicAttributeStorageUpgradeable.sol";
import "../utils/TokenConstants.sol";
import "../library/TokenMetadata.sol";

/**
* @title Cosmic Wizards v2.0.0
* @author @DirtyCajunRice
*/
contract CosmicWizards is Initializable, ERC721Upgradeable, ERC721EnumerableExtendedUpgradeable,
ERC721URIStorageExtendedUpgradeable, PausableUpgradeable, AccessControlEnumerableUpgradeable,
ERC721BurnableExtendedUpgradeable, TokenConstants {
    using StringsUpgradeable for uint256;
    using StringsUpgradeable for address;
    using TokenMetadata for string;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    EnumerableSetUpgradeable.AddressSet private _blacklist;

    /// CosmicAttributeStorage
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");
    // tokenId > treeId  > skillId > value
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) private _store;
    // tokenId > customId  > stringValue
    mapping(uint256 => mapping(uint256 => string)) private _textStore;
    // treeId > skillId  > value > stringValue
    mapping(uint256 => mapping(uint256 => mapping(uint256 => string))) private _attributeNameStore;
    event ValueUpdated(uint256 indexed tokenId, uint256 treeId, uint256 skillId, uint256 value);
    event TextUpdated(uint256 indexed tokenId, uint256 customId, string value);

    modifier notActive(uint256 tokenId) {
        require(_store[tokenId][0][10] == 0 || ownerOf(tokenId) == 0x71e9e186DcFb6fd1BA018DF46d21e7aA10969aD1, "Wizard is staked");
        _;
    }

    modifier notBlacklisted(address _address) {
        require(!_blacklist.contains(_address), "Blacklisted address");
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
    function initialize() public initializer {
        __ERC721_init("Cosmic Wizards", "WIZARDS");
        __ERC721EnumerableExtended_init();
        __ERC721URIStorageExtended_init();
        __Pausable_init();
        __AccessControlEnumerable_init();
        __ERC721BurnableExtended_init();

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

    // PAUSER_ROLE Functions

    /**
    * @notice Pause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to stop the execution of
    *      the upgrade2DWizards and transferFrom functions
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

    // CosmicAttributeStorage
    function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) public onlyRole(CONTRACT_ROLE) {
        _store[tokenId][treeId][skillId] = value;
        emit ValueUpdated(tokenId, treeId, skillId, value);
    }

    function batchUpdateSkills(
        uint256[] memory tokenIds,
        uint256[] memory treeIds,
        uint256[] memory skillIds,
        uint256[] memory values) public onlyRole(CONTRACT_ROLE) {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _store[tokenIds[i]][treeIds[i]][skillIds[i]] = values[i];
        }
    }

    function updateString(uint256 tokenId, uint256 customId, string memory value) public onlyRole(CONTRACT_ROLE) {
        _textStore[tokenId][customId] = value;
        emit TextUpdated(tokenId, customId, value);
    }

    function updateAttributeStrings(
        uint256 treeId,
        uint256 skillId,
        uint256[] memory values,
        string[] memory stringValues
    ) public onlyRole(ADMIN_ROLE) {
        for (uint256 i = 0; i < values.length; i++) {
            _attributeNameStore[treeId][skillId][values[i]] = stringValues[i];
        }
    }

    function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) public view returns (uint256 value) {
        return _store[tokenId][treeId][skillId];
    }

    function getSkillsByTree(uint256 tokenId, uint256 treeId, uint256[] memory skillIds) public
    view returns (uint256[] memory) {
        uint256[] memory values = new uint256[](skillIds.length);
        for (uint256 i = 0; i < skillIds.length; i++) {
            values[i] = _store[tokenId][treeId][skillIds[i]];
        }
        return values;
    }

    function getString(uint256 tokenId, uint256 customId) public view returns (string memory value) {
        return _textStore[tokenId][customId];
    }

    function getStrings(uint256 tokenId, uint256[] memory customIds) public view returns (string[] memory) {
        string[] memory values = new string[](customIds.length);
        for (uint256 i = 0; i < customIds.length; i++) {
            values[i] = _textStore[tokenId][customIds[i]];
        }
        return values;
    }

    function getStringOfTokens(uint256[] memory tokenIds, uint256 customId) public view returns (string[] memory) {
        string[] memory values = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            values[i] = _textStore[tokenIds[i]][customId];
        }
        return values;
    }

    // Overrides

    function tokenURI(uint256 tokenId) public view virtual override(ERC721Upgradeable, ERC721URIStorageExtendedUpgradeable) returns (string memory) {
        return tokenURIJSON(tokenId).toBase64();
    }

    function tokenURIJSON(uint256 tokenId) public view returns(string memory) {
        uint256 gender = _store[tokenId][0][0];
        string memory genderString = gender == 0 ? 'Male' : 'Female';
        string memory name = string(abi.encodePacked('Cosmic ', genderString, ' Wizard #', tokenId.toString()));
        TokenMetadata.Attribute[] memory attributes = new TokenMetadata.Attribute[](24);

        // base
        attributes[0] = TokenMetadata.Attribute("Gender", '', genderString, false);
        attributes[1] = TokenMetadata.Attribute("Background", '', _attributeNameStore[0][gender == 0 ? 1 : 11][_store[tokenId][0][1]], false);
        attributes[2] = TokenMetadata.Attribute("Hair", '', _attributeNameStore[0][gender == 0 ? 2 : 12][_store[tokenId][0][2]], false);
        attributes[3] = TokenMetadata.Attribute("Hat", '', _attributeNameStore[0][gender == 0 ? 3 : 13][_store[tokenId][0][3]], false);
        attributes[4] = TokenMetadata.Attribute("Eyes", '', _attributeNameStore[0][gender == 0 ? 4 : 14][_store[tokenId][0][4]], false);
        attributes[5] = TokenMetadata.Attribute("Base", '', _attributeNameStore[0][gender == 0 ? 5 : 15][_store[tokenId][0][5]], false);
        attributes[6] = TokenMetadata.Attribute("Staff", '', _attributeNameStore[0][gender == 0 ? 6 : 16][_store[tokenId][0][6]], false);
        attributes[7] = TokenMetadata.Attribute("Robe", '', _attributeNameStore[0][gender == 0 ? 7 : 17][_store[tokenId][0][7]], false);
        attributes[8] = TokenMetadata.Attribute("Mouth", '', _attributeNameStore[0][gender == 0 ? 8 : 18][_store[tokenId][0][8]], false);
        // staking
        attributes[9] = TokenMetadata.Attribute("Staking Unlocked", '', _store[tokenId][0][9] == 0 ? 'False' : 'True', false);
        attributes[10] = TokenMetadata.Attribute("Staked", '', _store[tokenId][0][10] == 0 ? 'False' : 'True', false);
        // professions
        attributes[11] = TokenMetadata.Attribute("Alchemy", 'number', _store[tokenId][1][0].toString(), false);
        attributes[12] = TokenMetadata.Attribute("Architecture", 'number', _store[tokenId][1][1].toString(), false);
        attributes[13] = TokenMetadata.Attribute("Carpentry", 'number', _store[tokenId][1][2].toString(), false);
        attributes[14] = TokenMetadata.Attribute("Cooking", 'number', _store[tokenId][1][3].toString(), false);
        attributes[15] = TokenMetadata.Attribute("Crystal Extraction", 'number', _store[tokenId][1][4].toString(), false);
        attributes[16] = TokenMetadata.Attribute("Farming", 'number', _store[tokenId][1][5].toString(), false);
        attributes[17] = TokenMetadata.Attribute("Fishing", 'number', _store[tokenId][1][6].toString(), false);
        attributes[18] = TokenMetadata.Attribute("Gem Cutting", 'number', _store[tokenId][1][7].toString(), false);
        attributes[19] = TokenMetadata.Attribute("Herbalism", 'number', _store[tokenId][1][8].toString(), false);
        attributes[20] = TokenMetadata.Attribute("Mining", 'number', _store[tokenId][1][9].toString(), false);
        attributes[21] = TokenMetadata.Attribute("Tailoring", 'number', _store[tokenId][1][10].toString(), false);
        attributes[22] = TokenMetadata.Attribute("Woodcutting", 'number', _store[tokenId][1][11].toString(), false);
        // rewards
        attributes[23] = TokenMetadata.Attribute("Chests Claimed", 'boost_number', _store[tokenId][2][0].toString(), false);
        string memory imageURI = string(abi.encodePacked(imageBaseURI, tokenId.toString()));
        return TokenMetadata.makeMetadataJSON(
            tokenId,
            ownerOf(tokenId),
            name,
            imageURI,
            'A Cosmic Wizard',
            TokenMetadata.TokenType.ERC721,
            attributes
        );
    }

    function batchTokenURI(uint256[] memory tokenIds) public view returns(string[] memory) {
        string[] memory uris = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uris[i] = tokenURI(tokenIds[i]);
        }
        return uris;
    }

    function batchTokenURIJSON(uint256[] memory tokenIds) public view returns(string[] memory) {
        string[] memory uris = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uris[i] = tokenURIJSON(tokenIds[i]);
        }
        return uris;
    }

    function setImageBaseURI(string memory _imageBaseURI) public onlyRole(ADMIN_ROLE) {
        _setImageBaseURI(_imageBaseURI);
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721Upgradeable, ERC721URIStorageExtendedUpgradeable) {
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
    notActive(tokenId)
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
