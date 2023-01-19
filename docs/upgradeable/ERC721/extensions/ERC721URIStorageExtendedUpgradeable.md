# Solidity API

## ERC721URIStorageExtendedUpgradeable

_ERC721 token with storage based token URI management._

### imageBaseURI

```solidity
string imageBaseURI
```

### __ERC721URIStorageExtended_init

```solidity
function __ERC721URIStorageExtended_init() internal
```

### __ERC721URIStorageExtended_init_unchained

```solidity
function __ERC721URIStorageExtended_init_unchained() internal
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

_See {IERC721Metadata-tokenURI}._

### _setImageBaseURI

```solidity
function _setImageBaseURI(string _imageBaseURI) internal virtual
```

### _setTokenURI

```solidity
function _setTokenURI(uint256 tokenId, bytes _tokenURI) internal virtual
```

### _presetTokenURI

```solidity
function _presetTokenURI(uint256 tokenId, bytes _tokenURI) internal virtual
```

### _burn

```solidity
function _burn(uint256 tokenId) internal virtual
```

_Destroys `tokenId`.
The approval is cleared when the token is burned.
This is an internal function that does not check if the sender is authorized to operate on the token.

Requirements:

- `tokenId` must exist.

Emits a {Transfer} event._

