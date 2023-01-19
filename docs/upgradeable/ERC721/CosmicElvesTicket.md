# Solidity API

## CosmicElvesTicket

### PendingMint

```solidity
struct PendingMint {
  uint256[] ids;
  uint256 requestId;
  uint256[] words;
}
```

### treasury

```solidity
address treasury
```

### price

```solidity
uint256 price
```

### cap

```solidity
uint256 cap
```

### imageBaseURI

```solidity
string imageBaseURI
```

### notBlacklisted

```solidity
modifier notBlacklisted(address _address)
```

### notFinished

```solidity
modifier notFinished()
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### mint

```solidity
function mint(uint256 count) public
```

### mint

```solidity
function mint(address to, uint256 id) public
```

### batchMint

```solidity
function batchMint(address to, uint256[] ids) public
```

### reveal

```solidity
function reveal() public
```

### partialReveal

```solidity
function partialReveal(uint256 count) public
```

### _partialRevealFor

```solidity
function _partialRevealFor(address _address, uint256 count) internal
```

### partialRevealFor

```solidity
function partialRevealFor(address _address, uint256 count) public
```

### discountOf

```solidity
function discountOf(uint256 tokenId) public view returns (uint256 discount)
```

### batchDiscountOf

```solidity
function batchDiscountOf(uint256[] tokenIds) public view returns (uint256[])
```

### tokensAndDiscountsOfOwner

```solidity
function tokensAndDiscountsOfOwner(address _address) public view returns (uint256[] tokens, uint256[] discounts)
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

_See {IERC721Metadata-tokenURI}._

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) public view returns (string[])
```

### oddsOf

```solidity
function oddsOf(uint256 chance) internal pure returns (string)
```

### lastTokenId

```solidity
function lastTokenId() public view returns (uint256)
```

### revealsPendingOf

```solidity
function revealsPendingOf(address _address) public view returns (uint256[], bool)
```

### adminCheckPendingMintDataOf

```solidity
function adminCheckPendingMintDataOf(address _address) public view returns (struct CosmicElvesTicket.PendingMint)
```

### adminGetNewRandomnessFor

```solidity
function adminGetNewRandomnessFor(address _address) public
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

### setTicketPrice

```solidity
function setTicketPrice(uint256 _price) public
```

### setCap

```solidity
function setCap(uint256 _cap) public
```

### addBlacklist

```solidity
function addBlacklist(address _address) public
```

### removeBlacklist

```solidity
function removeBlacklist(address _address) public
```

### setImageBaseURI

```solidity
function setImageBaseURI(string _imageBaseURI) public
```

### setDiscountsOf

```solidity
function setDiscountsOf(uint256[] tokenIds, uint256[] discounts) public
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

### _exists

```solidity
function _exists(uint256 tokenId) internal view virtual returns (bool)
```

### approve

```solidity
function approve(address to, uint256 tokenId) public virtual
```

### setApprovalForAll

```solidity
function setApprovalForAll(address operator, bool approved) public virtual
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

