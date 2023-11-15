# Solidity API

## BobaTeleportL2

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### MAGIC

```solidity
address MAGIC
```

### ELVES

```solidity
address ELVES
```

### TOOLS

```solidity
address TOOLS
```

### COMPONENTS

```solidity
address COMPONENTS
```

### POTIONS

```solidity
address POTIONS
```

### RAW_RESOURCES

```solidity
address RAW_RESOURCES
```

### REFINED_RESOURCES

```solidity
address REFINED_RESOURCES
```

### SKINS

```solidity
address SKINS
```

### BUNDLES

```solidity
address BUNDLES
```

### BADGES

```solidity
address BADGES
```

### AssetTeleported

```solidity
event AssetTeleported(address wallet, address token, uint256 id, uint256 amounts)
```

### NoAssetToTeleport

```solidity
error NoAssetToTeleport()
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

Initializes the contract with necessary initial setup

The initializer function is a replacement for a constructor in upgradeable contracts.
This function can only be called once and is responsible for setting up contract's initial state.

The function performs the following operations:
  - Initializes the Pausable, StandardAccessControl, UUPSUpgradeable, and ReentrancyGuard contracts.
  - Grants DEFAULT_ADMIN_ROLE and ADMIN_ROLE roles to the address deploying the contract.
  - Initializes the ChainlinkVRFConsumer contract with a Chainlink Coordinator address,
    VRF key hash, subscription ID, and the number of confirmations for processing a VRF request.

_This function uses initializer modifier from OpenZeppelin's Initializable contract to ensure
it can only be called once when deploying the contract

The caller of this function should be the one who has the power to pause, upgrade,
or perform administrative tasks_

### teleportNFTsAndMagic

```solidity
function teleportNFTsAndMagic() external
```

### teleportTokens

```solidity
function teleportTokens() external
```

### teleportResources

```solidity
function teleportResources() external
```

### adminTeleportNFTsAndMagic

```solidity
function adminTeleportNFTsAndMagic(address wallet) external
```

### adminTeleportTokens

```solidity
function adminTeleportTokens(address wallet) external
```

### adminTeleportResources

```solidity
function adminTeleportResources(address wallet) external
```

### _teleportNFTsAndMagic

```solidity
function _teleportNFTsAndMagic(address wallet) internal returns (uint256)
```

### _teleportTokens

```solidity
function _teleportTokens(address wallet) internal returns (uint256)
```

### _teleportResources

```solidity
function _teleportResources(address wallet) internal returns (uint256)
```

### isRefinedResourceID

```solidity
function isRefinedResourceID(uint256 id) internal pure returns (bool)
```

### pause

```solidity
function pause() public
```

### unpause

```solidity
function unpause() public
```

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal
```

Internal function to authorize an upgrade to a new smart contract implementation

This function allows an address with DEFAULT_ADMIN_ROLE to authorize a new
implementation of the smart contract. Upon successful authorization,
the proxied contract will point to the new implementation, and all
subsequent function calls will be delegated to the new implementation.

_This function can only be called internally and requires DEFAULT_ADMIN_ROLE.
The function overrides the implementation provided by OpenZeppelin's UUPS (Universal
Upgradeable Proxy Standard) upgradeable contract library._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newImplementation | address | Address of the new contract implementation to which the current contract should be upgraded. |

