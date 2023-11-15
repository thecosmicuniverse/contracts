# Solidity API

## ERC721BurnableExtendedUpgradeable

_This implements an optional extension of {ERC721} defined in the EIP that adds
enumerability of all the token ids in the contract as well as all token ids owned by each
account._

### __ERC721BurnableExtended_init

```solidity
function __ERC721BurnableExtended_init() internal
```

### __ERC721BurnableExtended_init_unchained

```solidity
function __ERC721BurnableExtended_init_unchained() internal
```

### burn

```solidity
function burn(uint256 tokenId) public virtual
```

_Burns `tokenId`. See {ERC721-_burn}.

Requirements:

- The caller must own `tokenId` or be an approved operator._

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

_See {IERC165-supportsInterface}._

### _removeBurnedId

```solidity
function _removeBurnedId(uint256 tokenId) internal virtual
```

### _exists

```solidity
function _exists(uint256 tokenId) internal view virtual returns (bool)
```

_Returns whether `tokenId` exists.

Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.

Tokens start existing when they are minted (`_mint`),
and stop existing when they are burned (`_burn`)._

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual
```

_Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.

Calling conditions:

- When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
- When `from` is zero, the tokens will be minted for `to`.
- When `to` is zero, ``from``'s tokens will be burned.
- `from` and `to` are never both zero.
- `batchSize` is non-zero.

To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks]._

