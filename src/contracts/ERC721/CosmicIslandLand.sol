// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./extensions/ERC721EnumerableExtended.sol";
import "./extensions/ERC721URIStorageExtendedUpgradeable.sol";
import "./extensions/ERC721BurnableExtendedUpgradeable.sol";
import "./interfaces/IStandardERC721.sol";
import "../library/TokenMetadata.sol";
import "../utils/TokenConstants.sol";

/**
* @title Cosmic Island Land v1.0.0
* @author @DirtyCajunRice
*/
contract CosmicIslandLand is Initializable, ERC721Upgradeable, ERC721EnumerableExtended,
ERC721URIStorageExtendedUpgradeable, PausableUpgradeable, AccessControlEnumerableUpgradeable,
ERC721BurnableExtendedUpgradeable, TokenConstants, IStandardERC721 {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using StringsUpgradeable for uint256;
    using StringsUpgradeable for address;
    using TokenMetadata for string;

    EnumerableSetUpgradeable.AddressSet private _blacklist;

    enum Region {
        Road,
        Water,
        ElysianFields,
        EnchantedForest,
        MysticAlpines,
        ForestOfWhimsy
    }

    // tokenID => attributeId => numeric value
    // Initially used for latitude (0), longitude (1), and region (2)
    mapping(uint256 => mapping(uint256 => uint256)) private _numericAttributes;

    /// CosmicAttributeStorage
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");
    // tokenId > treeId  > skillId > value
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) private _store;
    // tokenId > customId  > stringValue
    mapping(uint256 => mapping(uint256 => string)) private _textStore;

    address public bridgeContract;

    event ValueUpdated(uint256 indexed tokenId, uint256 treeId, uint256 skillId, uint256 value);
    event TextUpdated(uint256 indexed tokenId, uint256 customId, string value);

    modifier notBlacklisted(address _address) {
        require(!_blacklist.contains(_address), "Blacklisted address");
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
    function initialize() public initializer {
        __ERC721_init("CosmicIsland", "CLAND");
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
        _safeMint(to, tokenId);
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

    // CosmicAttributeStorage
    function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) public onlyRole(CONTRACT_ROLE) {
        _store[tokenId][treeId][skillId] = value;
        emit ValueUpdated(tokenId, treeId, skillId, value);
    }

    function updateString(uint256 tokenId, uint256 customId, string memory value) public onlyRole(CONTRACT_ROLE) {
        _textStore[tokenId][customId] = value;
        emit TextUpdated(tokenId, customId, value);
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

    // ADMIN_ROLE Functions

    // Overrides
    function tokenURI(uint256 tokenId) public view virtual
    override(ERC721Upgradeable, ERC721URIStorageExtendedUpgradeable) returns (string memory) {
        return tokenURIJSON(tokenId).toBase64();
    }

    function batchTokenURI(uint256[] memory tokenIds) public view returns(string[] memory) {
        string[] memory uris = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uris[i] = tokenURI(tokenIds[i]);
        }
        return uris;
    }

    function tokenURIJSON(uint256 tokenId) public view virtual returns (string memory) {
        uint256 latitude = _numericAttributes[tokenId][0];
        uint256 longitude = _numericAttributes[tokenId][1];
        uint256 region = _numericAttributes[tokenId][2];

        string memory imageURI = string(abi.encodePacked(imageBaseURI, tokenId.toString()));
        address owner = ownerOf(tokenId);
        bytes memory dataURIGeneral = abi.encodePacked(
            '"name":"Cosmic Island Land Plot #', tokenId.toString(), '",',
            '"description":"Land plot on Cosmic Island",',
            '"image":"', imageURI, '",',
            '"owner":"', owner.toHexString(), '",',
            '"type":"ERC721",'
        );

        bytes memory dataURIAttributes = abi.encodePacked(
            '"attributes": [',
            '{',
            '"trait_type": "latitude", ',
            '"value": ',  latitude.toString(),
            '}, ',
            '{',
            '"trait_type": "longitude", ',
            '"value": ',  longitude.toString(),
            '}, ',
            '{',
            '"trait_type": "region", ',
            '"value": ', region.toString(),
            '}',
            ']'
        );

        return string(abi.encodePacked('{', string(dataURIGeneral), string(dataURIAttributes), '}'));
    }

    function batchTokenURIJSON(uint256[] memory tokenIds) public view returns(string[] memory) {
        string[] memory uris = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uris[i] = tokenURIJSON(tokenIds[i]);
        }
        return uris;
    }

    function bridgeExtraData(uint256 tokenId) external view returns(bytes memory) {
        return "";
    }

    function setTokenURI(uint256 tokenId, uint256 attrId, uint256 value) public onlyRole(ADMIN_ROLE) {
        _numericAttributes[tokenId][attrId] = value;
    }

    function setTokenURIs(uint256[] memory tokenIds, uint256[] memory attrIds, uint256[] memory values)
    public onlyRole(ADMIN_ROLE) {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _numericAttributes[tokenIds[i]][attrIds[i]] = values[i];
        }
    }

    function setImageBaseURI(string memory _imageBaseURI) public onlyRole(ADMIN_ROLE) {
        imageBaseURI = _imageBaseURI;
    }

    function adminRescue(address from, address[] memory accounts, uint256[] memory tokenIds) external onlyRole(ADMIN_ROLE) {
        require(accounts.length > 0, "Accounts array empty");
        require(accounts.length == tokenIds.length, "Array length mismatch");
        for (uint256 i = 0; i < accounts.length; i++) {
            _transfer(from, accounts[i], tokenIds[i]);
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
    ) internal whenNotPaused notBlacklisted(from) notBlacklisted(to)
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
