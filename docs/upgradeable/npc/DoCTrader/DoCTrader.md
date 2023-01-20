# Solidity API

## DoCTrader

NPC contract for Item purchases and resource trading in Dawn of Crypton

### TokenType

```solidity
enum TokenType {
  ERC20,
  ERC1155,
  ERC721
}
```

### Location

```solidity
enum Location {
  Treasury,
  Burn,
  Mint,
  Local
}
```

### Token

```solidity
struct Token {
  enum DoCTrader.TokenType tokenType;
  enum DoCTrader.Location location;
  address _address;
  uint256 id;
  uint256 quantity;
}
```

### Item

```solidity
struct Item {
  struct DoCTrader.Token cost;
  struct DoCTrader.Token details;
}
```

### treasury

```solidity
address treasury
```

Cosmic Universe Treasury address

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### tradeResource

```solidity
function tradeResource(uint256 id) public
```

Trades raw or refined resources at a cost of (`weight` * 24) * (`weight` + 1)**(3 - `rarity`)
        for 1 Contribution Token

_The contract address for the resource is calculated based on `id`_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | uint256 | TokenID of the resource |

### breakdownResource

```solidity
function breakdownResource(uint256 id, uint256 quantity) public
```

Breaks down raw or refined resources at a rate of (`weight` + 1) * `quantity`
        into `rarity` - 1

_The contract address for the resource is calculated based on `id`_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | uint256 | TokenID of the resource |
| quantity | uint256 | Amount of resources to break down |

### buyItem

```solidity
function buyItem(uint256 id) public
```

Purchase an Item from the Trader defined by `id`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | uint256 | ID of the item in the Trader's shop |

### buyTool

```solidity
function buyTool(uint256 professionId) public
```

Purchase a common rarity tool for `professionId`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| professionId | uint256 | ID of the profession |

### shopItem

```solidity
function shopItem(uint256 id) public view returns (struct DoCTrader.Item item)
```

Read an item available from the Trader

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | uint256 | ID of the item in the Trader's shop |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| item | struct DoCTrader.Item | Item definition |

### shopItems

```solidity
function shopItems() public view returns (uint256[] ids, struct DoCTrader.Item[] items)
```

Read all items available from the Trader

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| ids | uint256[] | Array of item ids |
| items | struct DoCTrader.Item[] | Array of items |

### resourceWeight

```solidity
function resourceWeight(uint256 id) internal pure returns (uint256)
```

### isRefinedResourceID

```solidity
function isRefinedResourceID(uint256 id) internal pure returns (bool)
```

### setTreasury

```solidity
function setTreasury(address _treasury) external
```

Set the address of the Treasury

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _treasury | address | Treasury address |

### addShopItem

```solidity
function addShopItem(struct DoCTrader.Item _item) public
```

Add an item to the Trader's shop

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _item | struct DoCTrader.Item | Shop Item definition |

### removeShopItem

```solidity
function removeShopItem(uint256 id) public
```

Remove an item from the Trader's shop

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | uint256 | ID of the item |

### updateShopItem

```solidity
function updateShopItem(uint256 id, struct DoCTrader.Item _item) public
```

Update an item in the Trader's shop

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | uint256 | ID of the item |
| _item | struct DoCTrader.Item | Shop Item definition |

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal virtual
```

_Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
{upgradeTo} and {upgradeToAndCall}.

Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.

```solidity
function _authorizeUpgrade(address) internal override onlyOwner {}
```_

