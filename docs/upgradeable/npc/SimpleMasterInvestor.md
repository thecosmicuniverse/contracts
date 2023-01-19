# Solidity API

## SimpleMasterInvestor

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

### UserInfo

```solidity
struct UserInfo {
  uint256 amount;
  uint256 rewardDebt;
  uint256 rewardDebtAtTime;
  uint256 lastWithdrawTime;
  uint256 firstDepositTime;
  uint256 timeDelta;
  uint256 lastDepositTime;
}
```

### PoolInfo

```solidity
struct PoolInfo {
  contract IERC20ExtendedUpgradeable lpToken;
  uint256 allocPoint;
  uint256 lastRewardTime;
  uint256 accGovTokenPerShare;
}
```

### ConstructorParams

```solidity
struct ConstructorParams {
  contract IERC20ExtendedUpgradeable govToken;
  uint256 rewardPerSecond;
  uint256 startTime;
  uint256 userDepositFee;
  uint256 devDepositFee;
  address devFundAddress;
  address feeShareFundAddress;
  address marketingFundAddress;
  address foundersFundAddress;
  uint256[] userFeeStages;
  uint256[] devFeeStages;
}
```

### GOV_TOKEN

```solidity
contract IERC20ExtendedUpgradeable GOV_TOKEN
```

### DEV_FUND_ADDRESS

```solidity
address DEV_FUND_ADDRESS
```

### FEE_SHARE_FUND_ADDRESS

```solidity
address FEE_SHARE_FUND_ADDRESS
```

### MARKETING_FUND_ADDRESS

```solidity
address MARKETING_FUND_ADDRESS
```

### FOUNDERS_FUND_ADDRESS

```solidity
address FOUNDERS_FUND_ADDRESS
```

### REWARD_PER_SECOND

```solidity
uint256 REWARD_PER_SECOND
```

### USER_FEE_STAGES

```solidity
uint256[] USER_FEE_STAGES
```

### DEV_FEE_STAGES

```solidity
uint256[] DEV_FEE_STAGES
```

### USER_DEP_FEE

```solidity
uint256 USER_DEP_FEE
```

### DEV_DEP_FEE

```solidity
uint256 DEV_DEP_FEE
```

### START_TIME

```solidity
uint256 START_TIME
```

### TOTAL_ALLOCATION_POINTS

```solidity
uint256 TOTAL_ALLOCATION_POINTS
```

### PERCENT_FOR_DEV

```solidity
uint256 PERCENT_FOR_DEV
```

### PERCENT_FOR_FEE_SHARE

```solidity
uint256 PERCENT_FOR_FEE_SHARE
```

### PERCENT_FOR_MARKETING

```solidity
uint256 PERCENT_FOR_MARKETING
```

### PERCENT_FOR_FOUNDERS

```solidity
uint256 PERCENT_FOR_FOUNDERS
```

### poolInfo

```solidity
struct SimpleMasterInvestor.PoolInfo[] poolInfo
```

### poolId

```solidity
mapping(address => uint256) poolId
```

### userInfo

```solidity
mapping(uint256 => mapping(address => struct SimpleMasterInvestor.UserInfo)) userInfo
```

### poolExistence

```solidity
mapping(contract IERC20ExtendedUpgradeable => bool) poolExistence
```

### FINISH_BONUS_AT_TIME

```solidity
uint256 FINISH_BONUS_AT_TIME
```

### HALVING_AT_TIMES

```solidity
uint256[] HALVING_AT_TIMES
```

### REWARD_MULTIPLIERS

```solidity
uint256[] REWARD_MULTIPLIERS
```

### PERCENT_LOCK_BONUS_REWARD

```solidity
uint256[] PERCENT_LOCK_BONUS_REWARD
```

### Deposit

```solidity
event Deposit(address user, uint256 pid, uint256 amount)
```

### Withdraw

```solidity
event Withdraw(address user, uint256 pid, uint256 amount)
```

### EmergencyWithdraw

```solidity
event EmergencyWithdraw(address user, uint256 pid, uint256 amount)
```

### SendGovernanceTokenReward

```solidity
event SendGovernanceTokenReward(address user, uint256 pid, uint256 amount, uint256 lockAmount)
```

### nonDuplicated

```solidity
modifier nonDuplicated(contract IERC20ExtendedUpgradeable _lpToken)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize(struct SimpleMasterInvestor.ConstructorParams params) public
```

### poolLength

```solidity
function poolLength() external view returns (uint256)
```

### reconfigure

```solidity
function reconfigure() public
```

### add

```solidity
function add(uint256 _allocPoint, contract IERC20ExtendedUpgradeable _lpToken, bool _withUpdate) public
```

### set

```solidity
function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public
```

### massUpdatePools

```solidity
function massUpdatePools() public
```

### updatePool

```solidity
function updatePool(uint256 _pid) public
```

### getMultiplier

```solidity
function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256)
```

### getLockPercentage

```solidity
function getLockPercentage(uint256 _from, uint256 _to) public view returns (uint256)
```

### getPoolReward

```solidity
function getPoolReward(uint256 _from, uint256 _to, uint256 _allocPoint) public view returns (uint256 forDev, uint256 forFarmer, uint256 forLP, uint256 forCom, uint256 forFounders)
```

### pendingReward

```solidity
function pendingReward(uint256 _pid, address _user) external view returns (uint256)
```

### claimRewards

```solidity
function claimRewards(uint256[] _pids) public
```

### claimReward

```solidity
function claimReward(uint256 _pid) public
```

### _harvest

```solidity
function _harvest(uint256 _pid) internal
```

### _harvestFor

```solidity
function _harvestFor(uint256 _pid, address _address) internal
```

### deposit

```solidity
function deposit(uint256 _pid, uint256 _amount) public
```

### withdraw

```solidity
function withdraw(uint256 _pid, uint256 _amount) public
```

### emergencyWithdraw

```solidity
function emergencyWithdraw(uint256 _pid) public
```

### safeGovTokenTransfer

```solidity
function safeGovTokenTransfer(address _to, uint256 _amount) internal
```

### getNewRewardPerSecond

```solidity
function getNewRewardPerSecond(uint256 pid1) public view returns (uint256)
```

### userDelta

```solidity
function userDelta(uint256 _pid) public view returns (uint256)
```

### userDeltaOf

```solidity
function userDeltaOf(uint256 _pid, address _address) public view returns (uint256)
```

### updateLastRewardTime

```solidity
function updateLastRewardTime(uint256 time) public
```

### updateHalvingAtTimes

```solidity
function updateHalvingAtTimes(uint256[] times) public
```

### updateRewardPerSecond

```solidity
function updateRewardPerSecond(uint256 reward) public
```

### updateRewardMultipliers

```solidity
function updateRewardMultipliers(uint256[] multipliers) public
```

### updateUserLockPercents

```solidity
function updateUserLockPercents(uint256[] lockPercents) public
```

### updateStartTime

```solidity
function updateStartTime(uint256 time) public
```

### updateAddress

```solidity
function updateAddress(uint256 kind, address _address) public
```

### updateLockPercent

```solidity
function updateLockPercent(uint256 kind, uint256 percent) public
```

### updateDepositFee

```solidity
function updateDepositFee(uint256 kind, uint256 fee) public
```

### updateFeeStages

```solidity
function updateFeeStages(uint256 kind, uint256[] feeStages) public
```

### reviseWithdraw

```solidity
function reviseWithdraw(uint256 _pid, address _user, uint256 _time) public
```

### reviseDeposit

```solidity
function reviseDeposit(uint256 _pid, address _user, uint256 _time) public
```

### correctWithdrawal

```solidity
function correctWithdrawal(uint256 _pid, address _user, uint256 _amount) public
```

### totalAllocPoint

```solidity
function totalAllocPoint() public view returns (uint256)
```

