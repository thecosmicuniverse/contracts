# Solidity API

## CosmicAttributeStorageUpgradeable

_Central storage contract for Cosmic Universe NFTs_

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

### ValueUpdated

```solidity
event ValueUpdated(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value)
```

### TextUpdated

```solidity
event TextUpdated(uint256 tokenId, uint256 customId, string value)
```

### __CosmicAttributeStorage_init

```solidity
function __CosmicAttributeStorage_init() internal
```

### __CosmicAttributeStorage_init_unchained

```solidity
function __CosmicAttributeStorage_init_unchained() internal
```

### updateSkill

```solidity
function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) public
```

_Update a single skill to value_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | ID of the NFT |
| treeId | uint256 | ID of the storage tree |
| skillId | uint256 | ID of the skill |
| value | uint256 | new skill value |

### batchUpdateSkills

```solidity
function batchUpdateSkills(uint256[] tokenIds, uint256[] treeIds, uint256[] skillIds, uint256[] values) public
```

### batchUpdateSkillsOfToken

```solidity
function batchUpdateSkillsOfToken(uint256 tokenId, uint256 treeId, uint256[] skillIds, uint256[] values) public
```

### updateString

```solidity
function updateString(uint256 tokenId, uint256 customId, string value) public
```

### setSkillName

```solidity
function setSkillName(uint256 treeId, uint256 skillId, string name) public
```

### batchSetSkillName

```solidity
function batchSetSkillName(uint256 treeId, uint256[] skillIds, string[] names) public
```

### getSkill

```solidity
function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) public view returns (uint256)
```

_Get a single skill value_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | ID of the NFT |
| treeId | uint256 | ID of the storage tree |
| skillId | uint256 | ID of the skill |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | value skill value |

### getSkillsByTree

```solidity
function getSkillsByTree(uint256 tokenId, uint256 treeId, uint256[] skillIds) public view returns (uint256[])
```

### getString

```solidity
function getString(uint256 tokenId, uint256 customId) public view returns (string)
```

### getStrings

```solidity
function getStrings(uint256 tokenId, uint256[] customIds) public view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(uint256[] tokenIds, uint256 customId) public view returns (string[])
```

### getSkillName

```solidity
function getSkillName(uint256 treeId, uint256 skillId) public view returns (string)
```

