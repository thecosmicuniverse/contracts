// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../../../ERC721/interfaces/ICosmicAttributeStorage.sol";

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
        ICosmicAttributeStorage stakingToken;
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

    address private unused;
    address public treasury;

    ICosmicAttributeStorage constant private WIZARD = ICosmicAttributeStorage(0xBF20c23D25Fca8Aa4e7946496250D67872691Af2);
    IERC20Upgradeable constant private MAGIC = IERC20Upgradeable(0x9A8E0217cD870783c3f2317985C57Bf570969153);

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

    modifier onlyStaked(uint256 tokenId) {
        require(WIZARD.getSkill(tokenId, 0, 10) == 1, "Not staked");
        _;
    }

    modifier onlyNotStaked(uint256 tokenId) {
        require(WIZARD.getSkill(tokenId, 0, 10) == 0, "Already staked");
        _;
    }

    modifier onlyUnlocked(uint256 tokenId) {
        require(WIZARD.getSkill(tokenId, 0, 9) == 1, "Not unlocked");
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Pausable_init();
        __AccessControl_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
    }

    /// PUBLIC functions

    // General staking

    function enableStaking(uint256 tokenId) public whenNotPaused onlyNotStaked(tokenId) {
        require(WIZARD.getSkill(tokenId, 0, 9) == 0, "Staking already unlocked");

        MAGIC.transferFrom(msg.sender, address(this), 20 ether);
        _depositFee();
        WIZARD.updateSkill(tokenId, 0, 9, 1);

        emit StakingUnlocked(msg.sender, address(WIZARD), tokenId);
    }

    function batchEnableStaking(uint256[] memory tokenIds) public {
        require(tokenIds.length > 0, "token array empty");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            enableStaking(tokenIds[i]);
        }
    }

    function stake(uint256 tokenId) public whenNotPaused onlyUnlocked(tokenId) onlyNotStaked(tokenId) {
        WIZARD.updateSkill(tokenId, 0, 10, 1);
        _dataKeys.add(msg.sender);
        ParticipantData storage pd = _data[msg.sender];
        NFT storage nft = pd.nfts[tokenId];
        nft._address = address(MAGIC);
        nft.tokenId = tokenId;
        pd.nftIds.add(tokenId);

        emit Staked(msg.sender, address(WIZARD), tokenId);
    }

    function batchStake(uint256[] memory tokenIds) public {
        require(tokenIds.length > 0, "token array empty");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            stake(tokenIds[i]);
        }
    }

    function unstake(uint256 tokenId) public onlyStaked(tokenId) {
        ParticipantData storage pd = _data[msg.sender];
        require(pd.nftIds.contains(tokenId), "NFT Not staked");
        if (WIZARD.ownerOf(tokenId) == address(this)) {
            WIZARD.safeTransferFrom(address(this), msg.sender, tokenId);
        }

        WIZARD.updateSkill(tokenId, 0, 10, 0);
        delete pd.nfts[tokenId];
        pd.nftIds.remove(tokenId);

        if (pd.nftIds.length() == 0) {
            _dataKeys.remove(msg.sender);
        }
        emit Unstaked(msg.sender, address(WIZARD), tokenId);
    }

    function batchUnstake(uint256[] memory tokenIds) public {
        require(tokenIds.length > 0, "token array empty");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            unstake(tokenIds[i]);
        }
    }

    function startTraining(uint256 tokenId, uint256 skillId) public whenNotPaused onlyStaked(tokenId) {
        TrainingStatus storage status = _training_status[msg.sender][address(WIZARD)][tokenId];
        require(status.startedAt == 0, "Training is already in progress");
        require(isAllowedOption(tokenId, skillId), "Invalid training option");

        uint256 currentLevel = WIZARD.getSkill(tokenId, 1, skillId);
        require((currentLevel + 1) <= 20, "Exceeds maximum training level");

        TrainingLevelConfig storage training = _config[address(WIZARD)].trainingLevelConfig[currentLevel + 1];
        require(training.cost > 0, "Training Level is not enabled");

        MAGIC.transferFrom(msg.sender, address(this), training.cost);
        _depositFee();
        status.level = currentLevel + 1;
        status.treeId = 1;
        status.skillId = skillId;
        status.startedAt = block.timestamp;
        status.completeAt = block.timestamp + training.time;
        status._address = address(WIZARD);
        status.tokenId = tokenId;

        emit TrainingStarted(
            msg.sender,
            address(WIZARD),
            tokenId,
            1,
            skillId,
            currentLevel + 1,
            status.startedAt,
            status.completeAt
        );
    }

    function isAllowedOption(uint256 tokenId, uint256 skillId) internal view returns(bool) {
        uint256[] memory options = getAllowedSkillChoices(tokenId);
        require(options.length > 0, "No training sessions available");
        for (uint256 i = 0; i < options.length; i++) {
            if (options[i] == skillId) {
                return true;
            }
        }
        return false;
    }

    function batchStartTraining(uint256[] memory tokenIds, uint256[] memory skillIds) public {
        require(tokenIds.length > 0, "tokenIds array empty");
        require(tokenIds.length == skillIds.length, "tokenIds count must match skillIds count");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            startTraining(tokenIds[i], skillIds[i]);
        }
    }

    function finishTraining(uint256 tokenId) public onlyStaked(tokenId) {
        TrainingStatus storage status = _training_status[msg.sender][address(WIZARD)][tokenId];

        require(status.startedAt > 0, "Not training");
        require(status.completeAt <= block.timestamp, "Training still in progress");

        WIZARD.updateSkill(tokenId, 1, status.skillId, status.level);

        emit TrainingFinished(
            msg.sender,
            address(WIZARD),
            tokenId,
            status.treeId,
            status.skillId,
            status.level
        );

        delete _training_status[msg.sender][address(WIZARD)][tokenId];
    }

    function batchFinishTraining(uint256[] memory tokenIds) public {
        require(tokenIds.length > 0, "tokenIds array empty");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            finishTraining(tokenIds[i]);
        }
    }

    function cancelTraining(uint256 tokenId) public onlyStaked(tokenId) {
        TrainingStatus storage status = _training_status[msg.sender][address(WIZARD)][tokenId];
        require(status.startedAt > 0, "Not training");
        require(status.completeAt > block.timestamp, "Training already finished");

        emit TrainingCanceled(
            msg.sender,
            address(WIZARD),
            tokenId,
            status.treeId,
            status.skillId,
            block.timestamp
        );

        delete _training_status[msg.sender][address(WIZARD)][tokenId];
    }

    function batchCancelTraining(uint256[] memory tokenIds) public {
        require(tokenIds.length > 0, "tokenIds array empty");
        for (uint256 i = 0; i < tokenIds.length; i++) {
            cancelTraining(tokenIds[i]);
        }
    }
    /// UPDATER_ROLE functions

    function setTrainingCost(uint256 level, uint256 cost, uint256 time) public onlyRole(ADMIN_ROLE) {
        TrainingLevelConfig storage config = _config[address(WIZARD)].trainingLevelConfig[level];
        config.cost = cost;
        config.time = time;
    }

    function batchSetTrainingCosts(
        uint256[] memory level,
        uint256[] memory cost,
        uint256[] memory time
    ) public onlyRole(ADMIN_ROLE) {
        require((level.length == cost.length) && (cost.length == time.length), "All input arrays must be the same length");
        for (uint256 i = 0; i < level.length; i++) {
            setTrainingCost(level[i], cost[i], time[i]);
        }
    }

    function setSkillPointer(uint256 skillId) public onlyRole(ADMIN_ROLE) {
        Attribute storage attribute = _config[address(WIZARD)].stakingEnabledAttribute;
        attribute.treeId = 1;
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
        config.stakingToken = ICosmicAttributeStorage(stakingToken);
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

        StakingConfig storage config = _config[nftAddress];
        config.rewardToken = rewardToken;
        config.startTime = startTime;
        config.maxPointsPerSkill = maxPointsPerSkill;
        emit StakingConfigUpdated(nftAddress, address(rewardToken), startTime);
    }

    function deleteStakingConfig(address nftAddress) public onlyRole(ADMIN_ROLE) {

        delete _config[nftAddress];
        emit StakingConfigDeleted(nftAddress);
    }

    function _depositFee() internal {
        uint256 balance = MAGIC.balanceOf(address(this));
        if (balance > 0) {
            MAGIC.transfer(treasury, balance);
        }
    }

    /// Helpers

    // view
    function getStakedOf(address _address) public view returns(NFT[] memory) {
        ParticipantData storage pd = _data[_address];
        uint256[] memory nftIds = pd.nftIds.values();
        NFT[] memory nfts = new NFT[](nftIds.length);
        for (uint256 i = 0; i < nftIds.length; i++) {
            nfts[i] = pd.nfts[nftIds[i]];
        }
        return nfts;
    }

    function isStakingEnabled(uint256 tokenId) public view returns(bool) {
        uint256 unlocked = WIZARD.getSkill(tokenId, 0, 9);
        return unlocked == 1;
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

    function adminMigrateStaked(address[] memory accounts, uint256[] memory tokenIds) public onlyRole(ADMIN_ROLE) {
        require(accounts.length > 0, "Accounts array empty");
        require(accounts.length == tokenIds.length, "Array length mismatch");
        for (uint256 i = 0; i < accounts.length; i++) {
            if (isOwner(tokenIds[i], accounts[i])) {
                if (WIZARD.ownerOf(tokenIds[i]) == address(this)) {
                    WIZARD.safeTransferFrom(address(this), accounts[i], tokenIds[i]);
                }
            }
        }
    }

    function getTrainingStatus(
        address account,
        uint256 tokenId
    ) public view returns (TrainingStatus memory) {
        return _training_status[account][address(WIZARD)][tokenId];
    }

    function getAllowedSkillChoices(uint256 tokenId) public view returns(uint256[] memory) {
        StakingConfig storage config = _config[address(WIZARD)];
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

    function forceCancelTraining(address account, uint256 tokenId) public onlyRole(ADMIN_ROLE) {
        delete _training_status[account][address(WIZARD)][tokenId];
    }

    function modifyActiveTrainingSkill(
        address account,
        uint256 tokenId,
        uint256 skillId
    ) public onlyRole(ADMIN_ROLE) {
        _training_status[account][address(WIZARD)][tokenId].skillId = skillId;
    }

    function getTotalProfessionSkillPoints(uint256 tokenId) public view returns(uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < 12; i++) {
            uint256 points = WIZARD.getSkill(tokenId, 1, i);
            count += points;
        }
        return count;
    }

    function getAllParticipantData() public view returns(address[] memory addresses, NFT[][] memory nfts) {
        uint256 count = _dataKeys.length();
        nfts = new NFT[][](count);
        for (uint256 i = 0; i < count; i++) {
            ParticipantData storage pd = _data[_dataKeys.at(i)];
            uint256[] memory nftIds = pd.nftIds.values();
            NFT[] memory userNfts = new NFT[](nftIds.length);
            for (uint256 j = 0; j < userNfts.length; j++) {
                userNfts[j] = pd.nfts[nftIds[j]];
            }
            nfts[i] = userNfts;
        }
        return (_dataKeys.values(), nfts);
    }

    /// internal

    function setTrainingLevelConfig(
        uint256[] memory levels,
        uint256[] memory times,
        uint256[] memory costs
    ) public onlyRole(ADMIN_ROLE) {
        StakingConfig storage config = _config[address(WIZARD)];
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
        _pause();
    }

    /**
    * @dev Unpause contract write functions
    */
    function unpause() public onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}