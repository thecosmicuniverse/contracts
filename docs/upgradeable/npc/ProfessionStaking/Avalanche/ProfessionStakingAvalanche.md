# Solidity API

## ProfessionStakingAvalanche

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### NFT

```solidity
struct NFT {
  address _address;
  uint256 tokenId;
  uint256 rewardFrom;
}
```

### ParticipantData

```solidity
struct ParticipantData {
  struct EnumerableSetUpgradeable.UintSet nftIds;
  mapping(uint256 => struct ProfessionStakingAvalanche.NFT) nfts;
  uint256 rewards;
}
```

### Attribute

```solidity
struct Attribute {
  uint256 treeId;
  uint256 skillId;
}
```

### TrainingLevelConfig

```solidity
struct TrainingLevelConfig {
  uint256 cost;
  uint256 time;
}
```

### StakingConfig

```solidity
struct StakingConfig {
  uint256 startTime;
  uint256 maxPointsPerSkill;
  uint256 treeId;
  uint256[] skillIds;
  contract IERC20Upgradeable rewardToken;
  mapping(uint256 => struct ProfessionStakingAvalanche.TrainingLevelConfig) trainingLevelConfig;
  contract ICosmicAttributeStorage stakingToken;
  struct ProfessionStakingAvalanche.Attribute stakingEnabledAttribute;
}
```

### TrainingStatus

```solidity
struct TrainingStatus {
  address _address;
  uint256 tokenId;
  uint256 level;
  uint256 treeId;
  uint256 skillId;
  uint256 startedAt;
  uint256 completeAt;
}
```

### treasury

```solidity
address treasury
```

### StakingConfigCreated

```solidity
event StakingConfigCreated(address nftAddress, address rewardToken, uint256 startTime)
```

### StakingConfigUpdated

```solidity
event StakingConfigUpdated(address nftAddress, address rewardToken, uint256 startTime)
```

### StakingConfigDeleted

```solidity
event StakingConfigDeleted(address nftAddress)
```

### Staked

```solidity
event Staked(address from, address nftAddress, uint256 tokenId)
```

### Unstaked

```solidity
event Unstaked(address from, address nftAddress, uint256 tokenId)
```

### Claimed

```solidity
event Claimed(address by, address token, uint256 amount)
```

### PoolRewardsDeposited

```solidity
event PoolRewardsDeposited(address from, address token, uint256 amount)
```

### PoolRewardsWithdrawn

```solidity
event PoolRewardsWithdrawn(address by, address to, address token, uint256 amount)
```

### StakingUnlocked

```solidity
event StakingUnlocked(address by, address nftAddress, uint256 tokenId)
```

### TrainingStarted

```solidity
event TrainingStarted(address by, address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 level, uint256 startedAt, uint256 completeAt)
```

### TrainingFinished

```solidity
event TrainingFinished(address by, address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 level)
```

### TrainingCanceled

```solidity
event TrainingCanceled(address by, address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 canceledAt)
```

### onlyStaked

```solidity
modifier onlyStaked(uint256 tokenId)
```

### onlyNotStaked

```solidity
modifier onlyNotStaked(uint256 tokenId)
```

### onlyUnlocked

```solidity
modifier onlyUnlocked(uint256 tokenId)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### enableStaking

```solidity
function enableStaking(uint256 tokenId) public
```

PUBLIC functions

### batchEnableStaking

```solidity
function batchEnableStaking(uint256[] tokenIds) public
```

### stake

```solidity
function stake(uint256 tokenId) public
```

### batchStake

```solidity
function batchStake(uint256[] tokenIds) public
```

### unstake

```solidity
function unstake(uint256 tokenId) public
```

### batchUnstake

```solidity
function batchUnstake(uint256[] tokenIds) public
```

### startTraining

```solidity
function startTraining(uint256 tokenId, uint256 skillId) public
```

### isAllowedOption

```solidity
function isAllowedOption(uint256 tokenId, uint256 skillId) internal view returns (bool)
```

### batchStartTraining

```solidity
function batchStartTraining(uint256[] tokenIds, uint256[] skillIds) public
```

### finishTraining

```solidity
function finishTraining(uint256 tokenId) public
```

### batchFinishTraining

```solidity
function batchFinishTraining(uint256[] tokenIds) public
```

### cancelTraining

```solidity
function cancelTraining(uint256 tokenId) public
```

### batchCancelTraining

```solidity
function batchCancelTraining(uint256[] tokenIds) public
```

### setTrainingCost

```solidity
function setTrainingCost(uint256 level, uint256 cost, uint256 time) public
```

UPDATER_ROLE functions

### batchSetTrainingCosts

```solidity
function batchSetTrainingCosts(uint256[] level, uint256[] cost, uint256[] time) public
```

### setSkillPointer

```solidity
function setSkillPointer(uint256 skillId) public
```

### createStakingConfig

```solidity
function createStakingConfig(address stakingToken, address rewardToken, uint256 startTime, uint256 maxPointsPerSkill, uint256 treeId, uint256[] skillIds) public
```

### updateStakingConfig

```solidity
function updateStakingConfig(address nftAddress, contract IERC20Upgradeable rewardToken, uint256 startTime, uint256 maxPointsPerSkill) public
```

### deleteStakingConfig

```solidity
function deleteStakingConfig(address nftAddress) public
```

### _depositFee

```solidity
function _depositFee() internal
```

### getStakedOf

```solidity
function getStakedOf(address _address) public view returns (struct ProfessionStakingAvalanche.NFT[])
```

Helpers

### isStakingEnabled

```solidity
function isStakingEnabled(uint256 tokenId) public view returns (bool)
```

### getActiveTrainingOf

```solidity
function getActiveTrainingOf(address _address) public view returns (struct ProfessionStakingAvalanche.TrainingStatus[])
```

### isOwner

```solidity
function isOwner(uint256 tokenId, address owner) public view returns (bool)
```

### adminMigrateStaked

```solidity
function adminMigrateStaked(address[] accounts, uint256[] tokenIds) public
```

### getTrainingStatus

```solidity
function getTrainingStatus(address account, uint256 tokenId) public view returns (struct ProfessionStakingAvalanche.TrainingStatus)
```

### getAllowedSkillChoices

```solidity
function getAllowedSkillChoices(uint256 tokenId) public view returns (uint256[])
```

### forceCancelTraining

```solidity
function forceCancelTraining(address account, uint256 tokenId) public
```

### modifyActiveTrainingSkill

```solidity
function modifyActiveTrainingSkill(address account, uint256 tokenId, uint256 skillId) public
```

### getTotalProfessionSkillPoints

```solidity
function getTotalProfessionSkillPoints(uint256 tokenId) public view returns (uint256)
```

### getAllParticipantData

```solidity
function getAllParticipantData() public view returns (address[] addresses, struct ProfessionStakingAvalanche.NFT[][] nfts)
```

### setTrainingLevelConfig

```solidity
function setTrainingLevelConfig(uint256[] levels, uint256[] times, uint256[] costs) public
```

internal

### pause

```solidity
function pause() public
```

_Pause contract write functions_

### unpause

```solidity
function unpause() public
```

_Unpause contract write functions_

### onERC721Received

```solidity
function onERC721Received(address, address, uint256, bytes) external pure returns (bytes4)
```

