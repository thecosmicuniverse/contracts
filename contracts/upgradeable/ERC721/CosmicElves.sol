// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";

import "./extensions/ERC721EnumerableExtended.sol";
import "./extensions/ERC721BurnableExtendedUpgradeable.sol";
import "./extensions/CosmicAttributeStorageUpgradeable.sol";
import "./extensions/ERC721URITokenJSON.sol";
import "./interfaces/IStandardERC721.sol";
import "./interfaces/ICosmicElves.sol";
import "../utils/TokenConstants.sol";
import "../utils/Blacklistable.sol";
import "../library/Elves.sol";

/**
* @title Cosmic Elves v1.0.0
* @author @DirtyCajunRice
*/
contract CosmicElves is Initializable, ERC721Upgradeable, PausableUpgradeable, AccessControlEnumerableUpgradeable,
ERC721BurnableExtendedUpgradeable, ERC721EnumerableExtended,
ERC721URITokenJSON, CosmicAttributeStorageUpgradeable, Blacklistable, TokenConstants, IStandardERC721  {
    using StringsUpgradeable for uint256;
    using TokenMetadata for string;
    using LibElves for uint256[];

    address public bridgeContract;

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
        uint256[] memory baseSkills = new uint256[](11);
        for (uint256 i = 0; i < 11; i++) {
            baseSkills[i] = getSkill(tokenId, 0, i);
            attributes[i] = TokenMetadata.Attribute(getSkillName(0, i), '', getSkillName(1000 + i + baseSkillNameId, baseSkills[i]), TokenMetadata.DisplayType.Text);
        }
        // Elven Adventures Unlocked / Character Active (2)
        attributes[11] = TokenMetadata.Attribute('', '', getSkill(tokenId, 3, 0) == 0 ? 'Adventures Locked' : 'Adventures Unlocked', TokenMetadata.DisplayType.Value);
        attributes[12] = TokenMetadata.Attribute("", '', getSkill(tokenId, 3, 1) == 0 ? 'Not On Adventure' : 'On Adventure', TokenMetadata.DisplayType.Value);
        for (uint256 i = 0; i < 2; i++) {


        }
        // Professions (12)
        for (uint256 i = 0; i < 12; i++) {
            attributes[i + 13] = TokenMetadata.Attribute(getSkillName(1, i), '', getSkill(tokenId, 1, i).toString(), TokenMetadata.DisplayType.Number);
        }

        attributes[25] = TokenMetadata.Attribute("Rarity Bonus", 'boost_percentage', baseSkills.getRarityBonus().toString(), TokenMetadata.DisplayType.Special);

        return makeMetadataJSON(tokenId, name, 'A Cosmic Elf', attributes);
    }

    function getRarityBonus(uint256 tokenId) public view returns(uint256) {
        uint256[] memory baseSkills = new uint256[](11);
        for (uint256 i = 0; i < 11; i++) {
            baseSkills[i] = getSkill(tokenId, 0, i);
        }
        return baseSkills.getRarityBonus();
    }

    function mint(address to, uint256 tokenId, bytes memory data) public onlyRole(MINTER_ROLE) {
        (ICosmicElves.Elf memory elf) = abi.decode(data, (ICosmicElves.Elf));
        uint256[] memory baseIds = new uint256[](11);
        uint256[] memory adventuresIds = new uint256[](3);
        uint256[] memory professionsIds = new uint256[](12);
        for (uint256 i = 0; i < 12; i++) {
            professionsIds[i] = i;
            if (i < 11) {
                baseIds[i] = i;
            }
            if (i < 3) {
                adventuresIds[i] = i;
            }
        }
        _safeMint(to, tokenId);
        batchUpdateSkillsOfToken(tokenId, 0, baseIds, elf.base);
        batchUpdateSkillsOfToken(tokenId, 3, adventuresIds, elf.adventures);
        batchUpdateSkillsOfToken(tokenId, 1, professionsIds, elf.professions);
        _removeBurnedId(tokenId);
    }

    function bridgeExtraData(uint256 tokenId) external view returns(bytes memory) {
        uint256[] memory baseIds = new uint256[](11);
        uint256[] memory adventuresIds = new uint256[](3);
        uint256[] memory professionsIds = new uint256[](12);
        for (uint256 i = 0; i < 12; i++) {
            professionsIds[i] = i;
            if (i < 11) {
                baseIds[i] = i;
            }
            if (i < 3) {
                adventuresIds[i] = i;
            }
        }
        ICosmicElves.Elf memory elf = ICosmicElves.Elf({
            base: getSkillsByTree(tokenId, 0, baseIds),
            adventures: getSkillsByTree(tokenId, 3, adventuresIds),
            professions: getSkillsByTree(tokenId, 1, professionsIds)
        });

        return abi.encode(elf);
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

    function setBridgeContract(address _bridgeContract) public onlyRole(ADMIN_ROLE) {
        bridgeContract = _bridgeContract;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721URITokenJSON, ERC721Upgradeable) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function burn(uint256 tokenId) public virtual override(IStandardERC721, ERC721BurnableExtendedUpgradeable) {
        super.burn(tokenId);
    }

    function teleport(uint256 tokenId) external onlyRole(ADMIN_ROLE) {
        super._burn(tokenId);
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
