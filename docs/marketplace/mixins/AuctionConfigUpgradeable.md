# Solidity API

## AuctionConfigUpgradeable

### EXTENSION_DURATION

```solidity
uint256 EXTENSION_DURATION
```

### _nexBidPercentBps

```solidity
uint256 _nexBidPercentBps
```

### AuctionConfigUpdated

```solidity
event AuctionConfigUpdated(uint256 nexBidPercentInBasisPoint, uint256 extensionDuration)
```

### __AuctionConfig_init

```solidity
function __AuctionConfig_init(uint256 nexBidPercentBps) internal
```

### getAuctionConfig

```solidity
function getAuctionConfig() external view returns (uint256, uint256)
```

### updateAuctionConfig

```solidity
function updateAuctionConfig(uint256 nexBidPercentBps) external
```

### _getNextBidAmount

```solidity
function _getNextBidAmount(uint256 currentBidAmount) internal view returns (uint256)
```

