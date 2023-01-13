// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@dirtycajunrice/contracts/utils/access/StandardAccessControl.sol";
import "@dirtycajunrice/contracts/third-party/boba/TuringClient.sol";
import "@dirtycajunrice/contracts/utils/math/Numbers.sol";

import "../ERC1155/interfaces/IStandardERC1155.sol";
import "../ERC721/CosmicTools/ICosmicTools.sol";
import "../common/SharedStructs.sol";
/**
* @title Chest Redeemer v1.0.0
* @author @DirtyCajunRice
*/
contract ChestRedeemer is Initializable, PausableUpgradeable, StandardAccessControl, UUPSUpgradeable,
ReentrancyGuardUpgradeable, BobaL2TuringClient {
    using Numbers for uint256;

    struct Resource {
        uint256 firstId;
        uint256 min;
        uint256 max;
    }

    struct ResourceConfig {
        address _address;
        Resource a;
        Resource b;
        Resource c;
    }


    address public bundles;
    address public tools;
    address public rawResources;
    address public refinedResources;

    mapping(uint256 => ResourceConfig) private _resourcesConfig;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Pausable_init();
        __StandardAccessControl_init();
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();
        __BobaL2TuringClient_init(
            0x4200000000000000000000000000000000000020,
            0x680e176b2bbdB2336063d0C82961BDB7a52CF13c
        );

        bundles = 0x69938433cB243721978986a5B3c981A681970212;
        tools = 0x0458b679C30AA4B8622742eA9fb2A44660c4a2a1;
        rawResources = 0xCE953D1A6be7331EEf06ec9Ac8a4a22a4f2BDfB0;
        refinedResources = 0x4F82DFbEED2aa0686EB26ddba7a075406b4C6A67;
    }

    function redeem(uint256 id) external payable whenNotPaused nonReentrant {
        require(id < 2, "ChestRedeemer::Invalid Id");
        IStandardERC1155(bundles).burn(msg.sender, id, 1);
        bool mythical = id == 1;

        _payTuringFee();
        uint256 random = TuringHelper.Random();
        uint256[] memory randomChunks = random.chunkUintX(10_000, 15);


        rollVipPass(randomChunks[0], mythical);
        if (mythical) {
            rollPet(randomChunks[1]);
        }
        rollRune(randomChunks[2], mythical);
        rollTool(randomChunks[3], randomChunks[4], mythical);
        rollResources(randomChunks, mythical);
    }

    function rollVipPass(uint256 rand, bool mythical) internal {
        if (!mythical) {
            if ((rand % 100) >= 15) {
                return;
            }
        }
        IStandardERC1155(bundles).mint(msg.sender, 4, 1, "");
    }

    function rollPet(uint256 rand) internal {
        if ((rand % 100) < 10) {
            IStandardERC1155(bundles).mint(msg.sender, 5, 1, "");
        }
    }

    function rollRune(uint256 rand, bool mythical) internal {
        uint256 chance = mythical ? 15 : 3;
        if ((rand % 100) < chance) {
            IStandardERC1155(bundles).mint(msg.sender, 6, 1, "");
        }
    }

    function rollTool(uint256 rand1, uint256 rand2, bool mythical) internal {
        uint256 skillId = rand1 % 12;
        uint256 roll = rand2 % 100;
        uint8 rarity;
        if (mythical) {
            rarity = roll < 10 ? 3 : roll < 35 ? 2 : 1;
        } else {
            rarity = roll == 0 ? 3 : roll < 11 ? 2 : roll < 41 ? 1 : 0;
        }
        ICosmicTools(tools).mint(msg.sender, abi.encode(ICosmicTools.Tool(skillId, 0, SharedStructs.Rarity(rarity))));
    }

    function rollResources(uint256[] memory randomChunks, bool mythical) internal {
        uint256 skillId = randomChunks[5] % 12;

        rollResource(skillId, _resourcesConfig[skillId].a, randomChunks[6], randomChunks[7], mythical);
        rollResource(skillId, _resourcesConfig[skillId].b, randomChunks[8], randomChunks[9], mythical);
        if (mythical) {
            rollResource(skillId, _resourcesConfig[skillId].c, randomChunks[10], randomChunks[11], mythical);
        }

    }

    function rollResource(uint256 skillId, Resource memory r, uint256 rand1, uint256 rand2, bool mythical) internal {
        uint256 roll = rand1 % 100;
        uint256 rarity =  roll < 5 ? 3 : roll < 20 ? 2 : roll < 50 ? 1 : 0;
        uint256 min = mythical ? r.min * 2 : r.min;
        uint256 max = mythical ? r.max * 2 : r.max;
        uint256 amount = min + 1 + (rand2 % (max - min));
        uint256 tokenId = r.firstId + rarity;
        IStandardERC1155(_resourcesConfig[skillId]._address).mint(msg.sender, tokenId, amount, "");
    }

    function _authorizeUpgrade(address newImplementation) internal virtual override onlyAdmin {}

    function setResourcesConfig(uint256[] memory skillIds, ResourceConfig[] memory configs) external onlyAdmin {
        require(skillIds.length == configs.length, "ChestRedeemer::Array length mismatch");
        require(skillIds.length > 0, "ChestRedeemer::Empty Array");
        for (uint256 i = 0; i < skillIds.length; i++) {
            ResourceConfig storage c = _resourcesConfig[skillIds[i]];
            c._address = configs[i]._address;
            c.a = configs[i].a;
            c.b = configs[i].b;
            c.c = configs[i].c;
        }
    }

    function resourcesConfig() external view returns (ResourceConfig[] memory config) {
        config = new ResourceConfig[](12);
        for (uint256 i = 0; i < 12; i++) {
            config[i] = _resourcesConfig[i];
        }
    }
}