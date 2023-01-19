# Solidity API

## TestWizards2D

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### MINTER_ROLE

```solidity
bytes32 MINTER_ROLE
```

### ComicWizardDetail

```solidity
struct ComicWizardDetail {
  uint256 first_encounter;
}
```

### TokenMinted

```solidity
event TokenMinted(uint256 tokenId, address owner, uint256 first_encounter)
```

### PROVENANCE

```solidity
string PROVENANCE
```

### MAX_PURCHASE

```solidity
uint256 MAX_PURCHASE
```

### MAX_TOKENS

```solidity
uint256 MAX_TOKENS
```

### CURRENT_PRICE

```solidity
uint256 CURRENT_PRICE
```

### saleIsActive

```solidity
bool saleIsActive
```

### constructor

```solidity
constructor() public
```

Contract constructor

### withdraw

```solidity
function withdraw() public
```

With

### reserveTokens

```solidity
function reserveTokens() public
```

Reserve tokens

### mintTokenId

```solidity
function mintTokenId(uint256 tokenId) public
```

Mint a specific token.

### setProvenanceHash

```solidity
function setProvenanceHash(string provenanceHash) public
```

### setMaxTokens

```solidity
function setMaxTokens(uint256 maxTokens) public
```

### setSaleState

```solidity
function setSaleState(bool newState) public
```

### mintComicWizard

```solidity
function mintComicWizard(uint256 numberOfTokens) public payable
```

Mint ComicWizard World

### setBaseURI

```solidity
function setBaseURI(string BaseURI) public
```

_Changes the base URI if we want to move things in the future (Callable by owner only)_

### _baseURI

```solidity
function _baseURI() internal view virtual returns (string)
```

_Base URI for computing {tokenURI}. Empty by default, can be overriden
in child contracts._

### setCurrentPrice

```solidity
function setCurrentPrice(uint256 currentPrice) public
```

Set the current token price

### getComicWizardDetail

```solidity
function getComicWizardDetail(uint256 tokenId) public view returns (struct TestWizards2D.ComicWizardDetail detail)
```

Get the token detail

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

