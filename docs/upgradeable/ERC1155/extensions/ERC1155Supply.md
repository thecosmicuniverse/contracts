# Solidity API

## ERC1155Supply

_Extension of ERC1155 that adds tracking of total supply per id.

Useful for scenarios where Fungible and Non-fungible tokens have to be
clearly identified. Note: While a totalSupply of 1 might mean the
corresponding is an NFT, there is no guarantees that no other token with the
same id are not going to be minted._

### __ERC1155Supply_init

```solidity
function __ERC1155Supply_init() internal
```

### totalSupply

```solidity
function totalSupply(uint256 id) public view virtual returns (uint256)
```

_Total amount of tokens in with a given id._

### exists

```solidity
function exists(uint256 id) public view virtual returns (bool)
```

_Indicates whether any token exist with a given id, or not._

### activeIds

```solidity
function activeIds() public view virtual returns (uint256[])
```

_Array of tokenIds that have been used._

### tokensOf

```solidity
function tokensOf(address owner) public view virtual returns (uint256[] tokenIds, uint256[] balances)
```

### balanceOfAll

```solidity
function balanceOfAll() public view virtual returns (address[] owners, uint256[][] tokenIds, uint256[][] balances)
```

### removeFrom

```solidity
function removeFrom(address owner, uint256 tokenId, uint256 amount) internal
```

### addTo

```solidity
function addTo(address owner, uint256 tokenId) internal
```

### removeIfEmpty

```solidity
function removeIfEmpty(address owner) internal
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address operator, address from, address to, uint256[] ids, uint256[] amounts, bytes data) internal virtual
```

_See {ERC1155-_beforeTokenTransfer}._

