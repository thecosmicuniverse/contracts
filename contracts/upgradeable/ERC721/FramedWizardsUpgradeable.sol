// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";

import "./extensions/ERC721EnumerableExtendedUpgradeable.sol";
import "./extensions/ERC721URIStorageExtendedUpgradeable.sol";
import "./extensions/ERC721BurnableExtendedUpgradeable.sol";
import "../utils/TokenConstants.sol";

/**
* @title Framed Wizards v1.0.0
* @author @DirtyCajunRice
*/
contract FramedWizardsUpgradeable is Initializable, ERC721Upgradeable, ERC721EnumerableExtendedUpgradeable,
ERC721URIStorageExtendedUpgradeable, PausableUpgradeable, AccessControlEnumerableUpgradeable,
ERC721BurnableExtendedUpgradeable, TokenConstants {
    using StringsUpgradeable for uint256;
    using StringsUpgradeable for address;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    EnumerableSetUpgradeable.AddressSet private _blacklist;

    modifier notBlacklisted(address _address) {
        require(!_blacklist.contains(_address), "Blacklisted address");
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
    function initialize() public initializer {
        __ERC721_init("Framed Wizards", "FRAMEDWIZARD");
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

    function setTokenURI(uint256 token, bytes memory uri) public onlyRole(ADMIN_ROLE) {
        _presetTokenURI(token, uri);
    }

    function setTokenURIs(uint256[] memory tokens, bytes[] memory uris) public onlyRole(ADMIN_ROLE) {
        require(tokens.length > 0, "No tokens passed");
        require(tokens.length == uris.length, "Mismatched arrays");
        for (uint256 i = 0; i < tokens.length; i++) {
            _presetTokenURI(tokens[i], uris[i]);
        }
    }

    // Overrides
    function tokenURI(uint256 tokenId) public view virtual override(ERC721Upgradeable, ERC721URIStorageExtendedUpgradeable) returns (string memory) {
        string memory imageURI = string(abi.encodePacked("https://images.cosmicuniverse.io/framed-wizards/", tokenId.toString()));
        address owner = ownerOf(tokenId);
        bytes memory dataURIGeneral = abi.encodePacked(
            '"name":"Framed Wizard #', tokenId.toString(), '",',
            '"description":"Framed picture of a 2D Cosmic Wizard",',
            '"image":"', imageURI, '",',
            '"owner":"', owner.toHexString(), '",',
            '"type":"ERC721",',
            '"attributes": []'
        );
        bytes memory dataURI = abi.encodePacked('{', string(dataURIGeneral), '}');
        return string(abi.encodePacked("data:application/json;base64,", Base64Upgradeable.encode(dataURI)));
    }

    function batchTokenURI(uint256[] memory tokenIds) public view returns(string[] memory) {
        string[] memory uris = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uris[i] = tokenURI(tokenIds[i]);
        }
        return uris;
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
