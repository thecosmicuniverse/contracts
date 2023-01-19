# Solidity API

## ICosmicBundles

### mint

```solidity
function mint(address account, uint256 id, uint256 amount, bytes data) external
```

### mintBatch

```solidity
function mintBatch(address to, uint256[] ids, uint256[] amounts, bytes data) external
```

### mintBatchOf

```solidity
function mintBatchOf(uint256 id, address[] to, uint256[] amounts) external
```

### burnBatch

```solidity
function burnBatch(address from, uint256[] ids, uint256[] amounts) external
```

### uri

```solidity
function uri(uint256 tokenId) external view returns (string)
```

