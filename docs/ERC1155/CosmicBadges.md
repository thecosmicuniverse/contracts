# Solidity API

## CosmicBadges

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

### pause

```solidity
function pause() public
```

### unpause

```solidity
function unpause() public
```

### mint

```solidity
function mint(address account, uint256 id, uint256 amount, bytes data) public
```

### mintBatch

```solidity
function mintBatch(address to, uint256[] ids, uint256[] amounts, bytes data) public
```

### mintBatchOf

```solidity
function mintBatchOf(uint256 id, address[] to, uint256[] amounts) public
```

### burnBatch

```solidity
function burnBatch(address from, uint256[] ids, uint256[] amounts) public
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 id, uint256 amount) external view returns (bytes)
```

### uri

```solidity
function uri(uint256 tokenId) public view virtual returns (string)
```

### setBridgeContract

```solidity
function setBridgeContract(address _bridgeContract) public
```

### burn

```solidity
function burn(address account, uint256 id, uint256 amount) public
```

### teleport

```solidity
function teleport(address wallet, uint256 id, uint256 amount) external
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address operator, address from, address to, uint256[] ids, uint256[] amounts, bytes data) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

