// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

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

/**
* @title Cosmic Wizards v2.0.0
* @author @DirtyCajunRice
*/
contract CosmicWizardsUpgradeable is Initializable, ERC721Upgradeable, ERC721EnumerableExtendedUpgradeable,
ERC721URIStorageExtendedUpgradeable, PausableUpgradeable, AccessControlEnumerableUpgradeable,
ERC721BurnableExtendedUpgradeable, TokenConstants {
    using StringsUpgradeable for uint256;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    EnumerableSetUpgradeable.AddressSet private _blacklist;

    /// CosmicAttributeStorage
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");
    // tokenId > treeId  > skillId > value
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) private _store;
    // tokenId > customId  > stringValue
    mapping(uint256 => mapping(uint256 => string)) private _textStore;
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
    function tokenURI(uint256 tokenId) public view virtual
    override(ERC721Upgradeable, ERC721URIStorageExtendedUpgradeable) returns (string memory) {
        bytes memory dataURIGeneral = getGeneralDataUri(tokenId);
        bytes memory dataURIProfessions = getProfessionDataUri(tokenId);
        bytes memory dataURIStaking = getStakingDataUri(tokenId);
        bytes memory dataURIAttributes = getAttributesDataUri(tokenId);

        bytes memory dataURI = abi.encodePacked(
            '{',
                string(dataURIGeneral),
                string(dataURIProfessions),
                string(dataURIStaking),
                string(dataURIAttributes),
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64Upgradeable.encode(dataURI)
            )
        );
    }

    function getGeneralDataUri(uint256 tokenId) internal view returns(bytes memory) {
        string memory customName = _textStore[tokenId][0];
        string memory gender = _store[tokenId][0][0] == 0 ? 'Male' : 'Female';
        string memory imageURI = string(abi.encodePacked(imageBaseURI, tokenId.toString()));
        return abi.encodePacked(
            '"name": "Cosmic ', gender, ' Wizard #', tokenId.toString(), '", ',
            '"customName": "', customName, '", ',
            '"description": "A Cosmic Wizard", ',
            '"image": "', imageURI, '", '
        );
    }

    function getProfessionDataUriFirst6(uint256 tokenId) internal view returns(bytes memory) {
        string memory alchemy = _store[tokenId][1][0].toString();
        string memory architecture = _store[tokenId][1][1].toString();
        string memory carpentry = _store[tokenId][1][2].toString();
        string memory cooking = _store[tokenId][1][3].toString();
        string memory crystalExtraction = _store[tokenId][1][4].toString();
        string memory farming = _store[tokenId][1][5].toString();
        return abi.encodePacked(
            '"alchemy": ', alchemy, ', ',
            '"architecture": ', architecture, ', ',
            '"carpentry": ', carpentry, ', ',
            '"cooking": ', cooking, ', ',
            '"crystalExtraction": ', crystalExtraction, ', ',
            '"farming": ', farming, ', '
        );

    }
    function getProfessionDataUriSecond6(uint256 tokenId) internal view returns(bytes memory) {
        string memory fishing = _store[tokenId][1][6].toString();
        string memory gemCutting = _store[tokenId][1][7].toString();
        string memory herbalism = _store[tokenId][1][8].toString();
        string memory mining = _store[tokenId][1][9].toString();
        string memory tailoring = _store[tokenId][1][10].toString();
        string memory woodcutting = _store[tokenId][1][11].toString();
        return abi.encodePacked(
            '"fishing": ', fishing, ', ',
            '"gemCutting": ', gemCutting, ', ',
            '"herbalism": ', herbalism, ', ',
            '"mining": ', mining, ', ',
            '"tailoring": ', tailoring, ', ',
            '"woodcutting": ', woodcutting
        );
    }

    function getProfessionDataUri(uint256 tokenId) internal view returns(bytes memory) {
        bytes memory first6 = getProfessionDataUriFirst6(tokenId);
        bytes memory second6 = getProfessionDataUriSecond6(tokenId);
        return abi.encodePacked('"professions": {', string(first6), string(second6), '}, ');
    }

    function getStakingDataUri(uint256 tokenId) internal view returns(bytes memory) {
        return abi.encodePacked(
            '"staking": {',
                '"unlocked": ', _store[tokenId][0][9].toString(), ', ',
                '"staked": ', _store[tokenId][0][10].toString(),
            '}, '
        );
    }

    function getAttributesDataUri(uint256 tokenId) internal view returns(bytes memory) {
        bytes memory first3 = abi.encodePacked(
            '{',
                '"trait_type": "gender", ',
                '"value": ', _store[tokenId][0][0].toString(),
            '}, ',
            '{',
                '"trait_type": "background", ',
                '"value": ', _store[tokenId][0][1].toString(),
            '}, ',
            '{',
                '"trait_type": "hair", ',
                '"value": ', _store[tokenId][0][2].toString(),
            '}, '
        );
        bytes memory second3 = abi.encodePacked(
            '{',
                '"trait_type": "hat", ',
                '"value": ', _store[tokenId][0][3].toString(),
            '}, ',
            '{',
                '"trait_type": "eyes", ',
                '"value": ', _store[tokenId][0][4].toString(),
            '}, ',
            '{',
                '"trait_type": "base", ',
                '"value": ', _store[tokenId][0][5].toString(),
            '}, '
        );
        bytes memory third3 = abi.encodePacked(
            '{',
                '"trait_type": "staff", ',
                '"value": ', _store[tokenId][0][6].toString(),
            '}, ',
            '{',
                '"trait_type": "robe", ',
                '"value": ', _store[tokenId][0][7].toString(),
            '}, ',
            '{',
                '"trait_type": "mouth", ',
                '"value": ', _store[tokenId][0][8].toString(),
            '}'
        );
        return abi.encodePacked('"attributes": [', string(first3), string(second3), string(third3), ']');
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
