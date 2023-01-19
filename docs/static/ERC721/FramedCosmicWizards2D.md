# Solidity API

## FramedCosmicWizards2D

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### PAUSER_ROLE

```solidity
bytes32 PAUSER_ROLE
```

### METADATA_ROLE

```solidity
bytes32 METADATA_ROLE
```

### MINTER_ROLE

```solidity
bytes32 MINTER_ROLE
```

### burned

```solidity
uint256[] burned
```

### burnable

```solidity
uint256 burnable
```

### whenBurnable

```solidity
modifier whenBurnable()
```

### constructor

```solidity
constructor() public
```

### safeMint

```solidity
function safeMint(address _address, uint256 tokenId) external
```

Mints a Framed Cosmic Wizard 2D

### burn

```solidity
function burn(uint256 tokenId) public virtual
```

Burn a token, destroying it permanently

_Destroys the tokenId sent by the caller and
     adds it to the array of burned tokenIds_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | ID of the token to burn |

### setBaseURI

```solidity
function setBaseURI(string baseURI) public
```

Set the BaseURI of all tokens

_Sets the base URI used by all tokens to prefix
     their tokenURI_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| baseURI | string | URI prefix of a tokenURI |

### setTokenURI

```solidity
function setTokenURI(uint256 tokenId, string _tokenURI) public
```

Set the TokenURI of a single token

_Sets the the TokenURI suffix of a single token_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | ID of the token to set |
| _tokenURI | string | URI to set |

### pause

```solidity
function pause() public
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     the safeMint and transferFrom functions_

### unpause

```solidity
function unpause() public
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     the safeMint and transferFrom functions_

### setBurnable

```solidity
function setBurnable(uint256 state) external
```

Set the ability to burn tokens

_Sets the burnable state of tokens, with 0 being false
     and 1 being true_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| state | uint256 | Burnable state |

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
```

### _burn

```solidity
function _burn(uint256 tokenId) internal
```

### _baseURI

```solidity
function _baseURI() internal view returns (string)
```

_Base URI for computing {tokenURI}. If set, the resulting URI for each
token will be the concatenation of the `baseURI` and the `tokenId`. Empty
by default, can be overridden in child contracts._

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view returns (string)
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

