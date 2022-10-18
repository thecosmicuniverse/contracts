// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../ERC721/interfaces/ICosmicAttributeStorageUpgradeable.sol";

/**
* @title Cosmic Universe NFT Staking v2.0.0
* @author @DirtyCajunRice
*/
contract ProfessionStakingAvalanche is Initializable, PausableUpgradeable, AccessControlUpgradeable, IERC721ReceiverUpgradeable {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    struct NFT {
        address _address;
        uint256 tokenId;
        uint256 rewardFrom;
    }

    struct ParticipantData {
        EnumerableSetUpgradeable.UintSet nftIds;
        mapping(uint256 => NFT) nfts;
        uint256 rewards;
    }

    struct Attribute {
        uint256 treeId;
        uint256 skillId;
    }

    struct TrainingLevelConfig {
        uint256 cost;
        uint256 time;
    }

    struct StakingConfig {
        uint256 startTime;
        uint256 maxPointsPerSkill;
        uint256 treeId;
        uint256[] skillIds;
        IERC20Upgradeable rewardToken;
        mapping(uint256 => TrainingLevelConfig) trainingLevelConfig;
        ICosmicAttributeStorageUpgradeable stakingToken;
        Attribute stakingEnabledAttribute;
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

    // Wallet address to ParticipantData mapping
    mapping (address => ParticipantData) private _data;
    // Wallet address key set
    EnumerableSetUpgradeable.AddressSet private _dataKeys;
    // NFT collection to staking config mapping
    mapping (address => StakingConfig) private _config;
    // Nft collection config key set
    EnumerableSetUpgradeable.AddressSet private _configKeys;


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

    modifier onlyStaked(address nftAddress, uint256 tokenId) {
        require(IERC721Upgradeable(nftAddress).ownerOf(tokenId) == address(this), "Not staked");
        _;
    }

    modifier onlyNotStaked(address nftAddress, uint256 tokenId) {
        require(IERC721Upgradeable(nftAddress).ownerOf(tokenId) != address(this), "Already staked");
        _;
    }

    modifier onlyUnlocked(address nftAddress, uint256 tokenId) {
        StakingConfig storage config = _config[nftAddress];
        require(
            config.stakingToken.getSkill(
                tokenId,
                config.stakingEnabledAttribute.treeId,
                config.stakingEnabledAttribute.skillId
            ) == 1,
            "Not unlocked"
        );
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
        _grantRole(ADMIN_ROLE, _msgSender());
    }

    /// PUBLIC functions

    // General staking

    function enableStaking(address nftAddress, uint256 tokenId) public whenNotPaused onlyNotStaked(nftAddress, tokenId) {
        StakingConfig storage config = _config[nftAddress];
        Attribute storage stakingEnabledAttribute = config.stakingEnabledAttribute;
        require(
            config.stakingToken.getSkill(
                tokenId,
                config.stakingEnabledAttribute.treeId,
                config.stakingEnabledAttribute.skillId
            ) == 0,
           "Staking already unlocked"
        );

        require(config.startTime > 0, "Staking not configured");
        require(config.startTime <= block.timestamp, "Staking has not started");

        config.rewardToken.transferFrom(_msgSender(), address(this), config.trainingLevelConfig[0].cost);
        config.stakingToken.updateSkill(tokenId, stakingEnabledAttribute.treeId, stakingEnabledAttribute.skillId, 1);

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
        StakingConfig storage config = _config[nftAddress];
        require(config.startTime > 0, "Invalid stake");
        require(config.startTime <= block.timestamp, "Staking has not started");

        claim();
        config.stakingToken.safeTransferFrom(_msgSender(), address(this), tokenId);
        Attribute storage staking = config.stakingEnabledAttribute;
        config.stakingToken.updateSkill(tokenId, staking.treeId, staking.skillId+1, 1);
        _dataKeys.add(_msgSender());
        ParticipantData storage pd = _data[_msgSender()];
        NFT storage nft = pd.nfts[tokenId];
        nft._address = nftAddress;
        nft.tokenId = tokenId;
        nft.rewardFrom = block.timestamp;
        pd.nftIds.add(tokenId);

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
        StakingConfig storage config = _config[nftAddress];
        ParticipantData storage pd = _data[_msgSender()];
        require(pd.nftIds.contains(tokenId), "NFT Not staked");
        claim();
        config.stakingToken.safeTransferFrom(address(this), _msgSender(), tokenId);
        Attribute storage staking = config.stakingEnabledAttribute;
        config.stakingToken.updateSkill(tokenId, staking.treeId, staking.skillId+1, 0);
        delete pd.nfts[tokenId];
        pd.nftIds.remove(tokenId);

        if (pd.nftIds.length() == 0) {
            _dataKeys.remove(_msgSender());
        }

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

    function adminClaim(address[] memory addresses) public onlyRole(ADMIN_ROLE) {
        for (uint256 i = 0; i < addresses.length; i++) {
            _disburse_rewards(addresses[i]);
            _claim(addresses[i]);
        }
    }

    function _claim(address _address) internal {
        address nftAddress = 0xBF20c23D25Fca8Aa4e7946496250D67872691Af2;
        StakingConfig storage config = _config[nftAddress];
        ParticipantData storage pd = _data[_address];
        uint256 amountToClaim = pd.rewards;
        pd.rewards = 0;

        require(config.rewardToken.balanceOf(address(this)) >= amountToClaim, "Insufficient rewards in contract");
        config.rewardToken.transfer(_address, amountToClaim);

        if (pd.nftIds.length() == 0) {
            _dataKeys.remove(_address);
        }
        emit Claimed(_address, address(config.rewardToken), amountToClaim);
    }


    function startTraining(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId)
    public whenNotPaused onlyStaked(nftAddress, tokenId) onlyUnlocked(nftAddress, tokenId) {
        StakingConfig storage config = _config[nftAddress];
        require(config.startTime > 0, "No training session configured");
        require(config.startTime <= block.timestamp, "Training has not started yet");

        TrainingStatus storage status = _training_status[_msgSender()][nftAddress][tokenId];
        require(status.startedAt == 0, "Training is already in progress");


        require(isAllowedOption(nftAddress, tokenId, skillId), "Invalid training option");

        uint256 currentLevel = config.stakingToken.getSkill(tokenId, treeId, skillId);
        require((currentLevel + 1) <= config.maxPointsPerSkill, "Exceeds maximum training level");

        TrainingLevelConfig storage training = config.trainingLevelConfig[currentLevel + 1];
        require(training.cost > 0, "Training Level is not enabled");

        config.rewardToken.transferFrom(_msgSender(), address(this), training.cost);

        status.level = currentLevel + 1;
        status.treeId = treeId;
        status.skillId = skillId;
        status.startedAt = block.timestamp;
        status.completeAt = block.timestamp + training.time;
        status._address = nftAddress;
        status.tokenId = tokenId;

        emit TrainingStarted(
            _msgSender(),
            nftAddress,
            tokenId,
            treeId,
            skillId,
            currentLevel + 1,
            status.startedAt,
            status.completeAt
        );
    }

    function isAllowedOption(address nftAddress, uint256 tokenId, uint256 skillId) internal view returns(bool) {
        uint256[] memory options = getAllowedSkillChoices(nftAddress, tokenId);
        require(options.length > 0, "No training sessions available");
        for (uint256 i = 0; i < options.length; i++) {
            if (options[i] == skillId) {
                return true;
            }
        }
        return false;
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
        StakingConfig storage config = _config[nftAddress];
        TrainingStatus storage status = _training_status[_msgSender()][nftAddress][tokenId];
        ParticipantData storage pd = _data[_msgSender()];

        require(status.startedAt > 0, "Not training");
        require(status.completeAt <= block.timestamp, "Training still in progress");
        _disburse_reward(_msgSender(), pd.nfts[tokenId]);

        config.stakingToken.updateSkill(tokenId, status.treeId, status.skillId, status.level);

        emit TrainingFinished(
            _msgSender(),
            nftAddress,
            tokenId,
            status.treeId,
            status.skillId,
            status.level
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
        TrainingStatus storage status = _training_status[_msgSender()][nftAddress][tokenId];
        require(status.startedAt > 0, "Not training");
        require(status.completeAt > block.timestamp, "Training already finished");
        ParticipantData storage pd = _data[_msgSender()];
        _disburse_reward(_msgSender(), pd.nfts[tokenId]);

        emit TrainingCanceled(
            _msgSender(),
            nftAddress,
            tokenId,
            status.treeId,
            status.skillId,
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

    function setTrainingCost(address nftAddress, uint256 level, uint256 cost, uint256 time) public onlyRole(ADMIN_ROLE) {
        TrainingLevelConfig storage config = _config[nftAddress].trainingLevelConfig[level];
        config.cost = cost;
        config.time = time;
    }

    function batchSetTrainingCosts(
        address nftAddress,
        uint256[] memory level,
        uint256[] memory cost,
        uint256[] memory time
    ) public onlyRole(ADMIN_ROLE) {
        require((level.length == cost.length) && (cost.length == time.length), "All input arrays must be the same length");
        for (uint256 i = 0; i < level.length; i++) {
            setTrainingCost(nftAddress, level[i], cost[i], time[i]);
        }
    }

    function setSkillPointer(address nftAddress, uint256 treeId, uint256 skillId) public onlyRole(ADMIN_ROLE) {
        Attribute storage attribute = _config[nftAddress].stakingEnabledAttribute;
        attribute.treeId = treeId;
        attribute.skillId = skillId;
    }

    function createStakingConfig(
        address stakingToken,
        address rewardToken,
        uint256 startTime,
        uint256 maxPointsPerSkill,
        uint256 treeId,
        uint256[] memory skillIds
    ) public onlyRole(ADMIN_ROLE) {
        StakingConfig storage config = _config[stakingToken];
        require(config.startTime == 0, "Staking config already exists");
        require(treeId > 0, "Missing treeId config");
        require(skillIds.length > 0, "Missing skillId config");
        require(maxPointsPerSkill > 0, "maxPointsPerSkill must be greater than 0");
        require(startTime > block.timestamp, "startTime must be a future time in seconds");

        config.startTime = startTime;
        config.maxPointsPerSkill = maxPointsPerSkill;
        config.treeId = treeId;
        for (uint256 i = 0; i < skillIds.length; i++) {
            config.skillIds.push(skillIds[i]);
        }
        config.rewardToken = IERC20Upgradeable(rewardToken);
        config.stakingToken = ICosmicAttributeStorageUpgradeable(stakingToken);
        Attribute storage stakingEnabledAttribute = config.stakingEnabledAttribute;
        stakingEnabledAttribute.treeId = 0;
        stakingEnabledAttribute.skillId = 9;

        emit StakingConfigCreated(stakingToken, rewardToken, config.startTime);
    }

    function updateStakingConfig(
        address nftAddress,
        IERC20Upgradeable rewardToken,
        uint256 startTime,
        uint256 maxPointsPerSkill
    ) public onlyRole(ADMIN_ROLE) {
        require(_config[nftAddress].startTime != 0, "Staking config does not exist");
        require(maxPointsPerSkill > 0, "maxPointsPerSkill must be greater than 0");
        require(startTime > block.timestamp, "startTime must be a future time in seconds");

        _disburse_all_rewards();

        StakingConfig storage config = _config[nftAddress];
        config.rewardToken = rewardToken;
        config.startTime = startTime;
        config.maxPointsPerSkill = maxPointsPerSkill;
        emit StakingConfigUpdated(nftAddress, address(rewardToken), startTime);
    }

    function deleteStakingConfig(address nftAddress) public onlyRole(ADMIN_ROLE) {
        _disburse_all_rewards();

        delete _config[nftAddress];
        emit StakingConfigDeleted(nftAddress);
    }

    function withdrawPoolRewards(address to, address nftAddress, uint256 amount) public onlyRole(ADMIN_ROLE) {
        _disburse_all_rewards();
        StakingConfig storage config = _config[nftAddress];
        require(config.rewardToken.balanceOf(address(this)) >= amount, "Insufficient balance");
        config.rewardToken.transferFrom(address(this), to, amount);

        emit PoolRewardsWithdrawn(_msgSender(), to, address(config.rewardToken), amount);
    }

    /// Helpers

    // view

    function pendingRewards() public pure returns(uint256) {
        return 0;
        //return pendingRewardsOf(_msgSender());
    }

    function pendingRewardsOf(address) public pure returns(uint256) {
        return 0;
        //ParticipantData storage pd = _data[_address];
        //uint256 total = pd.rewards;
        //uint256[] memory nftIds = pd.nftIds.values();
        //for (uint256 i = 0; i < nftIds.length; i++) {
        //    NFT memory nft = pd.nfts[nftIds[i]];
        //    uint256 timestamp = block.timestamp >= 1665964799 ? 1665964799 : block.timestamp;
        //    uint256 elapsed = timestamp - nft.rewardFrom;
        //    uint256 totalSkill = getTotalProfessionSkillPoints(nft._address, nft.tokenId);
        //    total += ((totalSkill + 1) * 1e18 / 1 days) * elapsed;
        //}
        //return total;
    }

    function getStaked() public view returns(NFT[] memory) {
        return getStakedOf(_msgSender());
    }

    function getStakedOf(address _address) public view returns(NFT[] memory) {
        ParticipantData storage pd = _data[_address];
        uint256[] memory nftIds = pd.nftIds.values();
        NFT[] memory nfts = new NFT[](nftIds.length);
        for (uint256 i = 0; i < nftIds.length; i++) {
            nfts[i] = pd.nfts[nftIds[i]];
        }
        return nfts;
    }

    function isStakingEnabled(address nftAddress, uint256 tokenId) public view returns(bool) {
        StakingConfig storage config = _config[nftAddress];
        Attribute storage attr = config.stakingEnabledAttribute;
        uint256 unlocked = config.stakingToken.getSkill(tokenId, attr.treeId, attr.skillId);
        return unlocked == 1;
    }

    function getActiveTraining() public view returns (TrainingStatus[] memory) {
        return getActiveTrainingOf(_msgSender());
    }

    function getActiveTrainingOf(address _address) public view returns (TrainingStatus[] memory) {
        ParticipantData storage pd = _data[_address];
        uint256[] memory nftIds = pd.nftIds.values();
        uint256 count = 0;
        for (uint256 i = 0; i < nftIds.length; i++) {
            NFT memory nft = pd.nfts[nftIds[i]];
            if (_training_status[_address][nft._address][nft.tokenId].completeAt > 0) {
                count++;
            }
        }
        TrainingStatus[] memory training = new TrainingStatus[](count);
        uint256 added = 0;
        for (uint256 i = 0; i < nftIds.length; i++) {
            NFT memory nft = pd.nfts[nftIds[i]];
            TrainingStatus memory status = _training_status[_address][nft._address][nft.tokenId];
            if (status.completeAt > 0) {
                training[added] = status;
                added++;
            }
        }
        return training;
    }

    function isOwner(uint256 tokenId, address owner) public view returns (bool) {
        ParticipantData storage pd = _data[owner];
        uint256[] memory nftIds = pd.nftIds.values();
        for (uint256 i = 0; i < nftIds.length; i++) {
            if (pd.nfts[nftIds[i]].tokenId == tokenId) {
                return true;
            }
        }
        return false;
    }

    function getTrainingStatus(
        address _address,
        address nftAddress,
        uint256 tokenId
    ) public view returns (TrainingStatus memory) {
        return _training_status[_address][nftAddress][tokenId];
    }

    function getAllowedSkillChoices(address nftAddress, uint256 tokenId) public view returns(uint256[] memory) {
        StakingConfig storage config = _config[nftAddress];
        require(config.startTime > 0, "No training session configured");
        uint256[] memory levels = new uint256[](config.skillIds.length);
        uint256 leveledSkillIdCount = 0;
        uint256 maxedSkillIdCount = 0;
        for (uint256 i = 0; i < config.skillIds.length; i++) {
            levels[i] = config.stakingToken.getSkill(
                tokenId,
                config.treeId,
                config.skillIds[i]
            );
            if (levels[i] > 0) {
                leveledSkillIdCount++;
            }
            if (levels[i] == config.maxPointsPerSkill) {
                maxedSkillIdCount++;
            }
        }
        if (leveledSkillIdCount == 0) {
            return config.skillIds;
        }
        if (maxedSkillIdCount == 2) {
            uint256[] memory empty;
            return empty;
        }
        uint256[] memory all = new uint256[](config.skillIds.length - 1);
        uint256 added = 0;
        for (uint256 i = 0; i < levels.length; i++) {
            if ((maxedSkillIdCount == 1) && (leveledSkillIdCount == 1) && (levels[i] == 0)) {
                all[added] = config.skillIds[i];
                added++;
            }
            if ((levels[i] > 0) && (levels[i] < config.maxPointsPerSkill)) {
                uint256[] memory next = new uint256[](1);
                next[0] = config.skillIds[i];
                return next;
            }
        }
        return all;
    }

    function forceCancelTraining(address _address, address nftAddress, uint256 tokenId) public onlyRole(ADMIN_ROLE) {
        delete _training_status[_address][nftAddress][tokenId];
    }

    function modifyActiveTrainingSkill(
        address _address,
        address nftAddress,
        uint256 tokenId,
        uint256 skillId
    ) public onlyRole(ADMIN_ROLE) {
        _training_status[_address][nftAddress][tokenId].skillId = skillId;
    }

    function adminUpdateNftData(
        address _address,
        uint256 tokenId,
        uint256 rewardFrom
    ) public onlyRole(ADMIN_ROLE) {
        ParticipantData storage pd = _data[_address];
        NFT storage nft = pd.nfts[tokenId];
        nft.tokenId = tokenId;
        if (rewardFrom > 0) {
            nft.rewardFrom = rewardFrom;
        }
    }
    function adminBatchUpdateNftData(
        address[] memory addresses,
        uint256[] memory tokenIds,
        uint256[] memory rewardFrom
    ) public onlyRole(ADMIN_ROLE) {
        for (uint256 i = 0; i < addresses.length; i++) {
            adminUpdateNftData(addresses[i], tokenIds[i], rewardFrom[i]);
        }
    }
    function getTotalProfessionSkillPoints(address nftAddress, uint256 tokenId) public view returns(uint256) {
        StakingConfig storage config = _config[nftAddress];
        uint256 totalSkillPoints = 0;
        for (uint256 i = 0; i < config.skillIds.length; i++) {
            uint256 points = config.stakingToken.getSkill(tokenId, config.treeId, config.skillIds[i]);
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
            ParticipantData storage pd = _data[_dataKeys.at(i)];
            uint256[] memory nftIds = pd.nftIds.values();
            NFT[] memory userNfts = new NFT[](nftIds.length);
            for (uint256 j = 0; j < userNfts.length; j++) {
                userNfts[j] = pd.nfts[nftIds[j]];
            }
            nfts[i] = userNfts;
            rewards[i] = pd.rewards;
        }
        return (_dataKeys.values(), nfts, rewards);
    }

    /// internal

    function _disburse_all_rewards() internal {
        for (uint256 i = 0; i < _dataKeys.length(); i++) {
            _disburse_rewards(_dataKeys.at(i));
        }
    }

    function _disburse_rewards(address _address) internal {
        ParticipantData storage data = _data[_address];
        uint256[] memory nftIds = data.nftIds.values();
        for (uint256 i = 0; i < nftIds.length; i++) {
            _disburse_reward(_address, data.nfts[nftIds[i]]);
        }
    }

    function _disburse_reward(address _address, NFT storage nft) internal {
        uint256 rewardFrom = nft.rewardFrom >= 1665964799 ? 1665964799 : nft.rewardFrom;
        nft.rewardFrom = block.timestamp >= 1665964799 ? 1665964799 : block.timestamp;
        _disburse_nft_reward(_address, nft._address, nft.tokenId, rewardFrom);
    }

    function _disburse_nft_reward(address _address, address nftAddress, uint256 tokenId, uint256 rewardFrom) internal {
        if (rewardFrom == 0 || rewardFrom >= block.timestamp || rewardFrom >= 1665964799) {
            return;
        }
        uint256 elapsed = block.timestamp - rewardFrom;
        uint256 totalSkill = getTotalProfessionSkillPoints(nftAddress, tokenId);
        totalSkill++; // add 1 for wizard base reward;
        _data[_address].rewards += (totalSkill * 1 ether / 1 days) * elapsed;
    }

    function setTrainingLevelConfig(
        address nftAddress,
        uint256[] memory levels,
        uint256[] memory times,
        uint256[] memory costs
    ) public onlyRole(ADMIN_ROLE) {
        StakingConfig storage config = _config[nftAddress];
        for (uint256 i = 0; i < levels.length; i++) {
            config.trainingLevelConfig[levels[i]].time = times[i];
            config.trainingLevelConfig[levels[i]].cost = costs[i];
        }
    }
    /// Standard functions

    /**
    * @dev Pause contract write functions
    */
    function pause() public onlyRole(ADMIN_ROLE) {
        _disburse_all_rewards();
        _pause();
    }

    /**
    * @dev Unpause contract write functions
    */
    function unpause() public onlyRole(ADMIN_ROLE) {
        _disburse_all_rewards();
        _unpause();
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}