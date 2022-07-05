// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../storage/IGameStorageUpgradeable.sol";

/**
* @title Cosmic Universe NFT Staking v1.8.1
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
        uint256 rewards;
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

    event ClaimBlocked(address indexed from, uint256 stakedCount, uint256 amount);

    modifier onlyStaked(address nftAddress, uint256 tokenId) {
        require(IERC721Upgradeable(nftAddress).ownerOf(tokenId) == address(this), "Not staked");
        _;
    }

    modifier onlyNotStaked(address nftAddress, uint256 tokenId) {
        require(IERC721Upgradeable(nftAddress).ownerOf(tokenId) != address(this), "Already staked");
        _;
    }

    modifier onlyUnlocked(address nftAddress, uint256 tokenId) {
        require(GAME_STORAGE.getSkill(nftAddress, tokenId, 0, 0) == 1, "Not unlocked");
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Pausable_init();
        __AccessControl_init();

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(PAUSER_ROLE, _msgSender());
        _grantRole(UPDATER_ROLE, _msgSender());

        GAME_STORAGE = IGameStorageUpgradeable(0x3a55FFC97D2183d94147c4D2d3b6991f0C09ABf4);
    }

    /// PUBLIC functions

    // General staking

    function enableStaking(address nftAddress, uint256 tokenId) public whenNotPaused onlyNotStaked(nftAddress, tokenId) {
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

    function stake(address nftAddress, uint256 tokenId) public whenNotPaused
    onlyNotStaked(nftAddress, tokenId) onlyUnlocked(nftAddress, tokenId) {
        require(_config[nftAddress].startTime > 0, "Invalid stake");
        require(_config[nftAddress].startTime <= block.timestamp, "Staking has not started");

        IERC721Upgradeable(nftAddress).safeTransferFrom(_msgSender(), address(this), tokenId);

        _dataKeys.add(_msgSender());
        _data[_msgSender()].nfts.push(
            NFT({
                _address: nftAddress,
                tokenId: tokenId,
                rewardFrom: block.timestamp
            })
        );
        claim();
        emit Staked(_msgSender(), nftAddress, tokenId);
    }

    function batchStake(address[] memory nftAddresses, uint256[] memory tokenIds) public whenNotPaused {
        require(nftAddresses.length == tokenIds.length, "address count must match token count");
        for (uint256 i = 0; i < nftAddresses.length; i++) {
            stake(nftAddresses[i], tokenIds[i]);
        }
    }

    function unstake(address nftAddress, uint256 tokenId) public
    onlyStaked(nftAddress, tokenId) onlyUnlocked(nftAddress, tokenId) {
        require(_data[_msgSender()].nfts.length > 0, "No NFTs staked");
        NFT[] memory nfts = _data[_msgSender()].nfts;
        delete _data[_msgSender()].nfts;

        for (uint256 i = 0; i < nfts.length; i++) {
            if (nfts[i]._address == nftAddress && nfts[i].tokenId == tokenId) {
                _disburse_nft_reward(_msgSender(), nftAddress, tokenId, nfts[i].rewardFrom);
                delete _training_status[_msgSender()][nftAddress][tokenId];
            } else {
                _data[_msgSender()].nfts.push(NFT({
                    _address: nfts[i]._address,
                    tokenId: nfts[i].tokenId,
                    rewardFrom: nfts[i].rewardFrom
                }));
            }
        }
        claim();
        _clear_if_empty(_msgSender());

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
        _claim(_msgSender());
    }

    function _claim(address _address) internal {
        uint256 amountToClaim = _data[_address].rewards;
        if (amountToClaim >= 20000 ether) {
            emit ClaimBlocked(_address, _data[_address].nfts.length, amountToClaim);
            return;
        }
        _data[_address].rewards = 0;

        IERC20Upgradeable token = IERC20Upgradeable(0x892D81221484F690C0a97d3DD18B9144A3ECDFB7);

        require(token.balanceOf(address(this)) >= amountToClaim, "Insufficient rewards in contract");
        token.transfer(_address, amountToClaim);

        if (_data[_address].nfts.length == 0 && _data[_address].rewards == 0) {
            _dataKeys.remove(_msgSender());
        }
        emit Claimed(_address, address(token), amountToClaim);
    }


    function startTraining(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId)
    public whenNotPaused onlyStaked(nftAddress, tokenId) onlyUnlocked(nftAddress, tokenId) {
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

    function finishTraining(address nftAddress, uint256 tokenId) public
    onlyStaked(nftAddress, tokenId) onlyUnlocked(nftAddress, tokenId) {
        TrainingStatus storage trainingStatus = _training_status[_msgSender()][nftAddress][tokenId];
        require(trainingStatus.startedAt > 0, "Not training");
        require(trainingStatus.completeAt <= block.timestamp, "Training still in progress");
        for (uint256 i = 0; i < _data[_msgSender()].nfts.length; i++) {
            if (_data[_msgSender()].nfts[i].tokenId == tokenId) {
                _disburse_reward(_msgSender(), _data[_msgSender()].nfts[i]);
                break;
            }
        }
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

    function cancelTraining(address nftAddress, uint256 tokenId) public
    onlyStaked(nftAddress, tokenId) onlyUnlocked(nftAddress, tokenId) {
        TrainingStatus storage trainingStatus = _training_status[_msgSender()][nftAddress][tokenId];
        require(trainingStatus.startedAt > 0, "Not training");
        require(trainingStatus.completeAt > block.timestamp, "Training already finished");
        for (uint256 i = 0; i < _data[_msgSender()].nfts.length; i++) {
            if (_data[_msgSender()].nfts[i].tokenId == tokenId) {
                _disburse_reward(_msgSender(), _data[_msgSender()].nfts[i]);
                break;
            }
        }
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
        return pendingRewardsOf(_msgSender());
    }

    function pendingRewardsOf(address _address) public view returns(uint256) {
        uint256 total = _data[_address].rewards;
        uint256 lastTime = 1656379935;
        ParticipantData storage data = _data[_address];
        for (uint256 i = 0; i < data.nfts.length; i++) {
            if (data.nfts[i].rewardFrom >= lastTime) {
                continue;
            }
            uint256 elapsed = lastTime - data.nfts[i].rewardFrom;
            uint256 totalSkill = getTotalProfessionSkillPoints(data.nfts[i]._address, data.nfts[i].tokenId);
            total += ((totalSkill + 1) * 1e18 / 1 days) * elapsed;
        }
        return total;
    }

    function getStaked() public view returns(NFT[] memory) {
        return getStakedOf(_msgSender());
    }

    function getStakedOf(address _address) public view returns(NFT[] memory) {
        return _data[_address].nfts;
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
        return getActiveTrainingOf(_msgSender());
    }

    function getActiveTrainingOf(address _address) public view returns (TrainingStatus[] memory) {
        NFT[] memory nfts = _data[_address].nfts;
        uint256 count = 0;
        for (uint256 i = 0; i < nfts.length; i++) {
            TrainingStatus memory status = _training_status[_address][nfts[i]._address][nfts[i].tokenId];
            if (status.completeAt > 0) {
                count++;
            }
        }
        TrainingStatus[] memory training = new TrainingStatus[](count);
        uint256 added = 0;
        for (uint256 i = 0; i < nfts.length; i++) {
            TrainingStatus memory status = _training_status[_address][nfts[i]._address][nfts[i].tokenId];
            if (status.completeAt > 0) {
                training[added] = status;
                added++;
            }
        }
        return training;
    }

    function getTrainingStatus(
        address _address,
        address nftAddress,
        uint256 tokenId
    ) public view returns (TrainingStatus memory) {
        return _training_status[_address][nftAddress][tokenId];
    }

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
                added++;
            }
            if ((levels[i] > 0) && (levels[i] < stakingConfig.maxPointsPerSkill)) {
                uint256[] memory next = new uint256[](1);
                next[0] = stakingConfig.skillIds[i];
                return next;
            }
        }
        return all;
    }

    function forceCancelTraining(address _address, address nftAddress, uint256 tokenId) public onlyRole(DEFAULT_ADMIN_ROLE) {
        delete _training_status[_address][nftAddress][tokenId];
    }

    function modifyActiveTrainingSkill(
        address _address,
        address nftAddress,
        uint256 tokenId,
        uint256 skillId
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _training_status[_address][nftAddress][tokenId].skillId = skillId;
    }

    function adminUpdateNftData(
        address _address,
        uint256 index,
        address nftAddress,
        uint256 tokenId,
        uint256 rewardFrom
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _data[_address].nfts[index]._address = nftAddress;
        _data[_address].nfts[index].tokenId = tokenId;
        if (rewardFrom > 0) {
            _data[_address].nfts[index].rewardFrom = rewardFrom;
        }
    }
    function adminBatchUpdateNftData(
        address[] memory addresses,
        uint256[] memory indexes,
        address[] memory nftAddresses,
        uint256[] memory tokenIds,
        uint256[] memory rewardFrom
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        for (uint256 i = 0; i < addresses.length; i++) {
            adminUpdateNftData(addresses[i], indexes[i], nftAddresses[i], tokenIds[i], rewardFrom[i]);
        }
    }
    function getTotalProfessionSkillPoints(address ntfAddress, uint256 tokenId) public view returns(uint256) {
        uint256 totalSkillPoints = 0;
        for (uint256 i = 0; i < 12; i++) {
            uint256 points = GAME_STORAGE.getSkill(ntfAddress, tokenId, 1, i);
            totalSkillPoints += points;
        }
        return totalSkillPoints;
    }

    function getAllParticipantData() public view
    returns(address[] memory addresses, NFT[][] memory nfts, uint256[] memory rewards) {
        uint256 count = _dataKeys.length();
        rewards = new uint256[](count);
        nfts = new NFT[][](count);
        for (uint256 i = 0; i < count; i++) {
            nfts[i] = _data[_dataKeys.at(i)].nfts;
            rewards[i] = _data[_dataKeys.at(i)].rewards;
        }
        return (_dataKeys.values(), nfts, rewards);
    }

    /// internal

    function _clear_if_empty(address _address) internal {
        if (_data[_address].nfts.length == 0 && _data[_address].rewards == 0) {
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
            _disburse_reward(_address, data.nfts[i]);
        }
    }

    function _disburse_reward(address _address, NFT storage nft) internal {
        uint256 rewardFrom = nft.rewardFrom;
        nft.rewardFrom = block.timestamp;
        _disburse_nft_reward(_address, nft._address, nft.tokenId, rewardFrom);
    }

    function _disburse_nft_reward(address _address, address nftAddress, uint256 tokenId, uint256 rewardFrom) internal {
        if (rewardFrom == 0 || rewardFrom >= 1656379935) {
            return;
        }
        uint256 elapsed = 1656379935 - rewardFrom;
        uint256 totalSkill = getTotalProfessionSkillPoints(nftAddress, tokenId);
        totalSkill++; // add 1 for wizard base reward;
        _data[_address].rewards += (totalSkill * 1 ether / 1 days) * elapsed;
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

    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}