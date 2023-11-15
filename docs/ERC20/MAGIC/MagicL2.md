# Solidity API

## MagicL2

### bridgeContract

```solidity
address bridgeContract
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
function pause() external
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     upgradeAll and transferFrom functions_

### unpause

```solidity
function unpause() external
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     upgradeAll and transferFrom functions_

### mint

```solidity
function mint(address account, uint256 amount) public
```

### mint

```solidity
function mint(address account, uint256 amount, bytes) public
```

### burn

```solidity
function burn(uint256 amount) public virtual
```

_Destroys `amount` tokens from the caller.

See {ERC20-_burn}._

### burn

```solidity
function burn(address to, uint256 amount) public virtual
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

### teleport

```solidity
function teleport(address wallet, uint256 amount) external
```

### bridgeExtraData

```solidity
function bridgeExtraData() external pure returns (bytes)
```

Overrides

### setBridgeContract

```solidity
function setBridgeContract(address _address) external
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal
```

_Required override for _beforeTokenTransfer because both
ERC20Pausable and ERC20 have the same function, so the derived
contract must override it_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | Address of the sender |
| to | address | Address of the recipient |
| amount | uint256 | Amount of Cosmic to transfer |

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal
```

_Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
{upgradeTo} and {upgradeToAndCall}.

Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.

```solidity
function _authorizeUpgrade(address) internal override onlyOwner {}
```_

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

