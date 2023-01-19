# Solidity API

## IStandardERC1155

### mint

```solidity
function mint(address to, uint256 id, uint256 amount, bytes data) external
```

### burn

```solidity
function burn(address account, uint256 id, uint256 amount) external
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 id, uint256 amount) external view returns (bytes)
```

### bridgeContract

```solidity
function bridgeContract() external returns (address)
```

