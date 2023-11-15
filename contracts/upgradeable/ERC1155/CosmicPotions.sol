// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../utils/access/StandardAccessControl.sol";
import "./extensions/ERC1155AttributeStorage.sol";
import "./extensions/ERC1155URITokenJSON.sol";
import "./extensions/ERC1155Soulbound.sol";
import "./interfaces/IStandardERC1155.sol";
import "./extensions/ERC1155Metadata.sol";
import "./interfaces/CosmicStructs.sol";
import "./extensions/ERC1155Supply.sol";
import "../utils/TokenConstants.sol";
import "../utils/Blacklistable.sol";

/**
* @title Cosmic Potions v1.0.0
* @author @DirtyCajunRice
*/
contract CosmicPotions is Initializable, ERC1155Upgradeable, StandardAccessControl, PausableUpgradeable,
ERC1155BurnableUpgradeable, ERC1155Supply, Blacklistable, CosmicStructs, ERC1155AttributeStorage,
ERC1155URITokenJSON, ERC1155Soulbound, ERC1155Metadata, IStandardERC1155 {
    using StringsUpgradeable for uint256;

    address public bridgeContract;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC1155_init("");
        __StandardAccessControl_init();
        __Pausable_init();
        __ERC1155Burnable_init();
        __ERC1155Supply_init();

        __Blacklistable_init();
        __ERC1155Soulbound_init();
        __ERC1155URITokenJSON_init("https://images.cosmicuniverse.io/cosmic-potions/");
        __ERC1155AttributeStorage_init();
        __ERC1155Metadata_init("Cosmic Potions", "POTIONS");

    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyMinter {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external onlyMinter {
        _mintBatch(to, ids, amounts, data);
    }

    function mintBatchOf(uint256 id, address[] calldata to, uint256[] calldata amounts) external onlyMinter {
        for (uint256 i = 0; i < to.length; i++) {
            _mint(to[i], id, amounts[i], '');
        }
    }

    function burnBatch(address from, uint256[] memory ids, uint256[] memory amounts) override(ERC1155BurnableUpgradeable) public onlyAdmin {
        _burnBatch(from, ids, amounts);
    }

    function uri(uint256 tokenId) public view override(ERC1155Upgradeable, ERC1155URITokenJSON) returns(string memory) {
        string memory name = getAttributeName(tokenId, 1000);
        string memory description = getAttributeName(tokenId, 1001);
        // 0 - Type (Potion/Elixir) | 1 - modifier (swiftness) | 2 - boost
        Attribute[] memory attributes = new Attribute[](3);
        attributes[0] = Attribute('Type', '', getAttributeName(tokenId, 0));
        attributes[1] = Attribute('Modifier', '', getAttributeName(tokenId, 1));
        attributes[2] = Attribute(getAttributeName(tokenId, 2), tokenId == 3 ? 'boost_number' : 'boost_percentage', getAttribute(tokenId, 2).toString());

        return _makeBase64(_makeJSON(tokenId, name, description, attributes));
    }

    function bridgeExtraData(uint256 id, uint256 amount) external view returns(bytes memory) {
        return "";
    }

    function pause() public onlyAdmin {
        _pause();
    }

    function unpause() public onlyAdmin {
        _unpause();
    }

    function setBridgeContract(address _bridgeContract) public onlyAdmin {
        bridgeContract = _bridgeContract;
    }

    function burn(address account, uint256 id, uint256 amount) public override(IStandardERC1155, ERC1155BurnableUpgradeable) {
        super.burn(account, id, amount);
    }

    function teleport(address wallet, uint256 id, uint256 amount) external onlyAdmin {
        super._burn(wallet, id, amount);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal whenNotPaused notSoulbound(ids, from, to) override(ERC1155Upgradeable, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC1155Upgradeable, AccessControlEnumerableUpgradeable, IERC165Upgradeable) returns (bool) {
        return type(IStandardERC1155).interfaceId == interfaceId || super.supportsInterface(interfaceId);
    }
}
