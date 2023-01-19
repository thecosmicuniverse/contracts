# Solidity API

## StakingRewardsClaimAvalanche

### WIZARDS

```solidity
contract ICosmicWizards WIZARDS
```

### BUNDLES

```solidity
contract ICosmicBundles BUNDLES
```

### ChestClaimed

```solidity
event ChestClaimed(address from, uint256 tokenID, uint256 chestId)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### claim

```solidity
function claim(uint256 tokenId) public
```

### batchClaim

```solidity
function batchClaim(uint256[] tokenIds) public
```

### stakedClaim

```solidity
function stakedClaim(uint256 tokenId, address owner) public
```

### batchStakedClaim

```solidity
function batchStakedClaim(uint256[] tokenIds, address[] owners) public
```

### checkEligibility

```solidity
function checkEligibility(uint256 tokenId) public view returns (address owner, uint256 points, uint256 claimed)
```

### getTotalProfessionSkillPoints

```solidity
function getTotalProfessionSkillPoints(uint256 tokenId) internal view returns (uint256)
```

### pause

```solidity
function pause() public
```

### unpause

```solidity
function unpause() public
```

