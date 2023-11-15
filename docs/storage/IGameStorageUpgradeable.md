# Solidity API

## IGameStorageUpgradeable

### getSkill

```solidity
function getSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId) external view returns (uint256 value)
```

### getSkillsByTree

```solidity
function getSkillsByTree(address nftAddress, uint256 tokenId, uint256 treeId, uint256[] skillIds) external view returns (uint256[])
```

### updateSkill

```solidity
function updateSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) external
```

### getString

```solidity
function getString(address nftAddress, uint256 tokenId, uint256 customId) external view returns (string value)
```

### getStrings

```solidity
function getStrings(address nftAddress, uint256 tokenId, uint256[] customIds) external view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(address nftAddress, uint256[] tokenIds, uint256 customIds) external view returns (string[])
```

### updateString

```solidity
function updateString(address nftAddress, uint256 tokenId, uint256 customId, string value) external
```

