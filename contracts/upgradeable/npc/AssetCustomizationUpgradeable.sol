// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableMapUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../storage/IGameStorageUpgradeable.sol";

/**
* @title Cosmic Universe Asset Customization v1.8.0
* @author @DirtyCajunRice
*/
contract AssetCustomizationUpgradeable is Initializable, PausableUpgradeable, AccessControlUpgradeable {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.Bytes32Set;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.UintToAddressMap;

    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");

    uint256 private constant NAME_CUSTOM_ID = 0;

    IGameStorageUpgradeable private gameStorage;
    IERC20Upgradeable private feeToken;

    uint256 public nameChangeCost;
    address public treasury;

    EnumerableSetUpgradeable.Bytes32Set private _allNames;
    EnumerableSetUpgradeable.AddressSet private _allowedAssets;

    modifier onlyOwnerOf(address nftAddress, uint256 tokenId) {
        require(IERC721Upgradeable(nftAddress).ownerOf(tokenId) == _msgSender(), "AssetCustomization: Not Owner");
        _;
    }

    modifier onlyEnabled(address nftAddress) {
        require(_allowedAssets.contains(nftAddress), "AssetCustomization: Not Owner");
        _;
    }

    event NameChanged(address indexed from, address indexed nftAddress, uint256 tokenId, string name);
    event NameReset(address indexed from, address indexed nftAddress, uint256 tokenId);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Pausable_init();
        __AccessControl_init();
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(UPDATER_ROLE, _msgSender());
        gameStorage = IGameStorageUpgradeable(0x3a55FFC97D2183d94147c4D2d3b6991f0C09ABf4);
        feeToken = IERC20Upgradeable(0x9A8E0217cD870783c3f2317985C57Bf570969153);
        treasury = 0xD2578A0b2631E591890f28499E9E8d73F21e5895;
        nameChangeCost = 125 ether; // 125 MAGIC
    }

    /// PUBLIC

    function setNameOf(address nftAddress, uint256 tokenId, string memory name) public
    whenNotPaused onlyOwnerOf(nftAddress, tokenId) onlyEnabled(nftAddress) {
        string memory stored = nameOf(nftAddress, tokenId);
        bytes memory storedBytes = bytes(stored);
        bytes memory nameBytes = bytes(name);
        require(nameBytes.length > 0, "AssetCustomization: Empty name");
        require(bytes32(nameBytes) != bytes32(storedBytes), "AssetCustomization: Name unchanged");
        require(_allNames.add(bytes32(nameBytes)), "AssetCustomization: Name unavailable");
        if (_allNames.contains(bytes32(storedBytes))) {
            _allNames.remove(bytes32(storedBytes));
        }
        feeToken.transferFrom(_msgSender(), treasury, nameChangeCost);
        gameStorage.updateString(nftAddress, tokenId, NAME_CUSTOM_ID, name);

        emit NameChanged(_msgSender(), nftAddress, tokenId, name);
    }

    function resetNameOf(address nftAddress, uint256 tokenId)
    public whenNotPaused onlyOwnerOf(nftAddress, tokenId) onlyEnabled(nftAddress) {
        string memory stored = nameOf(nftAddress, tokenId);
        bytes memory storedBytes = bytes(stored);
        if (storedBytes.length > 0) {
            _allNames.remove(bytes32(storedBytes));
            gameStorage.updateString(nftAddress, tokenId, NAME_CUSTOM_ID, "");
        }

        emit NameReset(_msgSender(), nftAddress, tokenId);
    }

    function nameOf(address nftAddress, uint256 tokenId) public view returns(string memory) {
        return gameStorage.getString(nftAddress, tokenId, NAME_CUSTOM_ID);
    }

    function namesOf(address nftAddress, uint256[] memory tokenIds) public view returns(string[] memory) {
        return gameStorage.getStringOfTokens(nftAddress, tokenIds, NAME_CUSTOM_ID);
    }

    /// Admin

    function enableAsset(address nftAddress) public onlyRole(UPDATER_ROLE) {
        _allowedAssets.add(nftAddress);
    }

    function disableAsset(address nftAddress) public onlyRole(UPDATER_ROLE) {
        _allowedAssets.remove(nftAddress);
    }

    function setFee(IERC20Upgradeable token, uint256 fee) public onlyRole(DEFAULT_ADMIN_ROLE) {
        feeToken = token;
        nameChangeCost = fee;
    }

    function setTreasury(address _address) public onlyRole(DEFAULT_ADMIN_ROLE) {
        treasury = _address;
    }

    function setGameStorage(IGameStorageUpgradeable _address) public onlyRole(DEFAULT_ADMIN_ROLE) {
        gameStorage = _address;
    }

    /**
    * @dev Pause contract write functions
    */
    function pause() public onlyRole(UPDATER_ROLE) {
        _pause();
    }

    /**
    * @dev Unpause contract write functions
    */
    function unpause() public onlyRole(UPDATER_ROLE) {
        _unpause();
    }
}