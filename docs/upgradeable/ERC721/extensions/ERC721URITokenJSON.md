# Solidity API

## ERC721URITokenJSON

_ERC721 token with storage based token URI management._

### imageBaseURI

```solidity
string imageBaseURI
```

### __ERC721URITokenJSON_init

```solidity
function __ERC721URITokenJSON_init() internal
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

_See {IERC721Metadata-tokenURI}._

### tokenURIJSON

```solidity
function tokenURIJSON(uint256 tokenId) public view virtual returns (string)
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) public view virtual returns (string[])
```

### batchTokenURIJSON

```solidity
function batchTokenURIJSON(uint256[] tokenIds) public view virtual returns (string[])
```

### makeMetadataJSON

```solidity
function makeMetadataJSON(uint256 tokenId, string name, string description, struct TokenMetadata.Attribute[] attributes) internal view virtual returns (string)
```

### imageURISuffix

```solidity
function imageURISuffix(uint256 tokenId) internal view virtual returns (string)
```

