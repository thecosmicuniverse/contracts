# Solidity API

## ERC721QueryHelper

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
  enum ERC721QueryHelper.SaleType saleType;
  address seller;
  address contractAddress;
  enum ERC721QueryHelper.TokenType tokenType;
  address bidToken;
  uint256 startTime;
  uint256 duration;
  uint256 extensionDuration;
  uint256 endTime;
  address bidder;
  uint256 bidAmount;
}
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### tokensOfOwner

```solidity
function tokensOfOwner(address token, address owner) public view returns (uint256[])
```

### getActiveSales

```solidity
function getActiveSales() public view returns (uint256[], struct ERC721QueryHelper.Sale[])
```

### getSalePart1

```solidity
function getSalePart1(uint256 i) internal view returns (struct ERC721QueryHelper.Sale)
```

### getSalePart2

```solidity
function getSalePart2(uint256 i) internal view returns (struct ERC721QueryHelper.Sale)
```

