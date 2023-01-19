# Solidity API

## ChainlinkVRFConsumerUpgradeable

### _confirmations

```solidity
uint16 _confirmations
```

### __ChainlinkVRFConsumer_init

```solidity
function __ChainlinkVRFConsumer_init(address coordinator, bytes32 keyHash, uint64 subscriptionId, uint16 confirmations) internal
```

### __ChainlinkVRFConsumer_init_unchained

```solidity
function __ChainlinkVRFConsumer_init_unchained(address coordinator, bytes32 keyHash, uint64 subscriptionId, uint16 confirmations) internal
```

### requestRandomWords

```solidity
function requestRandomWords(uint32 count) internal returns (uint256 requestId)
```

### fulfillRandomWords

```solidity
function fulfillRandomWords(uint256 requestId, uint256[] randomWords) internal virtual
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

### chunkWord

```solidity
function chunkWord(uint256 word, uint256 modulus, uint256 chunkCount) internal pure returns (uint256[])
```

