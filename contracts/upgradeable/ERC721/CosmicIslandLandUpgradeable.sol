// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./extensions/ERC721EnumerableExtendedUpgradeable.sol";
import "./extensions/ERC721URIStorageExtendedUpgradeable.sol";
import "./extensions/ERC721BurnableExtendedUpgradeable.sol";
import "../utils/TokenConstants.sol";

/**
* @title Cosmic Island Land v1.0.0
* @author @DirtyCajunRice
*/
contract CosmicIslandLandUpgradeable is Initializable, ERC721Upgradeable, ERC721EnumerableExtendedUpgradeable,
ERC721URIStorageExtendedUpgradeable, PausableUpgradeable, AccessControlEnumerableUpgradeable,
ERC721BurnableExtendedUpgradeable, TokenConstants {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using StringsUpgradeable for uint256;

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

    // ADMIN_ROLE Functions

    // Overrides
    function tokenURI(uint256 tokenId) public view virtual
    override(ERC721Upgradeable, ERC721URIStorageExtendedUpgradeable) returns (string memory) {
        uint256 latitude = _numericAttributes[tokenId][0];
        uint256 longitude = _numericAttributes[tokenId][1];
        uint256 region = _numericAttributes[tokenId][2];

        string memory imageURI = string(abi.encodePacked(imageBaseURI, tokenId.toString()));

        bytes memory dataURIGeneral = abi.encodePacked(
            '"name": "Cosmic Island Land Plot #', tokenId.toString(), '", ',
            '"description": "Land plot on Cosmic Island", ',
            '"image": "', imageURI, '", '
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

        bytes memory dataURI = abi.encodePacked('{', string(dataURIGeneral), string(dataURIAttributes), '}');
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64Upgradeable.encode(dataURI)
            )
        );
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
