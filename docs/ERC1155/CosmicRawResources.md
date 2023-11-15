# Solidity API

## CosmicRawResources

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
function mint(address account, uint256 id, uint256 amount, bytes data) public
```

### mintBatch

```solidity
function mintBatch(address to, uint256[] ids, uint256[] amounts, bytes data) external
```

### mintBatchOf

```solidity
function mintBatchOf(uint256 id, address[] to, uint256[] amounts) external
```

### burnBatch

```solidity
function burnBatch(address from, uint256[] ids, uint256[] amounts) public
```

### teleport

```solidity
function teleport(address wallet, uint256 id, uint256 amount) external
```

### uri

```solidity
function uri(uint256 tokenId) public view returns (string)
```

### setImageBaseURI

```solidity
function setImageBaseURI(string _imageBaseURI) external
```

### pause

```solidity
function pause() public
```

### unpause

```solidity
function unpause() public
```

### setBridgeContract

```solidity
function setBridgeContract(address _bridgeContract) public
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 id, uint256 amount) external view returns (bytes)
```

### burn

```solidity
function burn(address account, uint256 id, uint256 amount) public
```

### adminBurn

```solidity
function adminBurn(address account, uint256 id, uint256 amount) external
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address operator, address from, address to, uint256[] ids, uint256[] amounts, bytes data) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

