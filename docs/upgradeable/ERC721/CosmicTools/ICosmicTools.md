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

