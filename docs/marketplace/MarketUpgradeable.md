# Solidity API

## MarketUpgradeable

### initialize

```solidity
function initialize(uint256 maxRoyaltyBps, uint256 marketFeeBps, address treasury, uint256 nexBidPercentBps) external
```

### createERC721Auction

```solidity
function createERC721Auction(address contractAddress, uint256 tokenId, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice, uint256 royaltyBps) external
```

### createERC1155Auction

```solidity
function createERC1155Auction(address contractAddress, uint256 tokenId, uint256 value, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice) external
```

### createERC721FixedPrice

```solidity
function createERC721FixedPrice(address contractAddress, uint256 tokenId, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice, uint256 royaltyBps) external
```

### createERC1155FixedPrice

```solidity
function createERC1155FixedPrice(address contractAddress, uint256 tokenId, uint256 value, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice) external
```

### createERC1155BundleAuction

```solidity
function createERC1155BundleAuction(address contractAddress, uint256[] tokenIds, uint256[] values, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice) external
```

### createERC1155BundleFixedPrice

```solidity
function createERC1155BundleFixedPrice(address contractAddress, uint256[] tokenIds, uint256[] values, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice) external
```

### createERC721Offer

```solidity
function createERC721Offer(address contractAddress, uint256 tokenId, address bidToken, uint256 duration, uint256 minPrice) external
```

