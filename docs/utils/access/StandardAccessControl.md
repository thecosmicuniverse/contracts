# Solidity API

## StandardAccessControl

### __StandardAccessControl_init

```solidity
function __StandardAccessControl_init() internal
```

### onlyDefaultAdmin

```solidity
modifier onlyDefaultAdmin()
```

### onlyAdmin

```solidity
modifier onlyAdmin()
```

### onlyContract

```solidity
modifier onlyContract()
```

### onlyMinter

```solidity
modifier onlyMinter()
```

### onlyPrivate

```solidity
modifier onlyPrivate()
```

### onlyBridge

```solidity
modifier onlyBridge()
```

### _hasDefaultAdminRole

```solidity
function _hasDefaultAdminRole(address _address) internal view returns (bool)
```

### _hasAdminRole

```solidity
function _hasAdminRole(address _address) internal view returns (bool)
```

### _hasContractRole

```solidity
function _hasContractRole(address _address) internal view returns (bool)
```

### _hasMinterRole

```solidity
function _hasMinterRole(address _address) internal view returns (bool)
```

### _hasPrivateRole

```solidity
function _hasPrivateRole(address _address) internal view returns (bool)
```

### _hasBridgeRole

```solidity
function _hasBridgeRole(address _address) internal view returns (bool)
```

### _checkRoles

```solidity
function _checkRoles(bytes32[] roles) internal view virtual
```

### _checkRoles

```solidity
function _checkRoles(bytes32[] roles, address account) internal view virtual
```

