// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "./extensions/ERC721EnumerableExtended.sol";
import "./extensions/ERC721URIStorageExtendedUpgradeable.sol";
import "./extensions/ERC721BurnableExtendedUpgradeable.sol";
import "./extensions/CosmicAttributeStorageUpgradeable.sol";
import "./interfaces/IStandardERC721.sol";
import "./interfaces/ICosmicWizards.sol";
import "../library/TokenMetadata.sol";
import "../utils/TokenConstants.sol";

/**
* @title Cosmic Wizards v2.0.0
* @author @DirtyCajunRice
*/
contract CosmicWizards is Initializable, ERC721Upgradeable, ERC721EnumerableExtended,
ERC721URIStorageExtendedUpgradeable, PausableUpgradeable, AccessControlEnumerableUpgradeable,
ERC721BurnableExtendedUpgradeable, TokenConstants, IStandardERC721 {
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

    address public bridgeContract;

    event ValueUpdated(uint256 indexed tokenId, uint256 treeId, uint256 skillId, uint256 value);
    event TextUpdated(uint256 indexed tokenId, uint256 customId, string value);

    // ERC-5192
    event Locked(uint256 tokenId);
    event Unlocked(uint256 tokenId);

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

    function mint(address to, uint256 tokenId, bytes memory data) public onlyRole(MINTER_ROLE) {
        (ICosmicWizards.Wizard memory wizard) = abi.decode(data, (ICosmicWizards.Wizard));
        uint256[] memory baseIds = new uint256[](11);
        uint256[] memory professionsIds = new uint256[](12);
        uint256[] memory extraIds = new uint256[](1);
        for (uint256 i = 0; i < 12; i++) {
            professionsIds[i] = i;
            if (i < 11) {
                baseIds[i] = i;
            }
            if (i < 1) {
                extraIds[i] = i;
            }
        }
        _safeMint(to, tokenId);
        batchUpdateSkillsOfToken(tokenId, 0, baseIds, wizard.base);
        batchUpdateSkillsOfToken(tokenId, 1, professionsIds, wizard.professions);
        batchUpdateSkillsOfToken(tokenId, 2, extraIds, wizard.extra);
        _removeBurnedId(tokenId);
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

    function _emitLocked(uint256 tokenId, uint256 locked) internal {
        if (locked == 1) {
            emit Locked(tokenId);
        }
        else if (locked == 0) {
            emit Unlocked(tokenId);
        }
    }

    // CosmicAttributeStorage
    function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) public onlyRole(CONTRACT_ROLE) {
        _store[tokenId][treeId][skillId] = value;
        emit ValueUpdated(tokenId, treeId, skillId, value);
        if (treeId == 0 && skillId == 10) _emitLocked(tokenId, value);
    }

    function batchUpdateSkills(
        uint256[] memory tokenIds,
        uint256[] memory treeIds,
        uint256[] memory skillIds,
        uint256[] memory values) public onlyRole(CONTRACT_ROLE) {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _store[tokenIds[i]][treeIds[i]][skillIds[i]] = values[i];
            if (treeIds[i] == 0 && skillIds[i] == 10) _emitLocked(tokenIds[i], values[i]);
        }
    }

    function batchUpdateSkillsOfToken(
        uint256 tokenId,
        uint256 treeId,
        uint256[] memory skillIds,
        uint256[] memory values) public onlyRole(CONTRACT_ROLE) {
        for (uint256 i = 0; i < skillIds.length; i++) {
            _store[tokenId][treeId][skillIds[i]] = values[i];
            if (treeId == 0 && skillIds[i] == 10) _emitLocked(tokenId, values[i]);
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
        string[8] memory baseNames = ["Background", "Hair", "Hat", "Eyes", "Base", "Staff", "Robe", "Mouth"];
        for (uint256 i = 1; i < 9; i++) {
            attributes[i] = TokenMetadata.Attribute(baseNames[i-1], '', _attributeNameStore[0][gender == 0 ? i : i + 10][_store[tokenId][0][i]], false);
        }

        // staking
        attributes[9] = TokenMetadata.Attribute("Staking Unlocked", '', _store[tokenId][0][9] == 0 ? 'False' : 'True', false);
        attributes[10] = TokenMetadata.Attribute("Staked", '', _store[tokenId][0][10] == 0 ? 'False' : 'True', false);
        // professions
        string[12] memory professionNames = ["Alchemy", "Architecture", "Carpentry", "Cooking", "Crystal Extraction", "Farming", "Fishing", "Gem Cutting", "Herbalism", "Mining", "Tailoring", "Woodcutting"];
        for (uint256 i = 0; i < 12; i++) {
            attributes[i + 11] = TokenMetadata.Attribute(professionNames[i], '', _store[tokenId][1][i].toString(), true);
        }
        // rewards
        attributes[23] = TokenMetadata.Attribute("Chests Claimed", 'boost_number', _store[tokenId][2][0].toString(), true);
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

    function bridgeExtraData(uint256 tokenId) external view returns(bytes memory) {
        uint256[] memory baseIds = new uint256[](11);
        uint256[] memory professionsIds = new uint256[](12);
        uint256[] memory extraIds = new uint256[](1);
        for (uint256 i = 0; i < 12; i++) {
            professionsIds[i] = i;
            if (i < 11) {
                baseIds[i] = i;
            }
            if (i < 1) {
                extraIds[i] = i;
            }
        }
        ICosmicWizards.Wizard memory wizard = ICosmicWizards.Wizard({
            base: getSkillsByTree(tokenId, 0, baseIds),
            professions: getSkillsByTree(tokenId, 1, professionsIds),
            extra: getSkillsByTree(tokenId, 2, extraIds)
        });

        return abi.encode(wizard);
    }

    function adminRescue(address from, address[] memory accounts, uint256[] memory tokenIds) external onlyRole(ADMIN_ROLE) {
        require(accounts.length > 0, "Accounts array empty");
        require(accounts.length == tokenIds.length, "Array length mismatch");
        for (uint256 i = 0; i < accounts.length; i++) {
            _transfer(from, accounts[i], tokenIds[i]);
        }
    }

    function setImageBaseURI(string memory _imageBaseURI) public onlyRole(ADMIN_ROLE) {
        _setImageBaseURI(_imageBaseURI);
    }

    function setBridgeContract(address _bridgeContract) public onlyRole(ADMIN_ROLE) {
        bridgeContract = _bridgeContract;
    }

    function updateOSStakedStatus(uint256 tokenId) public {
        _emitLocked(tokenId, _store[tokenId][0][10]);
    }

    function batchUpdateOSStakedStatus(uint256[] calldata tokenIds) public {
        uint256 count = tokenIds.length;
        for (uint256 i = 0; i < count; i++) {
            _emitLocked(tokenIds[i], _store[tokenIds[i]][0][10]);
        }
    }

    function burn(uint256 tokenId) public virtual override(IStandardERC721, ERC721BurnableExtendedUpgradeable) {
        super.burn(tokenId);
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721Upgradeable, ERC721URIStorageExtendedUpgradeable) {
        super._burn(tokenId);
    }

    function _exists(uint256 tokenId) internal view virtual
    override(ERC721Upgradeable, ERC721BurnableExtendedUpgradeable) returns (bool) {
        return super._exists(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal whenNotPaused notBlacklisted(from) notBlacklisted(to) notActive(firstTokenId)
    override(ERC721Upgradeable, ERC721EnumerableExtended, ERC721BurnableExtendedUpgradeable)
    {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId) public view
    override(
        ERC721Upgradeable,
        ERC721EnumerableExtended,
        AccessControlEnumerableUpgradeable,
        ERC721BurnableExtendedUpgradeable,
        IERC165Upgradeable
    ) returns (bool)
    {
        return interfaceId == type(IStandardERC721).interfaceId || super.supportsInterface(interfaceId);
    }
}
