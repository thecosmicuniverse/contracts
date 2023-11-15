# Solidity API

## CosmicTools

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
function mint(address to, uint256 tokenId, bytes data) public
```

### mint

```solidity
function mint(address to, bytes data) external
```

### mint

```solidity
function mint(address to, uint256 tokenId) external
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

### tokenURIJSON

```solidity
function tokenURIJSON(uint256 tokenId) public view virtual returns (string)
```

### imageURISuffix

```solidity
function imageURISuffix(uint256 tokenId) internal view returns (string)
```

### setBridgeContract

```solidity
function setBridgeContract(address _bridgeContract) external
```

### getTool

```solidity
function getTool(uint256 tokenId) public view returns (struct ICosmicTools.Tool)
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 tokenId) external view returns (bytes)
```

### nextId

```solidity
function nextId() public view returns (uint256)
```

### setMaxDurability

```solidity
function setMaxDurability(uint256 tokenId) public
```

### removeDurability

```solidity
function removeDurability(uint256 tokenId, uint256 amount) public
```

### getDurability

```solidity
function getDurability(uint256 tokenId) public view returns (uint256 current, uint256 max)
```

### maxDurability

```solidity
function maxDurability(enum SharedStructs.Rarity rarity) internal pure returns (uint256)
```

### rarityString

```solidity
function rarityString(enum SharedStructs.Rarity rarity) internal pure returns (string)
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

### setNextId

```solidity
function setNextId(uint256 id) public
```

### setImageBaseURI

```solidity
function setImageBaseURI(string _imageBaseURI) public
```

### burn

```solidity
function burn(uint256 tokenId) public
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

### teleport

```solidity
function teleport(uint256 tokenId) external
```

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

