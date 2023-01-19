# Solidity API

## ERC1155Soulbound

_Contract to lock items to wallets_

### SOULBOUND_WHITELIST_ROLE

```solidity
bytes32 SOULBOUND_WHITELIST_ROLE
```

### notSoulbound

```solidity
modifier notSoulbound(uint256[] tokenIds, address from, address to)
```

### __ERC1155Soulbound_init

```solidity
function __ERC1155Soulbound_init() internal
```

### setSoulbound

```solidity
function setSoulbound(uint256 tokenId) public
```

### unsetSoulbound

```solidity
function unsetSoulbound(uint256 tokenId) public
```

### isSoulbound

```solidity
function isSoulbound(uint256 tokenId) public view returns (bool)
```

