# Solidity API

## lMagicUpgradeable

### onlyWhitelist

```solidity
modifier onlyWhitelist(address from, address to)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### pause

```solidity
function pause() public
```

### unpause

```solidity
function unpause() public
```

### mint

```solidity
function mint(address _address, uint256 amount) public
```

### burn

```solidity
function burn(uint256 amount) public virtual
```

_Destroys `amount` tokens from the caller.

See {ERC20-_burn}._

### burnFrom

```solidity
function burnFrom(address account, uint256 amount) public virtual
```

_Destroys `amount` tokens from `account`, deducting from the caller's
allowance.

See {ERC20-_burn} and {ERC20-allowance}.

Requirements:

- the caller must have allowance for ``accounts``'s tokens of at least
`amount`._

### claimPending

```solidity
function claimPending() public
```

### pendingOf

```solidity
function pendingOf(address _address) public view returns (uint256)
```

### totalOf

```solidity
function totalOf(address _address) public view returns (uint256)
```

### addGlobalWhitelist

```solidity
function addGlobalWhitelist(address to) public
```

### addWhitelist

```solidity
function addWhitelist(address from, address to) public
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal
```

_Hook that is called before any transfer of tokens. This includes
minting and burning.

Calling conditions:

- when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
will be transferred to `to`.
- when `from` is zero, `amount` tokens will be minted for `to`.
- when `to` is zero, `amount` of ``from``'s tokens will be burned.
- `from` and `to` are never both zero.

To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks]._

