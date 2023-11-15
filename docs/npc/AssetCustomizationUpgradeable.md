# Solidity API

## AssetCustomizationUpgradeable

### UPDATER_ROLE

```solidity
bytes32 UPDATER_ROLE
```

### nameChangeCost

```solidity
uint256 nameChangeCost
```

### treasury

```solidity
address treasury
```

### onlyOwnerOf

```solidity
modifier onlyOwnerOf(address nftAddress, uint256 tokenId)
```

### onlyEnabled

```solidity
modifier onlyEnabled(address nftAddress)
```

### NameChanged

```solidity
event NameChanged(address from, address nftAddress, uint256 tokenId, string name)
```

### NameReset

```solidity
event NameReset(address from, address nftAddress, uint256 tokenId)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### setNameOf

```solidity
function setNameOf(address nftAddress, uint256 tokenId, string name) public
```

PUBLIC

### resetNameOf

```solidity
function resetNameOf(address nftAddress, uint256 tokenId) public
```

### nameOf

```solidity
function nameOf(address nftAddress, uint256 tokenId) public view returns (string)
```

### namesOf

```solidity
function namesOf(address nftAddress, uint256[] tokenIds) public view returns (string[])
```

### enableAsset

```solidity
function enableAsset(address nftAddress) public
```

Admin

### disableAsset

```solidity
function disableAsset(address nftAddress) public
```

### setFee

```solidity
function setFee(contract IERC20Upgradeable token, uint256 fee) public
```

### setTreasury

```solidity
function setTreasury(address _address) public
```

### setGameStorage

```solidity
function setGameStorage(contract IGameStorageUpgradeable _address) public
```

### pause

```solidity
function pause() public
```

_Pause contract write functions_

### unpause

```solidity
function unpause() public
```

_Unpause contract write functions_

