// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import { ITeleportAsset } from "./ITeleportAsset.sol";

contract BobaTeleportL2 is Initializable, PausableUpgradeable, AccessControlUpgradeable, ReentrancyGuardUpgradeable, UUPSUpgradeable {

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

    event AssetTeleported(address indexed wallet, address indexed token, uint256 id, uint256 amounts);

    error NoAssetToTeleport();

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

        MAGIC = 0x245B4C64271e91C9FB6bE1971A0208dD92EFeBDe;

        ELVES = 0x09692b3a53eB7870F00b342444E4f42e259e7999;
        TOOLS = 0x0458b679C30AA4B8622742eA9fb2A44660c4a2a1;

        COMPONENTS = 0x753492646D652987bC20b3e8c72c7A9Be8809f5D;
        POTIONS = 0x146D129F1aeBae23422D1f4613C75fFE4087329C;
        RAW_RESOURCES = 0xCE953D1A6be7331EEf06ec9Ac8a4a22a4f2BDfB0;
        REFINED_RESOURCES = 0x4F82DFbEED2aa0686EB26ddba7a075406b4C6A67;
        SKINS = 0x9402aDCfb075155c245862a23F713C15E9CD71c7;
        BUNDLES = 0x69938433cB243721978986a5B3c981A681970212;
        BADGES = 0x9E2Aa514325e67D3bA78E575cAF6F90fBC628069;
    }

    function teleportNFTsAndMagic() external whenNotPaused nonReentrant {
        uint256 teleported = _teleportNFTsAndMagic(msg.sender);
        if (teleported == 0) revert NoAssetToTeleport();
    }

    function teleportTokens() external whenNotPaused nonReentrant {
        uint256 teleported = _teleportTokens(msg.sender);
        if (teleported == 0) revert NoAssetToTeleport();
    }

    function teleportResources() external whenNotPaused nonReentrant {
        uint256 teleported = _teleportResources(msg.sender);
        if (teleported == 0) revert NoAssetToTeleport();
    }

    function adminTeleportNFTsAndMagic(address wallet) external onlyRole(ADMIN_ROLE) nonReentrant {
        uint256 teleported = _teleportNFTsAndMagic(wallet);
        if (teleported == 0) revert NoAssetToTeleport();
    }

    function adminTeleportTokens(address wallet) external onlyRole(ADMIN_ROLE) nonReentrant {
        uint256 teleported = _teleportTokens(wallet);
        if (teleported == 0) revert NoAssetToTeleport();
    }

    function adminTeleportResources(address wallet) external onlyRole(ADMIN_ROLE) nonReentrant {
        uint256 teleported = _teleportResources(wallet);
        if (teleported == 0) revert NoAssetToTeleport();
    }

    function _teleportNFTsAndMagic(address wallet) internal returns (uint256) {
        uint256 teleported = 0;

        // ERC20
        uint256 balance = ITeleportAsset(MAGIC).balanceOf(wallet);
        if (balance > 0) {
            teleported = 1;
            ITeleportAsset(MAGIC).teleport(wallet, balance);
            emit AssetTeleported(wallet, MAGIC, 0, balance);
        }

        // ERC721
        uint256[] memory tokenIds = ITeleportAsset(ELVES).tokensOfOwner(wallet);
        if (tokenIds.length > 0) {
            teleported = 1;
            for (uint256 i = 0; i < tokenIds.length; i++) {
                ITeleportAsset(ELVES).teleport(tokenIds[i]);
                emit AssetTeleported(wallet, ELVES, tokenIds[i], 1);
            }
        }

        tokenIds = ITeleportAsset(TOOLS).tokensOfOwner(wallet);
        if (tokenIds.length > 0) {
            teleported = 1;
            for (uint256 i = 0; i < tokenIds.length; i++) {
                ITeleportAsset(TOOLS).teleport(tokenIds[i]);
                emit AssetTeleported(wallet, TOOLS, tokenIds[i], 1);
            }
        }

        return teleported;
    }

    function _teleportTokens(address wallet) internal returns (uint256) {
        uint256 balance;
        uint256 teleported = 0;
        // ERC1155
        for (uint256 i = 0; i < 12; i++) {
            if (i < 4) {
                balance = ITeleportAsset(POTIONS).balanceOf(wallet, i);
                if (balance > 0) {
                    teleported = 1;
                    ITeleportAsset(POTIONS).teleport(wallet, i, balance);
                    emit AssetTeleported(wallet, address(POTIONS), i, balance);
                }
            }
            if (i < 7) {
                balance = ITeleportAsset(BUNDLES).balanceOf(wallet, i);
                if (balance > 0) {
                    teleported = 1;
                    ITeleportAsset(BUNDLES).teleport(wallet, i, balance);
                    emit AssetTeleported(wallet, BUNDLES, i, balance);
                }

                balance = ITeleportAsset(BADGES).balanceOf(wallet, i);
                if (balance > 0) {
                    teleported = 1;
                    ITeleportAsset(BADGES).teleport(wallet, i, balance);
                    emit AssetTeleported(wallet, BADGES, i, balance);
                }
            }
            balance = ITeleportAsset(COMPONENTS).balanceOf(wallet, i);
            if (balance > 0) {
                teleported = 1;
                ITeleportAsset(COMPONENTS).teleport(wallet, i, balance);
                emit AssetTeleported(wallet, COMPONENTS, i, balance);
            }
            balance = ITeleportAsset(SKINS).balanceOf(wallet, i);
            if (balance > 0) {
                teleported = 1;
                ITeleportAsset(SKINS).teleport(wallet, i, balance);
                emit AssetTeleported(wallet, SKINS, i, balance);
            }
        }

        return teleported;
    }

    function _teleportResources(address wallet) internal returns (uint256) {
        uint256 balance;
        uint256 teleported = 0;
        // ERC1155
        address RESOURCES = REFINED_RESOURCES;
         for (uint256 i = 0; i < 180; i++) {
             if (i % 5 != 4) {
                 RESOURCES = isRefinedResourceID(i) ? REFINED_RESOURCES : RAW_RESOURCES;
                 balance = ITeleportAsset(RESOURCES).balanceOf(wallet, i);
                 if (balance > 0) {
                     teleported = 1;
                     ITeleportAsset(RESOURCES).teleport(wallet, i, balance);
                     emit AssetTeleported(wallet, address(RESOURCES), i, balance);
                 }
             }
         }

        return teleported;
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
