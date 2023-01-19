# Solidity API

## IStandardERC721

### mint

```solidity
function mint(address to, uint256 tokenId, bytes data) external
```

### burn

```solidity
function burn(uint256 tokenId) external
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 tokenId) external view returns (bytes)
```

### bridgeContract

```solidity
function bridgeContract() external returns (address)
```

