# Solidity API

## IMarket

### SaleType

```solidity
enum SaleType {
  AUCTION,
  FIXED,
  OFFER
}
```

### TokenType

```solidity
enum TokenType {
  ERC721,
  ERC1155
}
```

### Sale

```solidity
struct Sale {
  enum IMarket.SaleType saleType;
  address seller;
  address contractAddress;
  enum IMarket.TokenType tokenType;
  uint256[] tokenIds;
  uint256[] values;
  address bidToken;
  uint256 startTime;
  uint256 duration;
  uint256 extensionDuration;
  uint256 endTime;
  address bidder;
  uint256 bidAmount;
}
```

### saleIdToSale

```solidity
function saleIdToSale(uint256) external view returns (struct IMarket.Sale)
```

