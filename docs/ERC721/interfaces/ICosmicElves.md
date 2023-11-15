# Solidity API

## ICosmicElves

### Elf

```solidity
struct Elf {
  uint256[] base;
  uint256[] adventures;
  uint256[] professions;
}
```

### mint

```solidity
function mint(address to, uint256 tokenId) external
```

### getAllTokenIds

```solidity
function getAllTokenIds() external view returns (uint256[])
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) external view returns (string[])
```

### batchMint

```solidity
function batchMint(address to, uint256[] tokenIds) external
```

### updateSkill

```solidity
function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) external
```

### batchUpdateSkillsOfToken

```solidity
function batchUpdateSkillsOfToken(uint256 tokenId, uint256 treeId, uint256[] skillIds, uint256[] values) external
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

