// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

import "../extensions/ERC721EnumerableExtended.sol";
import "../extensions/ERC721BurnableExtendedUpgradeable.sol";
import "../extensions/CosmicAttributeStorageUpgradeable.sol";
import "../../utils/access/StandardAccessControl.sol";
import "../extensions/ERC721URITokenJSON.sol";
import "../../utils/Blacklistable.sol";
import "./ICosmicTools.sol";

/**
* @title Cosmic Tools v1.0.0
* @author @DirtyCajunRice
*/
contract CosmicTools is Initializable, ICosmicTools, ERC721Upgradeable, PausableUpgradeable, StandardAccessControl,
ERC721BurnableExtendedUpgradeable, ERC721EnumerableExtended,
ERC721URITokenJSON, CosmicAttributeStorageUpgradeable, Blacklistable  {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using StringsUpgradeable for uint256;
    using TokenMetadata for string;

    CountersUpgradeable.Counter private _counter;

    address public bridgeContract;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __ERC721_init("Cosmic Tools", "TOOLS");
        __ERC721EnumerableExtended_init();
        __ERC721URITokenJSON_init();
        __Pausable_init();
        __StandardAccessControl_init();
        __ERC721BurnableExtended_init();
        __CosmicAttributeStorage_init();
    }

    function mint(address to, uint256 tokenId, bytes memory data) public onlyMinter {
        (Tool memory tool) = abi.decode(data, (Tool));
        updateSkill(tokenId, 0, 0, tool.skillId);
        updateSkill(tokenId, 0, 1, tool.durability);
        updateSkill(tokenId, 0, 2, uint256(tool.rarity));
        _safeMint(to, tokenId);
        _removeBurnedId(tokenId);
    }

    function mint(address to, bytes calldata data) external onlyMinter {
        uint256 tokenId = _counter.current();
        _counter.increment();
        _safeMint(to, tokenId);

        (Tool memory tool) = abi.decode(data, (Tool));
        updateSkill(tokenId, 0, 0, tool.skillId);
        updateSkill(tokenId, 0, 1, maxDurability(tool.rarity));
        updateSkill(tokenId, 0, 2, uint256(tool.rarity));
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721URITokenJSON, ERC721Upgradeable) returns(string memory) {
        return tokenURIJSON(tokenId).toBase64();
    }

    function tokenURIJSON(uint256 tokenId) public view virtual override returns(string memory) {
        uint256 skillId = getSkill(tokenId, 0, 0);
        string memory name = getSkillName(100, skillId);
        Rarity rarity = Rarity(getSkill(tokenId, 0, 2));
        string memory durability = string(abi.encodePacked(getSkill(tokenId, 0, 1).toString(), "/", maxDurability(rarity).toString()));
        TokenMetadata.Attribute[] memory attributes = new TokenMetadata.Attribute[](3);
        attributes[0] = TokenMetadata.Attribute("Profession", '', getSkillName(1, skillId), false);
        attributes[1] = TokenMetadata.Attribute("Durability", '', durability, false);
        attributes[2] = TokenMetadata.Attribute("Rarity", '', rarityString(rarity), false);

        return makeMetadataJSON(tokenId, name, 'Cosmic Tools for Cosmic Universe', attributes);
    }

    function imageURISuffix(uint256 tokenId) internal view override(ERC721URITokenJSON) returns (string memory) {
        uint256 imageId = (getSkill(tokenId, 0, 0) * 15) + getSkill(tokenId, 0, 2);
        return imageId.toString();
    }

    function setBridgeContract(address _bridgeContract) external onlyAdmin {
        bridgeContract = _bridgeContract;
    }

    function getTool(uint256 tokenId) public view returns(Tool memory) {
        Tool memory tool = Tool({
            skillId: getSkill(tokenId, 0, 0),
            durability: getSkill(tokenId, 0, 1),
            rarity: Rarity(getSkill(tokenId, 0, 2))
        });
        return tool;
    }

    function bridgeExtraData(uint256 tokenId) external view returns(bytes memory) {
        return abi.encode(getTool(tokenId));
    }

    function nextId() public view returns (uint256) {
        return _counter.current();
    }

    function setMaxDurability(uint256 tokenId) public onlyContract {
        updateSkill(tokenId, 0, 1, maxDurability(Rarity(getSkill(tokenId, 0, 2))));
    }

    function removeDurability(uint256 tokenId, uint256 amount) public onlyContract {
        uint256 current = getSkill(tokenId, 0, 1);
        require(amount <= current, "CosmicTools::Amount exceeds remaining durability");
        updateSkill(tokenId, 0, 1, current - amount);
    }

    function getDurability(uint256 tokenId) public view returns(uint256 current, uint256 max) {
        return (getSkill(tokenId, 0, 1), maxDurability(Rarity(getSkill(tokenId, 0, 2))));
    }

    function maxDurability(Rarity rarity) internal pure returns(uint256) {
        uint8[5] memory max = [10, 15, 30, 50, 100];
        return uint256(max[uint256(rarity)]);
    }

    function rarityString(Rarity rarity) internal pure returns(string memory) {
        string[5] memory s = ["Common", "Uncommon", "Rare", "Mythical", "Legendary"];
        return s[uint256(rarity)];
    }

    // PAUSER_ROLE Functions

    /**
    * @notice Pause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to stop the execution of
    *      updateSkill and transferFrom functions
    */
    function pause() public onlyAdmin {
        _pause();
    }

    /**
    * @notice Unpause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to resume the execution of
    *      the upgrade2DWizards and transferFrom functions
    */
    function unpause() public onlyAdmin {
        _unpause();
    }

    function setNextId(uint256 id) public onlyAdmin {
        _counter._value = id;
    }

    function setImageBaseURI(string memory _imageBaseURI) public onlyAdmin {
        imageBaseURI = _imageBaseURI;
    }

    function burn(uint256 tokenId) public override(ERC721BurnableExtendedUpgradeable, IStandardERC721) {
        super.burn(tokenId);
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721Upgradeable) {
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
