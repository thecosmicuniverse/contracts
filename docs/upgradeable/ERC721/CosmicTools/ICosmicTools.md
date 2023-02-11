# Solidity API

## ICosmicTools

### Tool

```solidity
struct Tool {
  uint256 skillId;
  uint256 durability;
  enum SharedStructs.Rarity rarity;
}
```

### mint

```solidity
function mint(address to, bytes data) external
```

### setMaxDurability

```solidity
function setMaxDurability(uint256 tokenId) external
```

### getDurability

```solidity
function getDurability(uint256 tokenId) external view returns (uint256 current, uint256 max)
```

