# Solidity API

## MarketCoreUpgradeable

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
  enum MarketCoreUpgradeable.SaleType saleType;
  address seller;
  address contractAddress;
  enum MarketCoreUpgradeable.TokenType tokenType;
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
mapping(uint256 => struct MarketCoreUpgradeable.Sale) saleIdToSale
```

### SaleCreated

```solidity
event SaleCreated(uint256 saleId, enum MarketCoreUpgradeable.SaleType saleType, address seller, address contractAddress, uint256[] tokenIds, uint256[] values, address bidToken, uint256 startTime, uint256 duration, uint256 extensionDuration, uint256 endTime, uint256 minPrice)
```

### SaleCanceled

```solidity
event SaleCanceled(uint256 saleId, string reason)
```

### BidPlaced

```solidity
event BidPlaced(uint256 saleId, address bidder, uint256 bidAbount, uint256 endTime)
```

### AuctionFinalized

```solidity
event AuctionFinalized(uint256 saleId, address seller, address bidder, uint256 royalty, uint256 marketFee, uint256 ownerRev)
```

### FixedPriceFinalized

```solidity
event FixedPriceFinalized(uint256 saleId, address seller, address buyer, uint256 royalty, uint256 marketFee, uint256 ownerRev)
```

### OfferFinalized

```solidity
event OfferFinalized(uint256 saleId, address seller, address buyer, uint256 royalty, uint256 marketFee, uint256 ownerRev)
```

### __MarketCore_init

```solidity
function __MarketCore_init(uint256 maxRoyaltyBps, uint256 marketFeeBps, address treasury, uint256 nexBidPercentBps) internal
```

### _makeSaleInfo

```solidity
function _makeSaleInfo(enum MarketCoreUpgradeable.SaleType saleType, address contractAddress, enum MarketCoreUpgradeable.TokenType tokenType, uint256[] tokenIds, uint256[] values, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice) internal view returns (struct MarketCoreUpgradeable.Sale)
```

### _createSale

```solidity
function _createSale(struct MarketCoreUpgradeable.Sale sale, uint256 royaltyBps) internal
```

### cancelSale

```solidity
function cancelSale(uint256 saleId, string reason) external
```

### cancelSaleByAdmin

```solidity
function cancelSaleByAdmin(uint256 saleId, string reason) external
```

### getAuctionMinBidAmount

```solidity
function getAuctionMinBidAmount(uint256 saleId) external view returns (uint256)
```

### bidAuction

```solidity
function bidAuction(uint256 saleId, uint256 bidAmount) external
```

### finalizeAuction

```solidity
function finalizeAuction(uint256 saleId) external
```

### buyFixedPrice

```solidity
function buyFixedPrice(uint256 saleId, uint256 buyAmount) external
```

### _makeOfferInfo

```solidity
function _makeOfferInfo(address contractAddress, enum MarketCoreUpgradeable.TokenType tokenType, uint256[] tokenIds, uint256[] values, address bidToken, uint256 duration, uint256 price) internal view returns (struct MarketCoreUpgradeable.Sale)
```

### _createOffer

```solidity
function _createOffer(struct MarketCoreUpgradeable.Sale sale) internal
```

### cancelOffer

```solidity
function cancelOffer(uint256 saleId) external
```

### acceptOffer

```solidity
function acceptOffer(uint256 saleId) external
```

### activeSaleIds

```solidity
function activeSaleIds() public view returns (uint256[])
```

### activeSales

```solidity
function activeSales() public view returns (struct MarketCoreUpgradeable.Sale[])
```

