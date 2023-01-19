# Solidity API

## CosmicElves

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

### mint

```solidity
function mint(address to, uint256 tokenId) public
```

### batchMint

```solidity
function batchMint(address to, uint256[] tokenIds) public
```

### tokenURIJSON

```solidity
function tokenURIJSON(uint256 tokenId) public view virtual returns (string)
```

### mint

```solidity
function mint(address to, uint256 tokenId, bytes data) public
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 tokenId) external view returns (bytes)
```

### pause

```solidity
function pause() public
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     updateSkill and transferFrom functions_

### unpause

```solidity
function unpause() public
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     the upgrade2DWizards and transferFrom functions_

### setImageBaseURI

```solidity
function setImageBaseURI(string _imageBaseURI) public
```

### setBridgeContract

```solidity
function setBridgeContract(address _bridgeContract) public
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view returns (string)
```

### burn

```solidity
function burn(uint256 tokenId) public virtual
```

### _burn

```solidity
function _burn(uint256 tokenId) internal virtual
```

_Destroys `tokenId`.
The approval is cleared when the token is burned.
This is an internal function that does not check if the sender is authorized to operate on the token.

Requirements:

- `tokenId` must exist.

Emits a {Transfer} event._

### _exists

```solidity
function _exists(uint256 tokenId) internal view virtual returns (bool)
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

