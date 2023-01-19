# Solidity API

## MarketFeeUpgradeable

### MarketFeesUpdated

```solidity
event MarketFeesUpdated(uint256 marketFeeBps)
```

### __MarketFee_int

```solidity
function __MarketFee_int(uint256 marketFeeBps) internal
```

### getMarketFeeConfig

```solidity
function getMarketFeeConfig() external view returns (uint256)
```

### setMarketFeeConfig

```solidity
function setMarketFeeConfig(uint256 marketFeeBps) external
```

### _getFees

```solidity
function _getFees(uint256 price) internal view returns (uint256)
```

