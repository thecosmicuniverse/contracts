# Solidity API

## GameStorageUpgradeable

_Central storage contract for Cosmic Universe NFTs_

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

### PAUSER_ROLE

```solidity
bytes32 PAUSER_ROLE
```

### ValueUpdated

```solidity
event ValueUpdated(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value)
```

### TextUpdated

```solidity
event TextUpdated(address nftAddress, uint256 tokenId, uint256 customId, string value)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### updateSkill

```solidity
function updateSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) public
```

_Update a single skill to value_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| nftAddress | address | Address of the NFT collection |
| tokenId | uint256 | ID of the NFT |
| treeId | uint256 | ID of the storage tree |
| skillId | uint256 | ID of the skill |
| value | uint256 | new skill value |

### updateString

```solidity
function updateString(address nftAddress, uint256 tokenId, uint256 customId, string value) public
```

### getSkill

```solidity
function getSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId) public view returns (uint256 value)
```

_Get a single skill value_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| nftAddress | address | Address of the NFT collection |
| tokenId | uint256 | ID of the NFT |
| treeId | uint256 | ID of the storage tree |
| skillId | uint256 | ID of the skill |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| value | uint256 | skill value |

### getSkillsByTree

```solidity
function getSkillsByTree(address nftAddress, uint256 tokenId, uint256 treeId, uint256[] skillIds) public view returns (uint256[])
```

### getSkillOfTokens

```solidity
function getSkillOfTokens(address nftAddress, uint256[] tokenIds, uint256 treeId, uint256 skillId) public view returns (uint256[])
```

### getString

```solidity
function getString(address nftAddress, uint256 tokenId, uint256 customId) public view returns (string value)
```

### getStrings

```solidity
function getStrings(address nftAddress, uint256 tokenId, uint256[] customIds) public view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(address nftAddress, uint256[] tokenIds, uint256 customId) public view returns (string[])
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

