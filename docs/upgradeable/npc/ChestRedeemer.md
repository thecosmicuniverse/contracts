# Solidity API

## ChestRedeemer

### Resource

```solidity
struct Resource {
  uint256 firstId;
  uint256 min;
  uint256 max;
}
```

### ResourceConfig

```solidity
struct ResourceConfig {
  address _address;
  struct ChestRedeemer.Resource a;
  struct ChestRedeemer.Resource b;
  struct ChestRedeemer.Resource c;
}
```

### bundles

```solidity
address bundles
```

### tools

```solidity
address tools
```

### rawResources

```solidity
address rawResources
```

### refinedResources

```solidity
address refinedResources
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### redeem

```solidity
function redeem(uint256 id) external payable
```

### reRollToolRarity

```solidity
function reRollToolRarity(uint256 tokenId) public
```

### rollVipPass

```solidity
function rollVipPass(uint256 rand, bool mythical) internal
```

### rollPet

```solidity
function rollPet(uint256 rand) internal
```

### rollRune

```solidity
function rollRune(uint256 rand, bool mythical) internal
```

### rollTool

```solidity
function rollTool(uint256 rand1, uint256 rand2, bool mythical) internal
```

### rollResources

```solidity
function rollResources(uint256[] randomChunks, bool mythical) internal
```

### rollResource

```solidity
function rollResource(uint256 skillId, struct ChestRedeemer.Resource r, uint256 rand1, uint256 rand2, bool mythical) internal
```

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal virtual
```

_Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
{upgradeTo} and {upgradeToAndCall}.

Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.

```solidity
function _authorizeUpgrade(address) internal override onlyOwner {}
```_

### setResourcesConfig

```solidity
function setResourcesConfig(uint256[] skillIds, struct ChestRedeemer.ResourceConfig[] configs) external
```

### resourcesConfig

```solidity
function resourcesConfig() external view returns (struct ChestRedeemer.ResourceConfig[] config)
```

### addReRollEligibleIds

```solidity
function addReRollEligibleIds(uint256[] tokenIds) external
```

