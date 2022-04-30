// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "./IGameStorageUpgradeable.sol";

/**
* @title Cosmic Universe NFT Staking v1.0.0
* @author @DirtyCajunRice
*/
contract ProfessionStakingUpgradeable is Initializable, PausableUpgradeable, AccessControlUpgradeable, IERC721ReceiverUpgradeable {

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");

    IGameStorageUpgradeable public GAME_STORAGE;

    struct NFT {
        address _address;
        uint256 tokenId;
        uint256 rewardFrom;
    }

    struct Token {
        address _address;
        uint256 amount;
    }

    struct ParticipantData {
        NFT[] nfts;
        Token[] rewards;
    }

    struct StakingConfig {
        uint256 startTime;
        uint256 maxPointsPerSkill;
        uint256[] treeIds;
        uint256[] skillIds;
        address rewardToken;
    }

    struct StakingEnabledPointer {
        uint256 treeId;
        uint256 skillId;
    }

    struct TrainingLevelConfig {
        uint256 cost;
        uint256 time;
    }

    // Level to training cost mapping
    mapping (uint256 => TrainingLevelConfig) private _training_config;
    // Wallet address to ParticipantData mapping
    mapping (address => ParticipantData) private _data;
    // NFT collection to staking config mapping
    mapping (address => StakingConfig) private _config;
    // NFT collection to game storage definition for staking enabled
    mapping (address => StakingEnabledPointer) private _game_storage_staking_skill_pointer;

    event StakingConfigCreated(address indexed nftAddress, address rewardToken, uint256 startTime);
    event StakingConfigUpdated(address indexed nftAddress, address rewardToken, uint256 startTime);
    event StakingConfigDeleted(address indexed nftAddress);

    event Staked(address indexed from, address indexed nftAddresss, uint256 tokenId);
    event Unstaked(address indexed from, address indexed nftAddresss, uint256 tokenId);

    event RewardsDeposited(address indexed from, address indexed token, uint256 amount);
    event RewardsWithdrawn(address indexed by, address indexed to, address indexed token, uint256 amount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() initializer public {
        __Pausable_init();
        __AccessControl_init();

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(PAUSER_ROLE, _msgSender());
        _grantRole(UPDATER_ROLE, _msgSender());
    }

    /// PUBLIC functions

    // General staking

    function stake(address nftAddress, uint256 tokenId) public whenNotPaused {
        require(_config[nftAddress].startTime > 0, "Invalid stake");
        require(_config[nftAddress].startTime <= now, "Staking has not started");

        skill_config = _game_storage_staking_skill_pointer[nftAddress];
        uint256 unlocked = GAME_STORAGE.getSkill(nftAddress, tokenId, skill_config.treeId, skill_config.skillId);
        if (unlocked == 0) {
            token = IERC20Upgradeable(_config[nftAddress].rewardToken);
            token.transferFrom(_msgSender(), this(address), _training_config[0].cost);
        }
        IERC721Upgradeable(nftAddress).safeTransferFrom(_msgSender(), address(this), tokenId);
        GAME_STORAGE.updateSkill(nftAddress, tokenId, skill_config.treeId, skill_config.skillId, 1);

        NFT storage nft;
        nft._address = nftAddress;
        nft.tokenId = tokenId;
        nft.rewardFrom = now;
        _data[_msgSender()].nfts.push(nft);

        emit Staked(_msgSender(), nftAddress, tokenId);
    }

    function batchStake(address[] nftAddresses, uint256[] tokenIds) public whenNotPaused {
        require(nftAddresses.length == tokenIds.length, "address count must match token count");
        for (uint256 i = 0; i < nftAddresses.length; i++) {
            stake(nftAddresses[i], tokenIds[i]);
        }
    }

    function unstake(address nftAddress, uint256 tokenId) public {
        data = _data[_msgSender()];
        NFT storage nft;
        for (uint256 i = 0; i < data.nfts.length; i++) {
            if (data.nfts[i]._address == nftAddress && data.nfts[i].tokenId == tokenId) {
                nft = data.nfts[i];
                delete data.nfts[i];
                break;
            }
        }
        require(nft.tokenId > 0, "Nft not staked");
        IERC721Upgradeable(nftAddress).safeTransferFrom(address(this), _msgSender(), tokenId);
        // TODO: add logic to cancel any existing training
        // TODO: add logic to add payout
        emit Unstaked(_msgSender(), nftAddress, tokenId);
    }

    function batchUnstake(address[] nftAddresses, uint256[] tokenIds) public {
        require(nftAddresses.length == tokenIds.length, "address count must match token count");
        for (uint256 i = 0; i < nftAddresses.length; i++) {
            unstake(nftAddresses[i], tokenIds[i]);
        }
    }


    /// UPDATER_ROLE functions

    function setTrainingCost(uint256 level, uint256 cost, uint256 time) public onlyRole(UPDATER_ROLE) {
        TrainingLevelConfig storage training = _training_config[level];
        training.cost = cost;
        training.time = time;
    }

    function batchSetTrainingCosts(uint256[] level, uint256[] cost, uint256[] time) public onlyRole(UPDATER_ROLE) {
        require(level.length == cost.length == time.length, "All input arrays must be the same length");
        for (uint256 i = 0; i < level.length; i++) {
            setTrainingCost(level[i], cost[i], time[i]);
        }
    }

    function setGameStorage(address _address) public onlyRole(UPDATER_ROLE) {
        GAME_STORAGE = IGameStorageUpgradeable(_address);
    }

    function setSkillPointer(address nftAddress, uint256 treeId, uint256 skillId) public onlyRole(UPDATER_ROLE) {
        StakingEnabledPointer storage pointer = _game_storage_staking_skill_pointer[nftAddress];
        pointer.treeId = treeId;
        pointer.skillId = skillId;
    }

    function createStakingConfig(
        address nftAddress,
        address rewardToken,
        uint256 startTime,
        uint256 maxPointsPerSkill,
        uint256[] memory treeIds,
        uint256[] memory skillIds
    ) public onlyRole(UPDATER_ROLE) {
        require(_config[nftAddress].startTime == 0, "Staking config already exists");
        require(treeIds.length > 0, "Missing treeId config");
        require(skillIds.length > 0, "Missing skillId config");
        require(skillIds.length == treeIds.length, "TreeIds and SkillIds arrays must match");
        require(maxPointsPerSkill > 0, "maxPointsPerSkill must be greater than 0");
        require(startTime > now, "startTime must be a future time in seconds");
        require(IERC20Upgradeable(rewardToken).balanceOf(address(this)) > 0, "No funds for rewards");

        StakingConfig storage config = _config[nftAddress];
        config.rewardToken = rewardToken;
        config.startTime = startTime;
        config.maxPointsPerSkill = maxPointsPerSkill;
        for (uint256 i = 0; i < treeIds.length; i++) {
            config.treeIds[i] = treeIds[i];
        }
        for (uint256 i = 0; i < skillIds.length; i++) {
            config.skillIds[i] = skillIds[i];
        }
        emit StakingConfigCreated(nftAddress, rewardToken, startTime);
    }

    function updateStakingConfig(
        address nftAddress,
        address rewardToken,
        uint256 startTime,
        uint256 maxPointsPerSkill
    ) public onlyRole(UPDATER_ROLE) {
        require(_config[nftAddress].startTime != 0, "Staking config does not exist");
        require(maxPointsPerSkill > 0, "maxPointsPerSkill must be greater than 0");
        require(startTime > now, "startTime must be a future time in seconds");
        require(IERC20Upgradeable(rewardToken).balanceOf(address(this)) > 0, "No funds for rewards");

        StakingConfig storage config = _config[nftAddress];
        config.rewardToken = rewardToken;
        config.startTime = startTime;
        config.maxPointsPerSkill = maxPointsPerSkill;
        emit StakingConfigUpdated(nftAddress, rewardToken, startTime);
        // TODO: add logic to cancel any existing training
        // TODO: add logic to add payout
    }

    function deleteStakingConfig(address nftAddress) public onlyRole(UPDATER_ROLE) {
        delete _config[nftAddress];
        emit StakingConfigDeleted(nftAddress);
        // TODO: add logic to cancel any existing training
        // TODO: add logic to add payout
    }

    function depositRewards(address token, uint256 amount) public {
        IERC20Upgradeable(token).transferFrom(_msgSender(), address(this), amount);
        emit RewardsDeposited(_msgSender(), token, amount);
    }

    function withdrawRewards(address to, address token, uint256 amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        token = IERC20Upgradeable(token);
        require(token.balanceOf(address(this)) >= amount, "Insufficient balance");
        token.transferFrom(address(this), to, amount);
        // TODO: Require leaving in remaining funds to be disbursed
        emit RewardsWithdrawn(_msgSender(), to, token, amount);
    }
    /**
    * @dev Pause contract write functions
    */
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /**
    * @dev Unpause contract write functions
    */
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }
}