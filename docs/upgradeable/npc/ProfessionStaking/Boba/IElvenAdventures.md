# Solidity API

## IElvenAdventures

### TokenType

```solidity
enum TokenType {
  ERC20,
  ERC1155,
  ERC721
}
```

### Quest

```solidity
struct Quest {
  uint256 level;
  uint256 skillId;
  uint256 completeAt;
}
```

### Reward

```solidity
struct Reward {
  address _address;
  uint256 id;
  uint256 amount;
  enum IElvenAdventures.TokenType tokenType;
}
```

### UnlockedAdventures

```solidity
event UnlockedAdventures(address from, uint256 tokenId)
```

### BeganQuest

```solidity
event BeganQuest(address from, uint256 tokenId, uint256 skillId, uint256 level, uint256 completeAt)
```

### FinishedQuest

```solidity
event FinishedQuest(address from, uint256 tokenId, uint256 skillId, uint256 level)
```

### CancelledQuest

```solidity
event CancelledQuest(address from, uint256 tokenId, uint256 skillId)
```

### BeganAdventure

```solidity
event BeganAdventure(address from, uint256 tokenId)
```

### FinishedAdventure

```solidity
event FinishedAdventure(address from, uint256 tokenId)
```

