// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableMapUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../../../ERC721/interfaces/ICosmicAttributeStorage.sol";
import "../../../ERC1155/interfaces/IBridgeableERC1155.sol";
import "../../../ERC721/interfaces/IBridgeableERC721.sol";
import "../../../utils/access/StandardAccessControl.sol";
import "../../../ERC721/CosmicTools/ICosmicTools.sol";
import "./IElvenAdventures.sol";

/**
* @title Elven Adventures (Cosmic Universe NFT Staking) v3.0.0
* @author @DirtyCajunRice
*/
contract ElvenAdventures is Initializable, IElvenAdventures, PausableUpgradeable, StandardAccessControl {
    /*************
     * Libraries *
     *************/

    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.UintToUintMap;

    /*************
     * Variables *
     *************/

    address private _elves;
    address private _magic;
    // level => time
    EnumerableMapUpgradeable.UintToUintMap private _questTime;
    // tokenId => Quest
    mapping (uint256 => Quest) private _quests;
    // level => Reward
    mapping (uint256 => Reward) private _rewards;

    /*************
     * Modifiers *
     *************/

    modifier onAdventure(uint256 tokenId) {
        require(ICosmicAttributeStorage(_elves).ownerOf(tokenId) == msg.sender, "ElvenAdventures::Not owner");
        require(
            ICosmicAttributeStorage(_elves).getSkill(tokenId, 0, 101) == 1,
            "ElvenAdventures::Not on an adventure"
        );
        _;
    }

    modifier notOnAdventure(uint256 tokenId) {
        require(ICosmicAttributeStorage(_elves).ownerOf(tokenId) == msg.sender, "ElvenAdventures::Not owner");
        require(
            ICosmicAttributeStorage(_elves).getSkill(tokenId, 0, 101) == 0,
            "ElvenAdventures::Already on an adventure"
        );
        _;
    }

    modifier onlyUnlocked(uint256 tokenId) {
        require(ICosmicAttributeStorage(_elves).ownerOf(tokenId) == msg.sender, "ElvenAdventures::Not owner");
        require(
            ICosmicAttributeStorage(_elves).getSkill(tokenId, 0, 100) == 1,
            "ElvenAdventures::Adventures are not unlocked"
        );
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Pausable_init();
        __StandardAccessControl_init();

        _elves = address(0);
        _magic = address(0);
    }

    /******************
     * User Functions *
     ******************/

    function unlockAdventures(uint256 tokenId) public whenNotPaused onlyAdmin {
        require(
            ICosmicAttributeStorage(_elves).getSkill(tokenId, 0, 100) == 0,
           "ElvenAdventures::Adventures already unlocked for Elf"
        );

        IERC20Upgradeable(_magic).transferFrom(msg.sender, address(this), 20 ether);
        ICosmicAttributeStorage(_elves).updateSkill(tokenId, 0, 100, 1);

        emit UnlockedAdventures(msg.sender, tokenId);
    }

    function batchUnlockAdventures(uint256[] calldata tokenIds) external {
        require(tokenIds.length > 0, "ElvenAdventures::Token ID array must be larger than 0");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            unlockAdventures(tokenIds[i]);
        }
    }

    function beginAdventure(uint256 tokenId) public whenNotPaused
    notOnAdventure(tokenId) onlyUnlocked(tokenId) onlyAdmin {
        ICosmicAttributeStorage(_elves).updateSkill(tokenId, 0, 101, 1);
        emit BeganAdventure(msg.sender, tokenId);
    }

    function batchBeginAdventure(uint256[] calldata tokenIds) external {
        require(tokenIds.length > 0, "ElvenAdventures::Token ID array must be larger than 0");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            beginAdventure(tokenIds[i]);
        }
    }

    function finishAdventure(uint256 tokenId) public onAdventure(tokenId) {
        ICosmicAttributeStorage(_elves).updateSkill(tokenId, 0, 101, 0);
        delete _quests[tokenId];
        emit FinishedAdventure(msg.sender, tokenId);
    }

    function batchFinishAdventure(uint256[] calldata tokenIds) external {
        require(tokenIds.length > 0, "ElvenAdventures::Token ID array must be larger than 0");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            finishAdventure(tokenIds[i]);
        }
    }

    function startQuest(uint256 tokenId, uint256 skillId) public whenNotPaused onAdventure(tokenId) {
        Quest storage quest = _quests[tokenId];
        require(quest.completeAt == 0, "ElvenAdventures::Quest is already in progress");

        require(isValidSkill(tokenId, skillId), "ElvenAdventures::Invalid quest skill");

        uint256 skill = ICosmicAttributeStorage(_elves).getSkill(tokenId, 1, skillId);
        require(skill <= 19, "ElvenAdventures::Exceeds maximum skill level for quest");
        uint256 time = _questTime.get(skill + 1);

        IERC20Upgradeable(_magic).transferFrom(msg.sender, address(this), 60 ether);

        _quests[tokenId] = Quest(skill + 1, skillId, block.timestamp + time);

        emit BeganQuest(msg.sender, tokenId, skillId, skill + 1, block.timestamp + time);
    }

    function batchStartQuest(uint256[] calldata tokenIds, uint256[] calldata skillIds) external {
        require(tokenIds.length > 0, "ElvenAdventures::Token ID array must be larger than 0");
        require(tokenIds.length == skillIds.length, "ElvenAdventures::Token Id count must match Skill Id count");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            startQuest(tokenIds[i], skillIds[i]);
        }
    }

    function finishQuest(uint256 tokenId) public onAdventure(tokenId) {
        Quest storage quest = _quests[tokenId];
        require(quest.completeAt > 0, "ElvenAdventures::Not questing");
        require(quest.completeAt <= block.timestamp, "ElvenAdventures::Quest still in progress");

        ICosmicAttributeStorage(_elves).updateSkill(tokenId, 1, quest.skillId, quest.level);
        sendReward(quest.level, quest.skillId);
        emit FinishedQuest(msg.sender, tokenId, quest.skillId, quest.level);
        delete _quests[tokenId];
    }

    function batchFinishQuest(uint256[] calldata tokenIds) external {
        require(tokenIds.length > 0, "ElvenAdventures::Token ID array must be larger than 0");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            finishQuest(tokenIds[i]);
        }
    }

    function abandonQuest(uint256 tokenId) public onAdventure(tokenId) {
        Quest storage quest = _quests[tokenId];
        require(quest.completeAt > 0, "ElvenAdventures::Not questing");
        require(quest.completeAt > block.timestamp, "ElvenAdventures::Quest already complete");

        emit CancelledQuest(msg.sender, tokenId, quest.skillId);

        delete _quests[tokenId];
    }

    function batchAbandonQuest(uint256[] calldata tokenIds) external {
        require(tokenIds.length > 0, "ElvenAdventures::Token ID array must be larger than 0");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            abandonQuest(tokenIds[i]);
        }
    }

    /**********************
     * Internal Functions *
     **********************/

    function sendReward(uint256 level, uint256 skillId) internal {
        Reward storage reward = _rewards[level];
        if (reward.tokenType == TokenType.ERC20) {
            IERC20Upgradeable(_magic).transfer(msg.sender, reward.amount);
        } else if (reward.tokenType == TokenType.ERC721) {
            ICosmicTools.Tool memory tool = ICosmicTools.Tool(skillId, 0, Rarity.Rare);
            ICosmicTools(reward._address).mint(msg.sender, abi.encode(tool));
        } else {
            uint256 rewardId = reward.id;
            if (level == 17) {
                rewardId = (skillId * 15) + 3;
            } else if (level == 19) {
                rewardId = (skillId * 15) + 8;
            } else if (level == 20) {
                rewardId = skillId;
            }
            IBridgeableERC1155(reward._address).mint(msg.sender, rewardId, reward.amount, "");
        }
    }

    function isValidSkill(uint256 tokenId, uint256 skillId) internal view returns(bool) {
        uint256[] memory options = getAllowedSkillChoices(tokenId);
        require(options.length > 0, "No quests available");
        for (uint256 i = 0; i < options.length; i++) {
            if (options[i] == skillId) {
                return true;
            }
        }
        return false;
    }

    /*******************
     * Admin Functions *
     *******************/

    function setQuestTime(uint256 level, uint256 time) public onlyAdmin {
        _questTime.set(level, time);
    }

    function batchSetQuestTime(uint256[] calldata levels, uint256[] calldata time) public {
        require(levels.length > 0, "ElvenAdventures::Level array must be larger than 0");
        require(levels.length == time.length, "ElvenAdventures::Level count must match time count");
        for (uint256 i = 0; i < levels.length; i++) {
            setQuestTime(levels[i], time[i]);
        }
    }

    function setRewards(uint256[] calldata levels, Reward[] calldata rewards) external onlyAdmin {
        require(levels.length > 0, "ElvenAdventures::Level array must be larger than 0");
        require(levels.length == rewards.length, "ElvenAdventures::Level count must match reward count");
        for (uint256 i = 0; i < levels.length; i++) {
            _rewards[levels[i]] = rewards[i];
        }
    }

    /*******************
     * Query Functions *
     *******************/

    function getQuest(uint256 tokenId) public view returns(Quest memory) {
        return _quests[tokenId];
    }

    function getQuests(uint256[] calldata tokenIds) external view returns(Quest[] memory) {
        require(tokenIds.length > 0, "ElvenAdventures::Token ID array must be larger than 0");
        Quest[] memory quests = new Quest[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            quests[i] = _quests[tokenIds[i]];
        }
        return quests;
    }


    function getAllowedSkillChoices(uint256 tokenId) public view returns(uint256[] memory) {
        uint256[] memory skillIds = new uint256[](12);
        for (uint256 i = 0; i < 12; i++) {
            skillIds[i] = i;
        }
        uint256[12] memory levels;
        uint256 leveledSkillIdCount = 0;
        uint256 maxedSkillIdCount = 0;
        for (uint256 i = 0; i < 12; i++) {
            levels[i] = ICosmicAttributeStorage(_elves).getSkill(tokenId, 1, i);
            if (levels[i] > 0) {
                leveledSkillIdCount++;
            }
            if (levels[i] == 20) {
                maxedSkillIdCount++;
            }
        }
        if (leveledSkillIdCount == 0) {
            return skillIds;
        }
        if (maxedSkillIdCount == 2) {
            uint256[] memory empty;
            return empty;
        }
        uint256[] memory all = new uint256[](11);
        uint256 added = 0;
        for (uint256 i = 0; i < 12; i++) {
            if ((maxedSkillIdCount == 1) && (leveledSkillIdCount == 1) && (levels[i] == 0)) {
                all[added] = skillIds[i];
                added++;
            }
            if ((levels[i] > 0) && (levels[i] < 20)) {
                uint256[] memory next = new uint256[](1);
                next[0] = skillIds[i];
                return next;
            }
        }
        return all;
    }

    /*******************
     * Pause Functions *
     *******************/

    /**
    * @dev Pause contract write functions
    */
    function pause() public onlyAdmin {
        _pause();
    }

    /**
    * @dev Unpause contract write functions
    */
    function unpause() public onlyAdmin {
        _unpause();
    }

}