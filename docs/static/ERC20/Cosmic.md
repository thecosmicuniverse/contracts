# Solidity API

## Cosmic

### totalUpgraded

```solidity
uint256 totalUpgraded
```

### totalBurned

```solidity
uint256 totalBurned
```

### constructor

```solidity
constructor() public
```

### leftToUpgrade

```solidity
function leftToUpgrade() external view virtual returns (uint256)
```

Get the amount of CosmicCoin left in circulation

_Convenience proxy function to get the remaining balance of
     CosmicCoin, represented as an 18 decimal token_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | balance of CosmicCoin represented as an 18 decimal token |

### upgradeAll

```solidity
function upgradeAll() external
```

Upgrade all CosmicCoin to Cosmic

_Gets the entire balance of the calling wallet's old CosmicCoin and
     transfers it to the predefined burn address. It then converts the
     9 decimal balance to an 18 decimal balance, mints it as Cosmic,
     and then stores the balance for convenience calling._

### missingBurn

```solidity
function missingBurn() public view virtual returns (uint256)
```

Check for burn discrepancy

_Checks to see if cosmic v1 has been burned through a means
     other than upgrade_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | amount available to burn |

### burnSync

```solidity
function burnSync() public returns (uint256)
```

_Burns Cosmic to match CosmicCoin_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | amount burned |

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

### convert9to18

```solidity
function convert9to18(uint256 amount) internal pure returns (uint256)
```

_Convenience function to convert a 9 decimal value into
     an 18 decimal value_

### burn

```solidity
function burn(uint256 amount) public virtual
```

Burn Cosmic, destroying it permanently

_Destroys the `amount` of tokens sent by the caller and
     adds that amount to the balance of totalBurned_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | Quantity of Cosmic to burn |

### burnFrom

```solidity
function burnFrom(address account, uint256 amount) public virtual
```

Burn Cosmic from an address, destroying it permanently

_Destroys the `amount` of tokens set by the caller from
     `account` and adds that amount to the balance of
     totalBurned. The caller must have an allowance for the
     `account`_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | Address to burn Cosmic from |
| amount | uint256 | Quantity of Cosmic to burn |

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

