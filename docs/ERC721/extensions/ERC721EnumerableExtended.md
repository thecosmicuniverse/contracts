# Solidity API

## ERC721EnumerableExtended

_This implements an optional extension of {ERC721} defined in the EIP that adds
enumerability of all the token ids in the contract as well as all token ids owned by each
account._

### __ERC721EnumerableExtended_init

```solidity
function __ERC721EnumerableExtended_init() internal
```

### __ERC721EnumerableExtended_init_unchained

```solidity
function __ERC721EnumerableExtended_init_unchained() internal
```

### batchTransferFrom

```solidity
function batchTransferFrom(address from, address to, uint256[] tokenIds) public virtual
```

### tokensOfOwner

```solidity
function tokensOfOwner(address owner) public view virtual returns (uint256[])
```

### getAllTokenIds

```solidity
function getAllTokenIds() public view returns (uint256[])
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual
```

