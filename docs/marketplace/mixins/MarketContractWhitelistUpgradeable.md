# Solidity API

## MarketContractWhitelistUpgradeable

### contractAddressToBidToken

```solidity
mapping(address => address) contractAddressToBidToken
```

### ContractBidTokenUpdated

```solidity
event ContractBidTokenUpdated(address contractAddress, address bidToken)
```

### __MarketContractWhitelist_init

```solidity
function __MarketContractWhitelist_init() internal
```

### setContractBidToken

```solidity
function setContractBidToken(address contractAddress, address bidTokenAddress) external
```

### getContractBidToken

```solidity
function getContractBidToken(address contractAddress) external view returns (address)
```

### removeContractBidToken

```solidity
function removeContractBidToken(address contractAddress) external
```

### isValidBidToken

```solidity
function isValidBidToken(address contractAddress, address bidTokenAddress) internal view returns (bool)
```

