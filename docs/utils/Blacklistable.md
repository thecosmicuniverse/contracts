# Solidity API

## Blacklistable

### notBlacklisted

```solidity
modifier notBlacklisted(address user)
```

### __Blacklistable_init

```solidity
function __Blacklistable_init() internal
```

### _addBlacklisted

```solidity
function _addBlacklisted(address user) internal virtual
```

### _removeBlacklisted

```solidity
function _removeBlacklisted(address user) internal virtual
```

### isBlacklisted

```solidity
function isBlacklisted(address user) public view virtual returns (bool)
```

### getBlacklisted

```solidity
function getBlacklisted() public view virtual returns (address[])
```

