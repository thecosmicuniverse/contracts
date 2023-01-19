# Solidity API

## ERC1155URITokenJSON

_ERC1155 token with JSON based token URI management._

### imageBaseURI

```solidity
string imageBaseURI
```

### __ERC1155URITokenJSON_init

```solidity
function __ERC1155URITokenJSON_init(string _imageBaseUri) internal
```

### uri

```solidity
function uri(uint256 tokenIds) public view virtual returns (string)
```

### batchUri

```solidity
function batchUri(uint256[] tokenIds) public view virtual returns (string[])
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) public view virtual returns (string[])
```

### _makeBase64

```solidity
function _makeBase64(string json) internal view virtual returns (string)
```

### _makeJSON

```solidity
function _makeJSON(uint256 tokenId, string name, string description, struct CosmicStructs.Attribute[] attributes) internal view returns (string)
```

### _makeMetadata

```solidity
function _makeMetadata(uint256 tokenId, string name, string description) internal view returns (string)
```

### _makeAttributes

```solidity
function _makeAttributes(struct CosmicStructs.Attribute[] attributes) internal pure returns (string)
```

### _setImageBaseURI

```solidity
function _setImageBaseURI(string _imageBaseURI) internal virtual
```

