# Solidity API

## MarketRoyaltyUpgradeable

### RoyaltyInfo

```solidity
struct RoyaltyInfo {
  address recipient;
  uint256 amount;
}
```

### royalties

```solidity
mapping(address => mapping(uint256 => struct MarketRoyaltyUpgradeable.RoyaltyInfo)) royalties
```

### MarketRoyaltyUpdated

```solidity
event MarketRoyaltyUpdated(uint256 maxRoyaltiyBps)
```

### __MarketRoyalty_int

```solidity
function __MarketRoyalty_int(uint256 maxRoyaltyBps) internal
```

### getMarketRoyaltyConfig

```solidity
function getMarketRoyaltyConfig() external view returns (uint256)
```

### setMarketRoyaltyConfig

```solidity
function setMarketRoyaltyConfig(uint256 maxRoyaltyBps) external
```

### setRoyaltyFor

```solidity
function setRoyaltyFor(address from, address contractAddress, uint256 tokenId, uint256 royaltyBps) internal
```

### _getRoyalty

```solidity
function _getRoyalty(address contractAddress, uint256 tokenId, uint256 price) internal view returns (address, uint256)
```

