# Solidity API

## ICards

### Status

```solidity
enum Status {
  Invalid,
  Created,
  Accepted,
  Completed,
  Closed
}
```

### Winner

```solidity
enum Winner {
  Invalid,
  Player1,
  Player2,
  Tie
}
```

### TokenConfig

```solidity
struct TokenConfig {
  address token;
  uint256 minBet;
  uint256 increment;
  uint256 enabled;
}
```

### Round

```solidity
struct Round {
  address token;
  address player1;
  address player2;
  uint256 amount;
  uint256 lastActionTime;
  uint256 player1Result;
  uint256 player2Result;
  enum ICards.Status status;
  enum ICards.Winner winner;
}
```

### TokenConfigUpdated

```solidity
event TokenConfigUpdated(address token, uint256 minBet, uint256 increment, uint256 enabled)
```

### RoundCreated

```solidity
event RoundCreated(address from, uint256 id, address token, uint256 amount)
```

### RoundAccepted

```solidity
event RoundAccepted(address from, uint256 id)
```

### RoundCompleted

```solidity
event RoundCompleted(uint256 id, enum ICards.Winner winner, uint256 player1Result, uint256 player2Result)
```

### RoundClosed

```solidity
event RoundClosed(uint256 id)
```

### InvalidBetIncrement

```solidity
error InvalidBetIncrement(uint256 increment, uint256 minBet)
```

### BetValueMismatch

```solidity
error BetValueMismatch(uint256 expected, uint256 actual)
```

### InvalidToken

```solidity
error InvalidToken(address token)
```

### InvalidRound

```solidity
error InvalidRound(uint256 id)
```

