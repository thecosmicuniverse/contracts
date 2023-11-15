# Solidity API

## Cards

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### nextRoundId

```solidity
uint256 nextRoundId
```

### rounds

```solidity
mapping(uint256 => struct ICards.Round) rounds
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

Initializes the contract with necessary initial setup

The initializer function is a replacement for a constructor in upgradeable contracts.
This function can only be called once and is responsible for setting up contract's initial state.

The function performs the following operations:
  - Initializes the Pausable, StandardAccessControl, UUPSUpgradeable, and ReentrancyGuard contracts.
  - Grants DEFAULT_ADMIN_ROLE and ADMIN_ROLE roles to the address deploying the contract.
  - Initializes the ChainlinkVRFConsumer contract with a Chainlink Coordinator address,
    VRF key hash, subscription ID, and the number of confirmations for processing a VRF request.

_This function uses initializer modifier from OpenZeppelin's Initializable contract to ensure
it can only be called once when deploying the contract

The caller of this function should be the one who has the power to pause, upgrade,
or perform administrative tasks_

### createRound

```solidity
function createRound(uint256 amount, address token) external payable
```

Creates a new round for the game with a specified betting amount and token

This function creates a round with an initial bet from the calling player.
The round is created for a specific token and the bet amount should adhere to the configured rules
for the token (e.g. minimum bet, bet increment).
The bet is then taken from the player's balance.
The function also emits an event indicating a round has been created.

_The function must not be called when the contract is paused and must not be
part of a re-entrant contract call chain._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | The betting amount for the round (must be greater or equal to the minimum bet and a multiple of the increment defined for the token). |
| token | address | The address of the token for which this round is being created. emit RoundCreated This event is emitted with the address of the player who created the round, the ID of the new round, the token address, and the bet amount. |

### acceptRound

```solidity
function acceptRound(uint256 id) external payable
```

Accepts an existing round by placing a bet of the same amount as the creator of the round

This function allows a player to accept an existing round by placing a bet of the same amount as
the initial player. The round status is then updated to "Accepted", and the calling address is
marked as the second player. A random number request is also made to Chainlink VRF for future
result determination. An event is emitted upon successful round acceptance.

_This function must not be called when the contract is paused and must not
be part of a reentrant contract call chain.
The round status must be "Created" to be accepted; otherwise, it will revert with an "InvalidRound" error._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | uint256 | The identifier of the round that the player wishes to accept emit RoundAccepted This event is emitted with the address of the accepting player and the ID of the round being accepted. |

### closeRound

```solidity
function closeRound(uint256 id) external
```

Accepts an existing round by placing a bet of the same amount as the creator of the round

This function allows a player to accept an existing round by placing a bet of the same amount as
the initial player. The round status is then updated to "Accepted", and the calling address is
marked as the second player. A random number request is also made to Chainlink VRF for future
result determination. An event is emitted upon successful round acceptance.

_This function must not be called when the contract is paused and must not
be part of a reentrant contract call chain.
The round status must be "Created" to be accepted; otherwise, it will revert with an "InvalidRound" error._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | uint256 | The identifier of the round that the player wishes to accept emit RoundAccepted This event is emitted with the address of the accepting player and the ID of the round being accepted. |

### _completeRound

```solidity
function _completeRound(uint256 id, uint256 rand) internal
```

Completes an accepted round and determines the winner based on the generated random number.

This internal function completes an accepted round by changing the round status to "Completed",
it then generates the players' results from the random number and determines who the winner is.
The winner is determined based on the highest resulting card (determined by the remainder of the playerResult by 13).
If the resulting cards are the same, it is a tie. Once the round is completed and
the winner determined, an event is emitted.

_The function can only be called internally.
The round status must be "Accepted" to be completed; otherwise, it will revert with an "InvalidRound" error._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | uint256 | The identifier of the round that the function will complete |
| rand | uint256 | The random number used to determine the results and the winner emit RoundCompleted This event is emitted with the ID of the completed round, the winner, and the results of both players. |

### fulfillRandomWords

```solidity
function fulfillRandomWords(uint256 requestId, uint256[] randomWords) internal
```

Handle the returned random number from a Chainlink VRF oracle, and complete the round associated with the request ID

This internal function is called by the Chainlink VRF when a random number is ready.
It fetches the round associated with the request ID and completes it using the first random word returned by the oracle.

_This function must only be called by the Chainlink VRF
In the context of the Chainlink VRF, this function should ideally complete execution within the gas limit of the transaction
that calls it; otherwise, the function will revert, and the oracle transaction will fail.
The function cannot be called externally; it overrides the implementation provided by the Chainlink VRF_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| requestId | uint256 | The identifier of the request for which the random words were generated |
| randomWords | uint256[] | An array that contains the random words generated by Chainlink VRF |

### _takeBet

```solidity
function _takeBet(uint256 amount, address token) internal
```

Internal function for handling incoming bets in the form of native ETH or ERC20 tokens

This function accepts a bet and credits the locked amount for the token.
The function checks if the message value is less than the expected amount when dealing with native ETH
and revert if it is so. When dealing with ERC20 tokens, the function uses the `transferFrom` method
to pull the tokens from the sender to this contract.

_This function must only be called internally.
The function requires the caller of the function (the bettor) to have approved
enough tokens for the contract to withdraw if the bet is in ERC20 tokens._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | The amount of the bet that the function should handle |
| token | address | The address of the token in which the bet is made. Should be the zero address for native ETH |

### _sendPlayerWinnings

```solidity
function _sendPlayerWinnings(uint256 amount, address token, address player) internal
```

An internal function to send winnings to players in the form of either native ETH or ERC20 tokens.

This function sends the winning amount to the winning player. In the case of native ETH,
the function sends ETH directly to the player using `transfer`.
For ERC20 tokens, the function uses the `transfer` method of the ERC20 token to send the winnings to the player.

_This function should only be called internally.
The function requires enough balance of the betting token in the contract to process the transfer._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | The amount of winnings that should be sent to the player. |
| token | address | The address of the token in which the winnings are to be sent. Should be the zero address for native ETH. |
| player | address | The address of the winning player. |

### setSupportedTokenConfig

```solidity
function setSupportedTokenConfig(struct ICards.TokenConfig config) external
```

Updates the betting configuration for a given token

This function allows an administrator to set a new configuration for a supported token.
The configuration includes properties like minimum bet, bet increment, and token status.
An event is emitted after a successful update of the token configuration.

_Only an address with the ADMIN_ROLE can call this function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| config | struct ICards.TokenConfig | A structure containing the new token configuration. It should include the token address, minimum bet, bet increment, and a boolean to enable or disable the token. emit TokenConfigUpdated This event is emitted with the address of the updated token, the new minimum bet, the new bet increment, and the new status. |

### sweepFees

```solidity
function sweepFees(address[] tokens) external
```

Extracts the fee accrued by the contract in the form of both native ETH and ERC20 tokens

This function transfers the accumulated balance of the specified tokens (fees)
in the contract that is not locked in bets to the caller.
The function first handles ETH and then iterates over the supplied tokens array to transfer any ERC20 token fees.

_The function could only be called by an address with the ADMIN_ROLE.
If the balance of a token or of ETH is zero or only consists of locked funds, the transfer is skipped.
The function should have enough gas limit to process all token transfers, as excessive gas consumption
could cause the function to fail halfway, leaving the contract in a potentially inconsistent state._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokens | address[] | An array of all token addresses for which the function should sweep the fees. |

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal
```

Internal function to authorize an upgrade to a new smart contract implementation

This function allows an address with DEFAULT_ADMIN_ROLE to authorize a new
implementation of the smart contract. Upon successful authorization,
the proxied contract will point to the new implementation, and all
subsequent function calls will be delegated to the new implementation.

_This function can only be called internally and requires DEFAULT_ADMIN_ROLE.
The function overrides the implementation provided by OpenZeppelin's UUPS (Universal
Upgradeable Proxy Standard) upgradeable contract library._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newImplementation | address | Address of the new contract implementation to which the current contract should be upgraded. |

