// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./IGameStorageUpgradeable.sol";

/**
* @title Cosmic Universe NFT Staking v1.4.2
* @author @DirtyCajunRice
*/
contract ProfessionStakingUpgradeable is Initializable, PausableUpgradeable, AccessControlUpgradeable, IERC721ReceiverUpgradeable {

    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

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

    struct TrainingStatus {
        address _address;
        uint256 tokenId;
        uint256 level;
        uint256 treeId;
        uint256 skillId;
        uint256 startedAt;
        uint256 completeAt;
    }

    // Wallet > NFT Collection > tokenId > TrainingStatus
    mapping (address => mapping (address => mapping (uint256 => TrainingStatus))) private _training_status;
    // Level to training cost mapping
    mapping (uint256 => TrainingLevelConfig) private _training_config;
    // Wallet address to ParticipantData mapping
    mapping (address => ParticipantData) private _data;
    // Wallet address key set
    EnumerableSetUpgradeable.AddressSet private _dataKeys;
    // NFT collection to staking config mapping
    mapping (address => StakingConfig) private _config;
    // NFT collection to game storage definition for staking enabled
    mapping (address => StakingEnabledPointer) private _game_storage_staking_skill_pointer;

    mapping (address => uint256) private _rewards;
    event StakingConfigCreated(address indexed nftAddress, address rewardToken, uint256 startTime);
    event StakingConfigUpdated(address indexed nftAddress, address rewardToken, uint256 startTime);
    event StakingConfigDeleted(address indexed nftAddress);

    event Staked(address indexed from, address indexed nftAddress, uint256 tokenId);
    event Unstaked(address indexed from, address indexed nftAddress, uint256 tokenId);

    event Claimed(address indexed by, address indexed token, uint256 amount);

    event PoolRewardsDeposited(address indexed from, address indexed token, uint256 amount);
    event PoolRewardsWithdrawn(address indexed by, address indexed to, address indexed token, uint256 amount);

    event StakingUnlocked(address indexed by, address indexed nftAddress, uint256 tokenId);

    event TrainingStarted(
        address indexed by,
        address indexed nftAddress,
        uint256 tokenId,
        uint256 treeId,
        uint256 skillId,
        uint256 level,
        uint256 startedAt,
        uint256 completeAt
    );

    event TrainingFinished(
        address indexed by,
        address indexed nftAddress,
        uint256 tokenId,
        uint256 treeId,
        uint256 skillId,
        uint256 level
    );

    event TrainingCanceled(
        address indexed by,
        address indexed nftAddress,
        uint256 tokenId,
        uint256 treeId,
        uint256 skillId,
        uint256 canceledAt
    );

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

    function enableStaking(address nftAddress, uint256 tokenId) public whenNotPaused {
        StakingEnabledPointer storage skill_config = _game_storage_staking_skill_pointer[nftAddress];
        bool unlocked = isStakingEnabled(nftAddress, tokenId);
        require(!unlocked, "Staking already unlocked");
        require(_config[nftAddress].startTime > 0, "Staking not configured");
        require(_config[nftAddress].startTime <= block.timestamp, "Staking has not started");

        IERC20Upgradeable token = IERC20Upgradeable(_config[nftAddress].rewardToken);
        token.transferFrom(_msgSender(), address(this), _training_config[0].cost);

        GAME_STORAGE.updateSkill(nftAddress, tokenId, skill_config.treeId, skill_config.skillId, 1);

        emit StakingUnlocked(_msgSender(), nftAddress, tokenId);
    }

    function batchEnableStaking(address[] memory nftAddresses, uint256[] memory tokenIds) public whenNotPaused {
        require(nftAddresses.length == tokenIds.length, "address count must match token count");
        for (uint256 i = 0; i < nftAddresses.length; i++) {
            enableStaking(nftAddresses[i], tokenIds[i]);
        }
    }

    function stake(address nftAddress, uint256 tokenId) public whenNotPaused {
        require(_config[nftAddress].startTime > 0, "Invalid stake");
        require(_config[nftAddress].startTime <= block.timestamp, "Staking has not started");
        require(isStakingEnabled(nftAddress, tokenId), "Staking is not unlocked for nft");

        IERC721Upgradeable(nftAddress).safeTransferFrom(_msgSender(), address(this), tokenId);

        NFT memory nft;
        nft._address = nftAddress;
        nft.tokenId = tokenId;
        nft.rewardFrom = block.timestamp;

        _disburse_rewards(_msgSender());
        _dataKeys.add(_msgSender());
        _data[_msgSender()].nfts.push(nft);

        emit Staked(_msgSender(), nftAddress, tokenId);
    }

    function batchStake(address[] memory nftAddresses, uint256[] memory tokenIds) public whenNotPaused {
        require(nftAddresses.length == tokenIds.length, "address count must match token count");
        for (uint256 i = 0; i < nftAddresses.length; i++) {
            stake(nftAddresses[i], tokenIds[i]);
        }
    }

    function unstake(address nftAddress, uint256 tokenId) public {
        ParticipantData storage data = _data[_msgSender()];
        require(data.nfts.length > 0, "No NFTs staked");
        NFT[] memory nfts = new NFT[](data.nfts.length - 1);
        bool found = false;
        uint256 index = 0;
        for (uint256 i = 0; i < data.nfts.length; i++) {
            if ((data.nfts[i]._address != nftAddress) || (data.nfts[i].tokenId != tokenId)) {
                require(index < (data.nfts.length), "NFT not staked");
                nfts[index] = data.nfts[i];
                index++;
                continue;
            }
            found = true;
        }
        _disburse_rewards(_msgSender());
        delete data.nfts;
        for (uint256 i = 0; i < nfts.length; i++) {
            data.nfts.push(nfts[i]);
        }
        if ((data.nfts.length == 0) && (data.rewards.length == 0) && (_rewards[_msgSender()] == 0)) {
            _dataKeys.remove(_msgSender());
        }
        delete _training_status[_msgSender()][nftAddress][tokenId];
        IERC721Upgradeable(nftAddress).transferFrom(address(this), _msgSender(), tokenId);

        emit Unstaked(_msgSender(), nftAddress, tokenId);
    }

    function batchUnstake(address[] memory nftAddresses, uint256[] memory tokenIds) public {
        require(nftAddresses.length == tokenIds.length, "address count must match token count");
        for (uint256 i = 0; i < nftAddresses.length; i++) {
            unstake(nftAddresses[i], tokenIds[i]);
        }
    }

    function claim() public {
        _disburse_rewards(_msgSender());
        require(_data[_msgSender()].rewards.length > 0 || _rewards[_msgSender()] > 0, "Nothing to claim");
        _claim(_msgSender());
    }

    function _claim(address _address) internal {
        ParticipantData storage data = _data[_address];
        uint256 amountToClaim = _rewards[_address];
        for (uint256 i = 0; i < data.rewards.length; i++) {
            amountToClaim += data.rewards[i].amount;
        }
        delete data.rewards;
        _rewards[_address] = 0;

        IERC20Upgradeable token = IERC20Upgradeable(0x892D81221484F690C0a97d3DD18B9144A3ECDFB7);

        require(token.balanceOf(address(this)) >= amountToClaim, "Insufficient rewards in contract");
        token.transfer(_address, amountToClaim);

        emit Claimed(_address, address(token), amountToClaim);

        if ((data.nfts.length == 0) && (data.rewards.length == 0) && (_rewards[_address] == 0)) {
            _dataKeys.remove(_address);
        }
    }

    function _claimOldRewards(address _address, uint256 count) internal {
        ParticipantData storage data = _data[_address];
        require(data.rewards.length >= count, "Invalid count");
        uint256 amountToClaim = 0;
        uint256 min = data.rewards.length - count;

        for (uint256 i = min; i < data.rewards.length; i++) {
            amountToClaim += data.rewards[i].amount;
        }
        for (uint256 i = min; i < data.rewards.length; i++) {
            data.rewards.pop();
        }
        IERC20Upgradeable token = IERC20Upgradeable(0x892D81221484F690C0a97d3DD18B9144A3ECDFB7);

        require(token.balanceOf(address(this)) >= amountToClaim, "Insufficient rewards in contract");
        token.transfer(_address, amountToClaim);

        emit Claimed(_address, address(token), amountToClaim);

        if ((data.nfts.length == 0) && (data.rewards.length == 0) && (_rewards[_address] == 0)) {
            _dataKeys.remove(_address);
        }
    }

    function claimOldRewards(uint256 count) public {
        require(_data[_msgSender()].rewards.length > 0, "Invalid count");
        _claimOldRewards(_msgSender(), count);
    }

    function forceClaimOldRewardsForAddress(address _address, uint256 count) public onlyRole(UPDATER_ROLE) {
        require(_data[_address].rewards.length > 0, "Invalid count");
        _claimOldRewards(_address, count);
    }

    function getOldRewards(address _address) public view returns(Token[] memory) {
        return _data[_address].rewards;
    }
    // training functions
    function startTraining(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId) public whenNotPaused {
        StakingConfig storage stakingConfig = _config[nftAddress];
        require(stakingConfig.startTime > 0, "No training session configured");
        require(stakingConfig.startTime <= block.timestamp, "Training has not started yet");

        TrainingStatus storage trainingStatus = _training_status[_msgSender()][nftAddress][tokenId];
        require(trainingStatus.startedAt == 0, "Training is already in progress");

        uint256[] memory options = getAllowedSkillChoices(nftAddress, tokenId);
        require(options.length > 0, "No training sessions available");
        bool allowed = false;
        for (uint256 i = 0; i < options.length; i++) {
            if (options[i] == skillId) {
                allowed = true;
                break;
            }
        }
        require(allowed, "Invalid training option");

        uint256 currentLevel = GAME_STORAGE.getSkill(nftAddress, tokenId, treeId, skillId);
        TrainingLevelConfig storage trainingConfig = _training_config[currentLevel + 1];
        require((currentLevel + 1) <= stakingConfig.maxPointsPerSkill, "Exceeds maximum training level");
        require(trainingConfig.cost > 0, "Training Level is not enabled");

        _disburse_rewards(_msgSender());

        IERC20Upgradeable(stakingConfig.rewardToken).transferFrom(_msgSender(), address(this), trainingConfig.cost);

        trainingStatus.level = currentLevel + 1;
        trainingStatus.treeId = treeId;
        trainingStatus.skillId = skillId;
        trainingStatus.startedAt = block.timestamp;
        trainingStatus.completeAt = block.timestamp + trainingConfig.time;
        trainingStatus._address = nftAddress;
        trainingStatus.tokenId = tokenId;

        emit TrainingStarted(
            _msgSender(),
            nftAddress,
            tokenId,
            treeId,
            skillId,
            currentLevel + 1,
            trainingStatus.startedAt,
            trainingStatus.completeAt
        );
    }

    function batchStartTraining(
        address[] memory nftAddresses,
        uint256[] memory tokenIds,
        uint256[] memory treeIds,
        uint256[] memory skillIds
    ) public whenNotPaused {
        require(nftAddresses.length == tokenIds.length, "address count must match token count");
        require(nftAddresses.length == treeIds.length, "address count must match tree count");
        require(nftAddresses.length == skillIds.length, "address count must match skill count");
        for (uint256 i = 0; i < nftAddresses.length; i++) {
            startTraining(nftAddresses[i], tokenIds[i], treeIds[i], skillIds[i]);
        }
    }

    function finishTraining(address nftAddress, uint256 tokenId) public {
        TrainingStatus storage trainingStatus = _training_status[_msgSender()][nftAddress][tokenId];
        require(trainingStatus.startedAt > 0, "Not training");
        require(trainingStatus.completeAt <= block.timestamp, "Training still in progress");
        _disburse_rewards(_msgSender());
        GAME_STORAGE.updateSkill(nftAddress, tokenId, trainingStatus.treeId, trainingStatus.skillId, trainingStatus.level);

        emit TrainingFinished(
            _msgSender(),
            nftAddress,
            tokenId,
            trainingStatus.treeId,
            trainingStatus.skillId,
            trainingStatus.level
        );

        delete _training_status[_msgSender()][nftAddress][tokenId];
    }

    function batchFinishTraining(address[] memory nftAddresses, uint256[] memory tokenIds) public {
        require(nftAddresses.length == tokenIds.length, "address count must match token count");
        for (uint256 i = 0; i < nftAddresses.length; i++) {
            finishTraining(nftAddresses[i], tokenIds[i]);
        }
    }

    function cancelTraining(address nftAddress, uint256 tokenId) public {
        TrainingStatus storage trainingStatus = _training_status[_msgSender()][nftAddress][tokenId];
        require(trainingStatus.startedAt > 0, "Not training");
        require(trainingStatus.completeAt > block.timestamp, "Training already finished");
        _disburse_rewards(_msgSender());

        emit TrainingCanceled(
            _msgSender(),
            nftAddress,
            tokenId,
            trainingStatus.treeId,
            trainingStatus.skillId,
            block.timestamp
        );

        delete _training_status[_msgSender()][nftAddress][tokenId];
    }

    function batchCancelTraining(address[] memory nftAddresses, uint256[] memory tokenIds) public {
        require(nftAddresses.length == tokenIds.length, "address count must match token count");
        for (uint256 i = 0; i < nftAddresses.length; i++) {
            cancelTraining(nftAddresses[i], tokenIds[i]);
        }
    }
    /// UPDATER_ROLE functions

    function setTrainingCost(uint256 level, uint256 cost, uint256 time) public onlyRole(UPDATER_ROLE) {
        TrainingLevelConfig storage training = _training_config[level];
        training.cost = cost;
        training.time = time;
    }

    function batchSetTrainingCosts(uint256[] memory level, uint256[] memory cost, uint256[] memory time) public onlyRole(UPDATER_ROLE) {
        require((level.length == cost.length) && (cost.length == time.length), "All input arrays must be the same length");
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
        require(startTime > block.timestamp, "startTime must be a future time in seconds");
        require(IERC20Upgradeable(rewardToken).balanceOf(address(this)) > 0, "No funds for rewards");

        _disburse_all_rewards();

        _config[nftAddress].rewardToken = rewardToken;
        _config[nftAddress].startTime = startTime;
        _config[nftAddress].maxPointsPerSkill = maxPointsPerSkill;
        for (uint256 i = 0; i < treeIds.length; i++) {
            _config[nftAddress].treeIds.push(treeIds[i]);
            _config[nftAddress].skillIds.push(skillIds[i]);
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
        require(startTime > block.timestamp, "startTime must be a future time in seconds");
        require(IERC20Upgradeable(rewardToken).balanceOf(address(this)) > 0, "No funds for rewards");

        _disburse_all_rewards();

        StakingConfig storage config = _config[nftAddress];
        config.rewardToken = rewardToken;
        config.startTime = startTime;
        config.maxPointsPerSkill = maxPointsPerSkill;
        emit StakingConfigUpdated(nftAddress, rewardToken, startTime);
    }

    function deleteStakingConfig(address nftAddress) public onlyRole(UPDATER_ROLE) {
        _disburse_all_rewards();

        delete _config[nftAddress];
        emit StakingConfigDeleted(nftAddress);
    }

    function depositPoolRewards(address token, uint256 amount) public {
        IERC20Upgradeable(token).transferFrom(_msgSender(), address(this), amount);
        emit PoolRewardsDeposited(_msgSender(), token, amount);
    }

    function withdrawPoolRewards(address to, address token, uint256 amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _disburse_all_rewards();

        IERC20Upgradeable t = IERC20Upgradeable(token);
        require(t.balanceOf(address(this)) >= amount, "Insufficient balance");
        t.transferFrom(address(this), to, amount);

        emit PoolRewardsWithdrawn(_msgSender(), to, token, amount);
    }

    /// Helpers

    // view

    function pendingRewards() public view returns(uint256) {
        uint256 total = _rewards[_msgSender()];
        for (uint256 i = 0; i < _data[_msgSender()].rewards.length; i++) {
            total += _data[_msgSender()].rewards[i].amount;
        }
        ParticipantData storage data = _data[_msgSender()];
        for (uint256 i = 0; i < data.nfts.length; i++) {
            uint256 elapsed = block.timestamp - data.nfts[i].rewardFrom;
            uint256 totalSkill = getTotalProfessionSkillPoints(data.nfts[i]._address, data.nfts[i].tokenId);
            total += ((totalSkill + 1) * 1e18 / 1 days) * elapsed;
        }
        return total;
    }

    function getStaked() public view returns(NFT[] memory) {
        return _data[_msgSender()].nfts;
    }

    function isStakingEnabled(address nftAddress, uint256 tokenId) public view returns(bool) {
        StakingEnabledPointer storage skill_config = _game_storage_staking_skill_pointer[nftAddress];
        uint256 unlocked = GAME_STORAGE.getSkill(nftAddress, tokenId, skill_config.treeId, skill_config.skillId);
        if (unlocked == 1) {
            return true;
        }
        return false;
    }

    function getActiveTraining() public view returns (TrainingStatus[] memory) {
        NFT[] memory nfts = _data[_msgSender()].nfts;
        uint256 count = 0;
        for (uint256 i = 0; i < nfts.length; i++) {
            TrainingStatus memory status = _training_status[_msgSender()][nfts[i]._address][nfts[i].tokenId];
            if (status.completeAt > 0) {
                count++;
            }
        }
        TrainingStatus[] memory training = new TrainingStatus[](count);
        uint256 added = 0;
        for (uint256 i = 0; i < nfts.length; i++) {
            TrainingStatus memory status = _training_status[_msgSender()][nfts[i]._address][nfts[i].tokenId];
            if (status.completeAt > 0) {
                training[added] = status;
                added++;
            }
        }
        return training;
    }

    // internal

    function getAllowedSkillChoices(address nftAddress, uint256 tokenId) public view returns(uint256[] memory) {
        StakingConfig memory stakingConfig = _config[nftAddress];
        require(stakingConfig.startTime > 0, "No training session configured");
        uint256[] memory levels = new uint256[](stakingConfig.treeIds.length);
        uint256 leveledSkillIdCount = 0;
        uint256 maxedSkillIdCount = 0;
        for (uint256 i = 0; i < stakingConfig.treeIds.length; i++) {
            levels[i] = GAME_STORAGE.getSkill(
                nftAddress,
                tokenId,
                stakingConfig.treeIds[i],
                stakingConfig.skillIds[i]
            );
            if (levels[i] > 0) {
                leveledSkillIdCount++;
            }
            if (levels[i] == stakingConfig.maxPointsPerSkill) {
                maxedSkillIdCount++;
            }
        }
        if (leveledSkillIdCount == 0) {
            return stakingConfig.skillIds;
        }
        if (maxedSkillIdCount == 2) {
            uint256[] memory empty;
            return empty;
        }
        uint256[] memory all = new uint256[](stakingConfig.treeIds.length - 1);
        uint256 added = 0;
        for (uint256 i = 0; i < levels.length; i++) {
            if ((maxedSkillIdCount == 1) && (leveledSkillIdCount == 1) && (levels[i] == 0)) {
                all[added] = stakingConfig.skillIds[i];
            }
            if ((levels[i] > 0) && (levels[i] < stakingConfig.maxPointsPerSkill)) {
                uint256[] memory next = new uint256[](1);
                next[0] = stakingConfig.skillIds[i];
                return next;
            }
        }
        return all;
    }

    function _clear_if_empty(ParticipantData storage data) internal {
        if ((data.nfts.length == 0) && (data.rewards.length == 0)) {
            _dataKeys.remove(_msgSender());
        }
    }
    function _disburse_all_rewards() internal {
        for (uint256 i = 0; i < _dataKeys.length(); i++) {
            _disburse_rewards(_dataKeys.at(i));
        }
    }

    function _disburse_rewards(address _address) internal {
        ParticipantData storage data = _data[_address];
        for (uint256 i = 0; i < data.nfts.length; i++) {
            uint256 elapsed = block.timestamp - data.nfts[i].rewardFrom;
            uint256 totalSkill = getTotalProfessionSkillPoints(data.nfts[i]._address, data.nfts[i].tokenId);
            data.nfts[i].rewardFrom = block.timestamp;
            _rewards[_address] += ((totalSkill + 1) * 1e18 / 1 days) * elapsed;
        }
    }

    function forceDisperse() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _disburse_all_rewards();
    }

    function forceCancelTraining(address _address, address nftAddress, uint256 tokenId) public onlyRole(DEFAULT_ADMIN_ROLE) {
        delete _training_status[_address][nftAddress][tokenId];
    }

    function getTotalProfessionSkillPoints(address ntfAddress, uint256 tokenId) public view returns(uint256){
        uint256 totalSkillPoints = 0;
        for (uint256 i = 0; i < 12; i++) {
           uint256 points = GAME_STORAGE.getSkill(ntfAddress, tokenId, 1, i);
            totalSkillPoints += points;
        }
        return totalSkillPoints;
    }
    /// Standard functions

    /**
    * @dev Pause contract write functions
    */
    function pause() public onlyRole(PAUSER_ROLE) {
        _disburse_all_rewards();
        _pause();
    }

    /**
    * @dev Unpause contract write functions
    */
    function unpause() public onlyRole(PAUSER_ROLE) {
        _disburse_all_rewards();
        _unpause();
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}