// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {ITeleportAsset} from "./ITeleportAsset.sol";

contract BobaTeleportL1 is
Initializable,
PausableUpgradeable,
AccessControlUpgradeable,
ReentrancyGuardUpgradeable,
UUPSUpgradeable
{

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    address public MAGIC;

    address public ELVES;
    address public TOOLS;

    address public COMPONENTS;
    address public POTIONS;
    address public RAW_RESOURCES;
    address public REFINED_RESOURCES;
    address public SKINS;
    address public BUNDLES;
    address public BADGES;

    // materialized balances. fee is (wallet == address) => (token == address(0)) => (id == 0) => (balance == owed);
    mapping(address wallet => mapping(address token => mapping(uint256 id => uint256 balance ))) public materialized;


    address public MAGIC_L2;

    address public ELVES_L2;
    address public TOOLS_L2;

    address public COMPONENTS_L2;
    address public POTIONS_L2;
    address public RAW_RESOURCES_L2;
    address public REFINED_RESOURCES_L2;
    address public SKINS_L2;
    address public BUNDLES_L2;
    address public BADGES_L2;

    event AssetMaterialized(address indexed wallet, address indexed token, uint256 id, uint256 amount);
    
    error NoAssetToMaterialize();
    error InvalidAssetToMaterialize(address wallet, address token, uint256 id, uint256 balance);
    error InsufficientTeleportFee(uint256 sent, uint256 need);
    error ArrayLengthMismatch(uint256 array1, uint256 array2, uint256 array3);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initializes the contract with necessary initial setup
     *
     * The initializer function is a replacement for a constructor in upgradeable contracts.
     * This function can only be called once and is responsible for setting up contract's initial state.
     *
     * The function performs the following operations:
     *   - Initializes the Pausable, StandardAccessControl, UUPSUpgradeable, and ReentrancyGuard contracts.
     *   - Grants DEFAULT_ADMIN_ROLE and ADMIN_ROLE roles to the address deploying the contract.
     *   - Initializes the ChainlinkVRFConsumer contract with a Chainlink Coordinator address,
     *     VRF key hash, subscription ID, and the number of confirmations for processing a VRF request.
     *
     * @dev This function uses initializer modifier from OpenZeppelin's Initializable contract to ensure
     * it can only be called once when deploying the contract
     *
     * @dev The caller of this function should be the one who has the power to pause, upgrade,
     * or perform administrative tasks
     */
    function initialize() public initializer {
        __Pausable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);

        MAGIC = 0x9A8E0217cD870783c3f2317985C57Bf570969153;

        ELVES = 0x9a337A6F883De95f49e05CD7D801d475a40a9C70;
        TOOLS = 0x39Ad4AAfa177f59ed7356fFDBbF36A840075b7A6;

        COMPONENTS = 0xCB9e8C619CF2C27781dAD8F6e5B27fEBB4f1D89C;
        POTIONS = 0x54EC1799Cafa5685F0f1A16537b74c02589b7FCe;
        RAW_RESOURCES = 0xF31dC5F3A6D0af979FC3D8ad7A216E2eA49a1Cb1;
        REFINED_RESOURCES = 0xEacF75f43674a85eae7679E4A67C7FEF004CC7CB;
        SKINS = 0x1A356b2B223eB5eb4221a956C67634B7d5c72910;
        BUNDLES = 0x04AB0F76De2D5ba63082193C66E8ce571A32454E;
        BADGES = 0x03A37A09be3E90bE403e263238c1aCb14a341DEf;

        MAGIC_L2 = 0x245B4C64271e91C9FB6bE1971A0208dD92EFeBDe;

        ELVES_L2 = 0x09692b3a53eB7870F00b342444E4f42e259e7999;
        TOOLS_L2 = 0x0458b679C30AA4B8622742eA9fb2A44660c4a2a1;

        COMPONENTS_L2 = 0x753492646D652987bC20b3e8c72c7A9Be8809f5D;
        POTIONS_L2 = 0x146D129F1aeBae23422D1f4613C75fFE4087329C;
        RAW_RESOURCES_L2 = 0xCE953D1A6be7331EEf06ec9Ac8a4a22a4f2BDfB0;
        REFINED_RESOURCES_L2 = 0x4F82DFbEED2aa0686EB26ddba7a075406b4C6A67;
        SKINS_L2 = 0x9402aDCfb075155c245862a23F713C15E9CD71c7;
        BUNDLES_L2 = 0x69938433cB243721978986a5B3c981A681970212;
        BADGES_L2 = 0x9E2Aa514325e67D3bA78E575cAF6F90fBC628069;
    }

    function materializeNFTsAndMagic(
        uint256[] calldata elvesIds,
        uint256[] calldata toolsIds
    ) external payable whenNotPaused nonReentrant {
        _checkTeleportFee(msg.sender);
        uint256 _materialized = _materializeNFTsAndMagic(msg.sender, elvesIds, toolsIds);
        if (_materialized == 0) revert NoAssetToMaterialize();
    }

    function materializeTokens() external payable whenNotPaused nonReentrant {
        _checkTeleportFee(msg.sender);
        uint256 _materialized = _materializeTokens(msg.sender);
        if (_materialized == 0) revert NoAssetToMaterialize();
    }

    function materializeResources(uint256[] calldata ids) external payable whenNotPaused nonReentrant {
        _checkTeleportFee(msg.sender);
        uint256 _materialized = _materializeResources(msg.sender, ids);
        if (_materialized == 0) revert NoAssetToMaterialize();
    }

    function adminMaterializeNFTsAndMagic(
        address wallet,
        uint256[] calldata elvesIds,
        uint256[] calldata toolsIds
    ) external onlyRole(ADMIN_ROLE) nonReentrant {
        uint256 _materialized = _materializeNFTsAndMagic(wallet, elvesIds, toolsIds);
        if (_materialized == 0) revert NoAssetToMaterialize();
    }

    function adminMaterializeTokens(address wallet) external onlyRole(ADMIN_ROLE) nonReentrant {
        uint256 _materialized = _materializeTokens(wallet);
        if (_materialized == 0) revert NoAssetToMaterialize();
    }

    function adminMaterializeResources(address wallet, uint256[] calldata ids) external onlyRole(ADMIN_ROLE) nonReentrant {
        uint256 _materialized = _materializeResources(wallet, ids);
        if (_materialized == 0) revert NoAssetToMaterialize();
    }

    function _materializeNFTsAndMagic(
        address wallet,
        uint256[] calldata elvesIds,
        uint256[] calldata toolsIds
    ) internal returns (uint256) {
        uint256 _materialized = 0;

        uint256 magic = materialized[wallet][MAGIC_L2][0];
        // ERC20
        if (magic > 0) {
            materialized[wallet][MAGIC_L2][0] = 0;
            _materialized = 1;
            ITeleportAsset(MAGIC).mint(wallet, magic, "");
            emit AssetMaterialized(wallet, MAGIC, 0, magic);
        }

        // ERC721
        if (elvesIds.length > 0) {
            _materialized = 1;
            for (uint256 i = 0; i < elvesIds.length; i++) {
                if (materialized[wallet][ELVES_L2][elvesIds[i]] == 0)
                    revert InvalidAssetToMaterialize(wallet, ELVES, elvesIds[i], 0);
                materialized[wallet][ELVES_L2][elvesIds[i]] = 0;
                ITeleportAsset(ELVES).mint(wallet, elvesIds[i]);
                emit AssetMaterialized(wallet, ELVES, elvesIds[i], 1);
            }
        }

        if (toolsIds.length > 0) {
            _materialized = 1;
            for (uint256 i = 0; i < toolsIds.length; i++) {
                if (materialized[wallet][TOOLS_L2][toolsIds[i]] == 0)
                    revert InvalidAssetToMaterialize(wallet, TOOLS, toolsIds[i], 0);
                materialized[wallet][TOOLS_L2][toolsIds[i]] = 0;
                ITeleportAsset(TOOLS).mint(wallet, toolsIds[i]);
                emit AssetMaterialized(wallet, TOOLS, toolsIds[i], 1);
            }
        }

        return _materialized;
    }

    function _materializeTokens(address wallet) internal returns (uint256) {
        uint256 balance;
        uint256 _materialized = 0;
        // ERC1155

        for (uint256 i = 0; i < 12; i++) {
            if (i < 4) {
                balance = materialized[wallet][POTIONS_L2][i];
                if (balance > 0) {
                    _materialized = 1;
                    materialized[wallet][POTIONS_L2][i] = 0;
                    ITeleportAsset(POTIONS).mint(wallet, i, balance, "");
                    emit AssetMaterialized(wallet, POTIONS, i, balance);
                }
            }
            if (i < 7) {
                balance = materialized[wallet][BUNDLES_L2][i];
                if (balance > 0) {
                    _materialized = 1;
                    materialized[wallet][BUNDLES_L2][i] = 0;
                    ITeleportAsset(BUNDLES).mint(wallet, i, balance, "");
                    emit AssetMaterialized(wallet, BUNDLES, i, balance);
                }

                balance = materialized[wallet][BADGES_L2][i];
                if (balance > 0) {
                    _materialized = 1;
                    materialized[wallet][BADGES_L2][i] = 0;
                    ITeleportAsset(BADGES).mint(wallet, i, balance, "");
                    emit AssetMaterialized(wallet, BADGES, i, balance);
                }
            }

            balance = materialized[wallet][COMPONENTS_L2][i];
            if (balance > 0) {
                _materialized = 1;
                materialized[wallet][COMPONENTS_L2][i] = 0;
                ITeleportAsset(COMPONENTS).mint(wallet, i, balance, "");
                emit AssetMaterialized(wallet, COMPONENTS, i, balance);
            }

            balance = materialized[wallet][SKINS_L2][i];
            if (balance > 0) {
                _materialized = 1;
                materialized[wallet][SKINS_L2][i] = 0;
                ITeleportAsset(SKINS).mint(wallet, i, balance, "");
                emit AssetMaterialized(wallet, SKINS, i, balance);
            }
        }

        return _materialized;
    }

    function _materializeResources(address wallet, uint256[] calldata ids) internal returns (uint256) {
        if (ids.length == 0) revert ArrayLengthMismatch(0, 0, 0);

        uint256 balance;
        uint256 _materialized = 0;
        // ERC1155
        address RESOURCES = REFINED_RESOURCES;
        address RESOURCES_L2 = REFINED_RESOURCES_L2;
        for (uint256 i = 0; i < ids.length; i++) {
            if (ids[i] % 5 != 4) {
                RESOURCES_L2 = isRefinedResourceID(ids[i]) ? REFINED_RESOURCES_L2 : RAW_RESOURCES_L2;
                balance = materialized[wallet][RESOURCES_L2][ids[i]];
                if (balance > 0) {
                    _materialized = 1;
                    materialized[wallet][RESOURCES_L2][ids[i]] = 0;
                    RESOURCES = isRefinedResourceID(i) ? REFINED_RESOURCES : RAW_RESOURCES;
                    ITeleportAsset(RESOURCES).mint(wallet, ids[i], balance, "");
                    emit AssetMaterialized(wallet, RESOURCES, ids[i], balance);
                }
            }
        }

        return _materialized;
    }

    function _checkTeleportFee(address wallet) internal {
        materialized[wallet][address(0)][0] = 0;
        if (wallet != 0x4082e997Ec720A4894EFec53b0d9AabfeeA44cBE) {
            if (msg.value < materialized[wallet][address(0)][0])
                revert InsufficientTeleportFee(msg.value, materialized[wallet][address(0)][0]);
            payable(address(0x4082e997Ec720A4894EFec53b0d9AabfeeA44cBE)).transfer(msg.value);
        }
    }

    function isRefinedResourceID(uint256 id) internal pure returns (bool) {
        return id < 60 || (id >= 105 && id < 120) || (id >= 150 && id < 165);
    }

    function pause() public onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    function addTeleportedAssets(
        address wallet,
        address[] calldata assets,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        uint256 fee
    ) external onlyRole(ADMIN_ROLE) {
        if (assets.length != ids.length && assets.length != amounts.length)
            revert ArrayLengthMismatch(assets.length, ids.length, amounts.length);
        for (uint256 i = 0; i < assets.length; i++) {
            materialized[wallet][assets[i]][ids[i]] = amounts[i];
        }
        materialized[wallet][address(0)][0] += fee;
    }

    /**
     * @notice Internal function to authorize an upgrade to a new smart contract implementation
     *
     * This function allows an address with DEFAULT_ADMIN_ROLE to authorize a new
     * implementation of the smart contract. Upon successful authorization,
     * the proxied contract will point to the new implementation, and all
     * subsequent function calls will be delegated to the new implementation.
     *
     * @dev This function can only be called internally and requires DEFAULT_ADMIN_ROLE.
     * The function overrides the implementation provided by OpenZeppelin's UUPS (Universal
     * Upgradeable Proxy Standard) upgradeable contract library.
     *
     * @param newImplementation Address of the new contract implementation to which
     * the current contract should be upgraded.
     */
    function _authorizeUpgrade(address newImplementation) internal onlyRole(DEFAULT_ADMIN_ROLE) override {}

}
