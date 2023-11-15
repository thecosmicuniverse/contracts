# Solidity API

## Multicall

_Provides a function to batch together multiple calls in a single external call.

_Available since v4.1.__

### __Multicall_init

```solidity
function __Multicall_init() internal
```

### __Multicall_init_unchained

```solidity
function __Multicall_init_unchained() internal
```

### multicall

```solidity
function multicall(bytes[] data) external virtual returns (bytes[] results)
```

_Receives and executes a batch of function calls on this contract._

