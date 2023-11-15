# Solidity API

## ICosmicAttributeStorage

### updateSkill

```solidity
function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) external
```

### updateString

```solidity
function updateString(uint256 tokenId, uint256 customId, string value) external
```

### getSkill

```solidity
function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) external view returns (uint256 value)
```

### getSkillsByTree

```solidity
function getSkillsByTree(uint256 tokenId, uint256 treeId, uint256[] skillIds) external view returns (uint256[])
```

### getString

```solidity
function getString(uint256 tokenId, uint256 customId) external view returns (string value)
```

### getStrings

```solidity
function getStrings(uint256 tokenId, uint256[] customIds) external view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(uint256[] tokenIds, uint256 customId) external view returns (string[])
```

