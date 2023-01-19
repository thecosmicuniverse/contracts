# Solidity API

## CosmicIslandLand

### Region

```solidity
enum Region {
  Road,
  Water,
  ElysianFields,
  EnchantedForest,
  MysticAlpines,
  ForestOfWhimsy
}
```

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

CosmicAttributeStorage

### bridgeContract

```solidity
address bridgeContract
```

### ValueUpdated

```solidity
event ValueUpdated(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value)
```

### TextUpdated

```solidity
event TextUpdated(uint256 tokenId, uint256 customId, string value)
```

### notBlacklisted

```solidity
modifier notBlacklisted(address _address)
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

### mint

```solidity
function mint(address to, uint256 tokenId, bytes data) public
```

### pause

```solidity
function pause() public
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     the upgrade2DWizards and transferFrom functions_

### unpause

```solidity
function unpause() public
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     the upgrade2DWizards and transferFrom functions_

### updateSkill

```solidity
function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) public
```

### updateString

```solidity
function updateString(uint256 tokenId, uint256 customId, string value) public
```

### getSkill

```solidity
function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) public view returns (uint256 value)
```

### getSkillsByTree

```solidity
function getSkillsByTree(uint256 tokenId, uint256 treeId, uint256[] skillIds) public view returns (uint256[])
```

### getString

```solidity
function getString(uint256 tokenId, uint256 customId) public view returns (string value)
```

### getStrings

```solidity
function getStrings(uint256 tokenId, uint256[] customIds) public view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(uint256[] tokenIds, uint256 customId) public view returns (string[])
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) public view returns (string[])
```

### tokenURIJSON

```solidity
function tokenURIJSON(uint256 tokenId) public view virtual returns (string)
```

### batchTokenURIJSON

```solidity
function batchTokenURIJSON(uint256[] tokenIds) public view returns (string[])
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 tokenId) external view returns (bytes)
```

### setTokenURI

```solidity
function setTokenURI(uint256 tokenId, uint256 attrId, uint256 value) public
```

### setTokenURIs

```solidity
function setTokenURIs(uint256[] tokenIds, uint256[] attrIds, uint256[] values) public
```

### setImageBaseURI

```solidity
function setImageBaseURI(string _imageBaseURI) public
```

### burn

```solidity
function burn(uint256 tokenId) public virtual
```

### _burn

```solidity
function _burn(uint256 tokenId) internal virtual
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

