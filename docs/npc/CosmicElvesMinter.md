# Solidity API

## CosmicElvesMinter

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

### ELVES

```solidity
contract ICosmicElves ELVES
```

### ETICKET

```solidity
contract ICosmicElvesTicket ETICKET
```

### USDC

```solidity
contract IERC20Upgradeable USDC
```

### PendingMint

```solidity
struct PendingMint {
  uint256[] ids;
  uint256 requestId;
  uint256[] words;
}
```

### startTime

```solidity
uint256 startTime
```

### cap

```solidity
uint256 cap
```

### treasury

```solidity
address treasury
```

### price

```solidity
uint256 price
```

### TEAM_ROLE

```solidity
bytes32 TEAM_ROLE
```

### gated

```solidity
modifier gated()
```

### creditsAdded

```solidity
event creditsAdded(address from, address to, uint256 amount)
```

### creditsUsed

```solidity
event creditsUsed(address from, uint256 amount)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### buy

```solidity
function buy(uint256 count, uint256[] tickets) public
```

### adminRequest

```solidity
function adminRequest(uint256 count) public
```

### adminAddRandomness

```solidity
function adminAddRandomness(address account, uint256 count) external
```

### adminForceMint

```solidity
function adminForceMint(address account, uint256 count) public
```

### mint

```solidity
function mint(uint256 count) public
```

### _mint

```solidity
function _mint(address account, uint256 count) public
```

### adminForceSpecific

```solidity
function adminForceSpecific(address account, uint256 begin, uint256 end) public
```

### _getAttributes

```solidity
function _getAttributes(uint256[] randomChunks) internal view returns (uint256[])
```

### _attributeRoll

```solidity
function _attributeRoll(uint256[] weights, uint256 roll) internal pure returns (uint256)
```

### setAttributeWeights

```solidity
function setAttributeWeights(uint256 gender, uint256 attribute, uint256[] weights) public
```

### setAttributesWeights

```solidity
function setAttributesWeights(uint256 gender, uint256[] attributes, uint256[][] weights) public
```

### setTotalElvesTickets

```solidity
function setTotalElvesTickets(uint256 total) public
```

### fulfillRandomWords

```solidity
function fulfillRandomWords(uint256 requestId, uint256[] randomWords) internal
```

fulfillRandomness handles the VRF response. Your contract must
implement it. See "SECURITY CONSIDERATIONS" above for important
principles to keep in mind when implementing your fulfillRandomness
method.

_VRFConsumerBaseV2 expects its subcontracts to have a method with this
signature, and will call it once it has verified the proof
associated with the randomness. (It is triggered via a call to
rawFulfillRandomness, below.)_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| requestId | uint256 | The Id initially returned by requestRandomness |
| randomWords | uint256[] | the VRF output expanded to the requested number of words |

### pendingMintsOf

```solidity
function pendingMintsOf(address user) public view returns (uint256[], bool)
```

### pendingData

```solidity
function pendingData(address user) public view returns (uint256[], uint256[], uint256)
```

### lastTokenId

```solidity
function lastTokenId() public view returns (uint256)
```

### creditOf

```solidity
function creditOf(address account) public view returns (uint256)
```

### addCredit

```solidity
function addCredit(address[] accounts, uint256[] amounts) external
```

### setCredit

```solidity
function setCredit(address[] accounts, uint256[] amounts) external
```

### setPrice

```solidity
function setPrice(uint256 _price) external
```

