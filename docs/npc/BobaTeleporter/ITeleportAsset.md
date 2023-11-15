# Solidity API

## ITeleportAsset

### teleport

```solidity
function teleport(uint256 tokenId) external
```

### teleport

```solidity
function teleport(address wallet, uint256 amount) external
```

### teleport

```solidity
function teleport(address wallet, uint256 id, uint256 amount) external
```

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

### tokensOfOwner

```solidity
function tokensOfOwner(address owner) external view returns (uint256[])
```

### balanceOf

```solidity
function balanceOf(address account, uint256 id) external view returns (uint256)
```

### tokenOfOwnerByIndex

```solidity
function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId)
```

### mint

```solidity
function mint(address account, uint256 amount, bytes) external
```

### mint

```solidity
function mint(address account, uint256 id, uint256 amount, bytes data) external
```

### mint

```solidity
function mint(address account, uint256 tokenId) external
```

