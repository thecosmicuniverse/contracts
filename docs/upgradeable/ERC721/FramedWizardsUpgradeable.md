# Solidity API

## FramedWizardsUpgradeable

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

### setTokenURI

```solidity
function setTokenURI(uint256 token, bytes uri) public
```

### setTokenURIs

```solidity
function setTokenURIs(uint256[] tokens, bytes[] uris) public
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) public view returns (string[])
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

