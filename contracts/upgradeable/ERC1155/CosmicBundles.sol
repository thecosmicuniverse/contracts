// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./extensions/ERC1155AttributeStorage.sol";
import "./extensions/ERC1155URITokenJSON.sol";
import "./extensions/ERC1155Soulbound.sol";
import "./extensions/ERC1155Metadata.sol";
import "./interfaces/CosmicStructs.sol";
import "./extensions/ERC1155Supply.sol";
import "../utils/TokenConstants.sol";
import "../utils/Blacklistable.sol";

/**
* @title Cosmic Bundles v1.0.0
* @author @DirtyCajunRice
*/
contract CosmicBundles is Initializable, ERC1155Upgradeable, AccessControlEnumerableUpgradeable, PausableUpgradeable,
ERC1155BurnableUpgradeable, ERC1155Supply, Blacklistable, TokenConstants, CosmicStructs, ERC1155AttributeStorage,
ERC1155URITokenJSON, ERC1155Soulbound, ERC1155Metadata {

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC1155_init("");
        __AccessControlEnumerable_init();
        __Pausable_init();
        __ERC1155Burnable_init();
        __ERC1155Supply_init();

        __Blacklistable_init();
        __ERC1155Soulbound_init();
        __ERC1155URITokenJSON_init("https://images.cosmicuniverse.io/cosmic-bundles/");
        __ERC1155AttributeStorage_init();
        __ERC1155Metadata_init("Cosmic Bundles", "BUNDLES");
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());
    }

    function pause() public onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyRole(MINTER_ROLE) {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public onlyRole(MINTER_ROLE) {
        _mintBatch(to, ids, amounts, data);
    }

    function mintBatchOf(uint256 id, address[] memory to, uint256[] memory amounts) public onlyRole(MINTER_ROLE) {
        for (uint256 i = 0; i < to.length; i++) {
            _mint(to[i], id, amounts[i], '');
        }
    }

    function burnBatch(address from, uint256[] memory ids, uint256[] memory amounts) override(ERC1155BurnableUpgradeable) public onlyRole(ADMIN_ROLE) {
        _burnBatch(from, ids, amounts);
    }

    function uri(uint256 tokenId) public view virtual override(ERC1155Upgradeable, ERC1155URITokenJSON) returns(string memory) {
        string memory name = getAttributeName(tokenId, 1000);
        string memory description = getAttributeName(tokenId, 1001);

        uint256[] memory attributeValues;
        string[] memory attributeNames;
        (, attributeValues, attributeNames) = getAllAttributes(tokenId);
        Attribute[] memory attributes = new Attribute[](attributeValues.length);

        for (uint256 i = 0; i < attributeValues.length; i++) {
            attributes[i] = Attribute(attributeNames[i], '', attributeValues[i]);
        }
        return _makeBase64(_makeJSON(tokenId, name, description, attributes));
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
    internal
    whenNotPaused
    notSoulbound(ids, from, to)
    override(ERC1155Upgradeable, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC1155Upgradeable, AccessControlEnumerableUpgradeable)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}