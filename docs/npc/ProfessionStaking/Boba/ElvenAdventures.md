# Solidity API

## ElvenAdventures

### onAdventure

```solidity
modifier onAdventure(uint256 tokenId)
```

### notOnAdventure

```solidity
modifier notOnAdventure(uint256 tokenId)
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

### unlockAdventures

```solidity
function unlockAdventures(uint256 tokenId) public
```

### batchUnlockAdventures

```solidity
function batchUnlockAdventures(uint256[] tokenIds) external
```

### beginAdventure

```solidity
function beginAdventure(uint256 tokenId) public
```

### batchBeginAdventure

```solidity
function batchBeginAdventure(uint256[] tokenIds) external
```

### finishAdventure

```solidity
function finishAdventure(uint256 tokenId) public
```

### batchFinishAdventure

```solidity
function batchFinishAdventure(uint256[] tokenIds) external
```

### _startQuest

```solidity
function _startQuest(uint256 tokenId, uint256 skillId, bool leveling) internal
```

### startQuest

```solidity
function startQuest(uint256 tokenId, uint256 skillId) public
```

### batchStartQuest

```solidity
function batchStartQuest(uint256[] tokenIds) external
```

_Start a quest for multiple tokenIds at once. If any tokenId is not currently leveling(e.g. their
     profession level is in the range of 1-19) it will revert._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenIds | uint256[] | Array of tokenIds |

### finishQuest

```solidity
function finishQuest(uint256 tokenId) public
```

### batchFinishQuest

```solidity
function batchFinishQuest(uint256[] tokenIds) external
```

### abandonQuest

```solidity
function abandonQuest(uint256 tokenId) public
```

### batchAbandonQuest

```solidity
function batchAbandonQuest(uint256[] tokenIds) external
```

### sendReward

```solidity
function sendReward(uint256 level, uint256 skillId) internal
```

### isRefResID

```solidity
function isRefResID(uint256 rewardId) internal pure returns (bool)
```

### isValidSkill

```solidity
function isValidSkill(uint256 tokenId, uint256 skillId) internal view returns (bool)
```

### setQuestTime

```solidity
function setQuestTime(uint256 level, uint256 time) public
```

### batchSetQuestTime

```solidity
function batchSetQuestTime(uint256[] levels, uint256[] time) public
```

### setRewards

```solidity
function setRewards(uint256[] levels, struct IElvenAdventures.Reward[] rewards) external
```

### setRewardAddressFor

```solidity
function setRewardAddressFor(uint256 level, address _address) public
```

### setLateInit

```solidity
function setLateInit() external
```

### getQuest

```solidity
function getQuest(uint256 tokenId) public view returns (struct IElvenAdventures.Quest)
```

### getQuests

```solidity
function getQuests(uint256[] tokenIds) external view returns (struct IElvenAdventures.Quest[])
```

### getQuestsArray

```solidity
function getQuestsArray(uint256[] tokenIds) external view returns (uint256[], uint256[] levels, uint256[] skillIds, uint256[] completeAts)
```

### getAllowedSkillChoices

```solidity
function getAllowedSkillChoices(uint256 tokenId) public view returns (uint256[])
```

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal
```

_Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
{upgradeTo} and {upgradeToAndCall}.

Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.

```solidity
function _authorizeUpgrade(address) internal override onlyOwner {}
```_

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

