# Solidity API

## TokenMetadata

### TokenType

```solidity
enum TokenType {
  ERC20,
  ERC1155,
  ERC721
}
```

### Attribute

```solidity
struct Attribute {
  string name;
  string displayType;
  string value;
  bool isNumber;
}
```

### toBase64

```solidity
function toBase64(string json) internal pure returns (string)
```

### makeMetadataJSON

```solidity
function makeMetadataJSON(uint256 tokenId, address owner, string name, string imageURI, string description, enum TokenMetadata.TokenType tokenType, struct TokenMetadata.Attribute[] attributes) internal pure returns (string)
```

### makeMetadataString

```solidity
function makeMetadataString(uint256 tokenId, address owner, string name, string imageURI, string description, enum TokenMetadata.TokenType tokenType) internal pure returns (string)
```

### toJSONString

```solidity
function toJSONString(struct TokenMetadata.Attribute[] attributes) internal pure returns (string)
```

### toString

```solidity
function toString(enum TokenMetadata.TokenType tokenType) internal pure returns (string)
```

### makeContractURI

```solidity
function makeContractURI(string name, string description, string imageURL, string externalLinkURL, uint256 sellerFeeBasisPoints, address feeRecipient) internal pure returns (string)
```

