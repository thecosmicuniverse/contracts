# Solidity API

## ERC1155AttributeStorage

_Central storage contract for Cosmic Universe NFTs_

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

### ValueUpdated

```solidity
event ValueUpdated(uint256 tokenId, uint256 attributeId, uint256 value)
```

### ValuesUpdated

```solidity
event ValuesUpdated(uint256 tokenId, uint256[] attributeIds, uint256[] values)
```

### NameUpdated

```solidity
event NameUpdated(uint256 tokenId, uint256 attributeId, string name)
```

### NamesUpdated

```solidity
event NamesUpdated(uint256 tokenId, uint256[] attributeIds, string[] names)
```

### __ERC1155AttributeStorage_init

```solidity
function __ERC1155AttributeStorage_init() internal
```

### setAttribute

```solidity
function setAttribute(uint256 tokenId, uint256 attributeId, uint256 value) public
```

### batchSetAttribute

```solidity
function batchSetAttribute(uint256 tokenId, uint256[] attributeIds, uint256[] values) public
```

### getAttribute

```solidity
function getAttribute(uint256 tokenId, uint256 attributeId) public view returns (uint256)
```

### batchGetAttribute

```solidity
function batchGetAttribute(uint256 tokenId, uint256[] attributeIds) public view returns (uint256[])
```

### getAllAttributes

```solidity
function getAllAttributes(uint256 tokenId) internal view returns (uint256[], uint256[], string[])
```

### getAttributeName

```solidity
function getAttributeName(uint256 tokenId, uint256 attributeId) internal view returns (string)
```

### batchGetAttributeName

```solidity
function batchGetAttributeName(uint256 tokenId, uint256[] attributeIds) internal view returns (string[])
```

### setAttributeName

```solidity
function setAttributeName(uint256 tokenId, uint256 attributeId, string name) public
```

### batchSetAttributeName

```solidity
function batchSetAttributeName(uint256 tokenId, uint256[] attributeIds, string[] names) public
```

### batchSetAttributeNames

```solidity
function batchSetAttributeNames(uint256[] tokenIds, uint256[] attributeIds, string[] names) public
```

