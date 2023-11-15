# Solidity API

## BobaTeleportL1

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

### materialized

```solidity
mapping(address => mapping(address => mapping(uint256 => uint256))) materialized
```

### MAGIC_L2

```solidity
address MAGIC_L2
```

### ELVES_L2

```solidity
address ELVES_L2
```

### TOOLS_L2

```solidity
address TOOLS_L2
```

### COMPONENTS_L2

```solidity
address COMPONENTS_L2
```

### POTIONS_L2

```solidity
address POTIONS_L2
```

### RAW_RESOURCES_L2

```solidity
address RAW_RESOURCES_L2
```

### REFINED_RESOURCES_L2

```solidity
address REFINED_RESOURCES_L2
```

### SKINS_L2

```solidity
address SKINS_L2
```

### BUNDLES_L2

```solidity
address BUNDLES_L2
```

### BADGES_L2

```solidity
address BADGES_L2
```

### AssetMaterialized

```solidity
event AssetMaterialized(address wallet, address token, uint256 id, uint256 amount)
```

### NoAssetToMaterialize

```solidity
error NoAssetToMaterialize()
```

### InvalidAssetToMaterialize

```solidity
error InvalidAssetToMaterialize(address wallet, address token, uint256 id, uint256 balance)
```

### InsufficientTeleportFee

```solidity
error InsufficientTeleportFee(uint256 sent, uint256 need)
```

### ArrayLengthMismatch

```solidity
error ArrayLengthMismatch(uint256 array1, uint256 array2, uint256 array3)
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

### materializeNFTsAndMagic

```solidity
function materializeNFTsAndMagic(uint256[] elvesIds, uint256[] toolsIds) external payable
```

### materializeTokens

```solidity
function materializeTokens() external payable
```

### materializeResources

```solidity
function materializeResources(uint256[] ids) external payable
```

### adminMaterializeNFTsAndMagic

```solidity
function adminMaterializeNFTsAndMagic(address wallet, uint256[] elvesIds, uint256[] toolsIds) external
```

### adminMaterializeTokens

```solidity
function adminMaterializeTokens(address wallet) external
```

### adminMaterializeResources

```solidity
function adminMaterializeResources(address wallet, uint256[] ids) external
```

### _materializeNFTsAndMagic

```solidity
function _materializeNFTsAndMagic(address wallet, uint256[] elvesIds, uint256[] toolsIds) internal returns (uint256)
```

### _materializeTokens

```solidity
function _materializeTokens(address wallet) internal returns (uint256)
```

### _materializeResources

```solidity
function _materializeResources(address wallet, uint256[] ids) internal returns (uint256)
```

### _checkTeleportFee

```solidity
function _checkTeleportFee(address wallet) internal
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

### addTeleportedAssets

```solidity
function addTeleportedAssets(address wallet, address[] assets, uint256[] ids, uint256[] amounts, uint256 fee) external
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

