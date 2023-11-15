# Solidity API

## ERC20BurnableUpgradeable

_Extension of {ERC20} that allows token holders to destroy both their own
tokens and those that they have an allowance for, in a way that can be
recognized off-chain (via event analysis)._

### __ERC20Burnable_init

```solidity
function __ERC20Burnable_init() internal
```

### __ERC20Burnable_init_unchained

```solidity
function __ERC20Burnable_init_unchained() internal
```

### totalBurned

```solidity
function totalBurned() public view virtual returns (uint256)
```

### burn

```solidity
function burn(uint256 amount) public virtual
```

_Destroys `amount` tokens from the caller.

See {ERC20-_burn}._

### unBurn

```solidity
function unBurn(uint256 amount) internal virtual
```

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

