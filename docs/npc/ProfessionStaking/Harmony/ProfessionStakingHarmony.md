# Solidity API

## ProfessionStakingHarmony

### PAUSER_ROLE

```solidity
bytes32 PAUSER_ROLE
```

### UPDATER_ROLE

```solidity
bytes32 UPDATER_ROLE
```

### GAME_STORAGE

```solidity
contract IGameStorageUpgradeable GAME_STORAGE
```

### NFT

```solidity
struct NFT {
  address _address;
  uint256 tokenId;
  uint256 rewardFrom;
}
```

### Token

```solidity
struct Token {
  address _address;
  uint256 amount;
}
```

### ParticipantData

```solidity
struct ParticipantData {
  struct ProfessionStakingHarmony.NFT[] nfts;
  struct ProfessionStakingHarmony.Token[] rewards;
}
```

### StakingConfig

```solidity
struct StakingConfig {
  uint256 startTime;
  uint256 maxPointsPerSkill;
  uint256[] treeIds;
  uint256[] skillIds;
  address rewardToken;
}
```

### StakingEnabledPointer

```solidity
struct StakingEnabledPointer {
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

### LAST_REWARD_TIME

```solidity
uint256 LAST_REWARD_TIME
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

### ClaimBlocked

```solidity
event ClaimBlocked(address from, uint256 stakedCount, uint256 amount)
```

### onlyStaked

```solidity
modifier onlyStaked(address nftAddress, uint256 tokenId)
```

### onlyNotStaked

```solidity
modifier onlyNotStaked(address nftAddress, uint256 tokenId)
```

### onlyUnlocked

```solidity
modifier onlyUnlocked(address nftAddress, uint256 tokenId)
```

### whenNotFinished

```solidity
modifier whenNotFinished()
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
function enableStaking(address nftAddress, uint256 tokenId) public
```

PUBLIC functions

### batchEnableStaking

```solidity
function batchEnableStaking(address[] nftAddresses, uint256[] tokenIds) public
```

### stake

```solidity
function stake(address nftAddress, uint256 tokenId) public
```

### batchStake

```solidity
function batchStake(address[] nftAddresses, uint256[] tokenIds) public
```

### unstake

```solidity
function unstake(address nftAddress, uint256 tokenId) public
```

### _unstake

```solidity
function _unstake(address _address, address nftAddress, uint256 tokenId) internal
```

### batchUnstake

```solidity
function batchUnstake(address[] nftAddresses, uint256[] tokenIds) public
```

### claim

```solidity
function claim() public
```

### _claim

```solidity
function _claim(address _address) internal
```

### startTraining

```solidity
function startTraining(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId) public
```

### batchStartTraining

```solidity
function batchStartTraining(address[] nftAddresses, uint256[] tokenIds, uint256[] treeIds, uint256[] skillIds) public
```

### finishTraining

```solidity
function finishTraining(address nftAddress, uint256 tokenId) public
```

### batchFinishTraining

```solidity
function batchFinishTraining(address[] nftAddresses, uint256[] tokenIds) public
```

### cancelTraining

```solidity
function cancelTraining(address nftAddress, uint256 tokenId) public
```

### batchCancelTraining

```solidity
function batchCancelTraining(address[] nftAddresses, uint256[] tokenIds) public
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

### setGameStorage

```solidity
function setGameStorage(address _address) public
```

### setSkillPointer

```solidity
function setSkillPointer(address nftAddress, uint256 treeId, uint256 skillId) public
```

### createStakingConfig

```solidity
function createStakingConfig(address nftAddress, address rewardToken, uint256 startTime, uint256 maxPointsPerSkill, uint256[] treeIds, uint256[] skillIds) public
```

### updateStakingConfig

```solidity
function updateStakingConfig(address nftAddress, address rewardToken, uint256 startTime, uint256 maxPointsPerSkill) public
```

### deleteStakingConfig

```solidity
function deleteStakingConfig(address nftAddress) public
```

### withdrawPoolRewards

```solidity
function withdrawPoolRewards(address to, address token, uint256 amount) public
```

### pendingRewards

```solidity
function pendingRewards() public view returns (uint256)
```

Helpers

### pendingRewardsOf

```solidity
function pendingRewardsOf(address _address) public view returns (uint256)
```

### getStaked

```solidity
function getStaked() public view returns (struct ProfessionStakingHarmony.NFT[])
```

### getStakedOf

```solidity
function getStakedOf(address _address) public view returns (struct ProfessionStakingHarmony.NFT[])
```

### isStakingEnabled

```solidity
function isStakingEnabled(address nftAddress, uint256 tokenId) public view returns (bool)
```

### getActiveTraining

```solidity
function getActiveTraining() public view returns (struct ProfessionStakingHarmony.TrainingStatus[])
```

### getActiveTrainingOf

```solidity
function getActiveTrainingOf(address _address) public view returns (struct ProfessionStakingHarmony.TrainingStatus[])
```

### getTrainingStatus

```solidity
function getTrainingStatus(address _address, address nftAddress, uint256 tokenId) public view returns (struct ProfessionStakingHarmony.TrainingStatus)
```

### getAllowedSkillChoices

```solidity
function getAllowedSkillChoices(address nftAddress, uint256 tokenId) public view returns (uint256[])
```

### forceCancelTraining

```solidity
function forceCancelTraining(address _address, address nftAddress, uint256 tokenId) public
```

### modifyActiveTrainingSkill

```solidity
function modifyActiveTrainingSkill(address _address, address nftAddress, uint256 tokenId, uint256 skillId) public
```

### adminUpdateNftData

```solidity
function adminUpdateNftData(address _address, uint256 index, address nftAddress, uint256 tokenId, uint256 rewardFrom) public
```

### adminBatchUpdateNftData

```solidity
function adminBatchUpdateNftData(address[] addresses, uint256[] indexes, address[] nftAddresses, uint256[] tokenIds, uint256[] rewardFrom) public
```

### getTotalProfessionSkillPoints

```solidity
function getTotalProfessionSkillPoints(address ntfAddress, uint256 tokenId) public view returns (uint256)
```

### getAllParticipantData

```solidity
function getAllParticipantData() public view returns (address[] addresses, struct ProfessionStakingHarmony.NFT[][] nfts, uint256[] rewards)
```

### _clear_if_empty

```solidity
function _clear_if_empty(address _address) internal
```

internal

### _disburse_all_rewards

```solidity
function _disburse_all_rewards() internal
```

### _disburse_rewards

```solidity
function _disburse_rewards(address _address) internal
```

### _disburse_reward

```solidity
function _disburse_reward(address _address, struct ProfessionStakingHarmony.NFT nft) internal
```

### _disburse_nft_reward

```solidity
function _disburse_nft_reward(address _address, address nftAddress, uint256 tokenId, uint256 rewardFrom) internal
```

### claimAndUnstakeForUser

```solidity
function claimAndUnstakeForUser(address _address) public
```

### batchClaimAndUnstakeForUser

```solidity
function batchClaimAndUnstakeForUser(address[] addresses) public
```

### adminGetData

```solidity
function adminGetData(address user) public view returns (uint256 contractBalance, uint256 userPending)
```

### setLastRewardTime

```solidity
function setLastRewardTime(uint256 time) public
```

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

