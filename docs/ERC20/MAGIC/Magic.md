# Solidity API

## Magic

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

### _mint

```solidity
function _mint(address account, uint256 amount) internal virtual
```

_Required override for _mint because both ERC20Capped and
ERC20 have the same function, so the derived contract must
override it_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | Address of the account to send Cosmic to |
| amount | uint256 | Quantity of Cosmic to mint |

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

### bridgeExtraData

```solidity
function bridgeExtraData() external pure returns (bytes)
```

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

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

