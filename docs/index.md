# Solidity API

## ICosmicTools

### Tool

```solidity
struct Tool {
  uint256 skillId;
  uint256 durability;
  enum SharedStructs.Rarity rarity;
}
```

### mint

```solidity
function mint(address to, bytes data) external
```

## IStandardERC721

### mint

```solidity
function mint(address to, uint256 tokenId, bytes data) external
```

### burn

```solidity
function burn(uint256 tokenId) external
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 tokenId) external view returns (bytes)
```

### bridgeContract

```solidity
function bridgeContract() external returns (address)
```

## SharedStructs

### Rarity

```solidity
enum Rarity {
  Common,
  Uncommon,
  Rare,
  Mythical,
  Legendary
}
```

### Profession

```solidity
enum Profession {
  Alchemy,
  Architecture,
  Carpentry,
  Cooking,
  CrystalExtraction,
  Farming,
  Fishing,
  GemCutting,
  Herbalism,
  Mining,
  Tailoring,
  Woodcutting
}
```

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

Breaks down raw or refined resources at a rate of (`weight` + 1)**(4 - `rarity`) * `quantity`
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

## CosmicAddressBookBobaAvax

### MAGIC

```solidity
function MAGIC() internal pure returns (address)
```

### Components

```solidity
function Components() internal pure returns (address)
```

### Potions

```solidity
function Potions() internal pure returns (address)
```

### RawResources

```solidity
function RawResources() internal pure returns (address)
```

### RefinedResources

```solidity
function RefinedResources() internal pure returns (address)
```

### Skins

```solidity
function Skins() internal pure returns (address)
```

### Badges

```solidity
function Badges() internal pure returns (address)
```

### Bundles

```solidity
function Bundles() internal pure returns (address)
```

### Elves

```solidity
function Elves() internal pure returns (address)
```

### Wizards

```solidity
function Wizards() internal pure returns (address)
```

### Tools

```solidity
function Tools() internal pure returns (address)
```

### CosmicIslandLand

```solidity
function CosmicIslandLand() internal pure returns (address)
```

### ChestRedeemer

```solidity
function ChestRedeemer() internal pure returns (address)
```

### ElvenAdventures

```solidity
function ElvenAdventures() internal pure returns (address)
```

## Multicall

_Provides a function to batch together multiple calls in a single external call.

_Available since v4.1.__

### __Multicall_init

```solidity
function __Multicall_init() internal
```

### __Multicall_init_unchained

```solidity
function __Multicall_init_unchained() internal
```

### multicall

```solidity
function multicall(bytes[] data) external virtual returns (bytes[] results)
```

_Receives and executes a batch of function calls on this contract._

## ERC1155

### initialize

```solidity
function initialize() public
```

### batchMint

```solidity
function batchMint(uint256[] ids, uint256[] amounts) public
```

## ERC20

### initialize

```solidity
function initialize() public
```

### mint

```solidity
function mint(uint256 amount) public
```

## ERC721

### initialize

```solidity
function initialize() public
```

### _baseURI

```solidity
function _baseURI() internal view virtual returns (string)
```

_Base URI for computing {tokenURI}. If set, the resulting URI for each
token will be the concatenation of the `baseURI` and the `tokenId`. Empty
by default, can be overridden in child contracts._

### baseURI

```solidity
function baseURI() public view returns (string)
```

### setBaseURI

```solidity
function setBaseURI(string URI) public
```

### mint

```solidity
function mint(uint256 tokenId) public
```

## MarketUpgradeable

### initialize

```solidity
function initialize(uint256 maxRoyaltyBps, uint256 marketFeeBps, address treasury, uint256 nexBidPercentBps) external
```

### createERC721Auction

```solidity
function createERC721Auction(address contractAddress, uint256 tokenId, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice, uint256 royaltyBps) external
```

### createERC1155Auction

```solidity
function createERC1155Auction(address contractAddress, uint256 tokenId, uint256 value, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice) external
```

### createERC721FixedPrice

```solidity
function createERC721FixedPrice(address contractAddress, uint256 tokenId, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice, uint256 royaltyBps) external
```

### createERC1155FixedPrice

```solidity
function createERC1155FixedPrice(address contractAddress, uint256 tokenId, uint256 value, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice) external
```

### createERC1155BundleAuction

```solidity
function createERC1155BundleAuction(address contractAddress, uint256[] tokenIds, uint256[] values, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice) external
```

### createERC1155BundleFixedPrice

```solidity
function createERC1155BundleFixedPrice(address contractAddress, uint256[] tokenIds, uint256[] values, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice) external
```

### createERC721Offer

```solidity
function createERC721Offer(address contractAddress, uint256 tokenId, address bidToken, uint256 duration, uint256 minPrice) external
```

## TreasuryUpgradeable

### initialize

```solidity
function initialize() public
```

### withdraw

```solidity
function withdraw(address tokenAddress, uint256 balance) public
```

## ArrayCheckUpgradeable

### checkgte

```solidity
function checkgte(uint256[] array, uint256 num) internal pure returns (bool)
```

## AuctionConfigUpgradeable

### EXTENSION_DURATION

```solidity
uint256 EXTENSION_DURATION
```

### _nexBidPercentBps

```solidity
uint256 _nexBidPercentBps
```

### AuctionConfigUpdated

```solidity
event AuctionConfigUpdated(uint256 nexBidPercentInBasisPoint, uint256 extensionDuration)
```

### __AuctionConfig_init

```solidity
function __AuctionConfig_init(uint256 nexBidPercentBps) internal
```

### getAuctionConfig

```solidity
function getAuctionConfig() external view returns (uint256, uint256)
```

### updateAuctionConfig

```solidity
function updateAuctionConfig(uint256 nexBidPercentBps) external
```

### _getNextBidAmount

```solidity
function _getNextBidAmount(uint256 currentBidAmount) internal view returns (uint256)
```

## Constants

### BASIS_POINTS

```solidity
uint256 BASIS_POINTS
```

### MAX_BPS

```solidity
uint256 MAX_BPS
```

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### AUTHORIZED_ROLE

```solidity
bytes32 AUTHORIZED_ROLE
```

## IMarket

### SaleType

```solidity
enum SaleType {
  AUCTION,
  FIXED,
  OFFER
}
```

### TokenType

```solidity
enum TokenType {
  ERC721,
  ERC1155
}
```

### Sale

```solidity
struct Sale {
  enum IMarket.SaleType saleType;
  address seller;
  address contractAddress;
  enum IMarket.TokenType tokenType;
  uint256[] tokenIds;
  uint256[] values;
  address bidToken;
  uint256 startTime;
  uint256 duration;
  uint256 extensionDuration;
  uint256 endTime;
  address bidder;
  uint256 bidAmount;
}
```

### saleIdToSale

```solidity
function saleIdToSale(uint256) external view returns (struct IMarket.Sale)
```

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

## MarketCoreUpgradeable

### SaleType

```solidity
enum SaleType {
  AUCTION,
  FIXED,
  OFFER
}
```

### TokenType

```solidity
enum TokenType {
  ERC721,
  ERC1155
}
```

### Sale

```solidity
struct Sale {
  enum MarketCoreUpgradeable.SaleType saleType;
  address seller;
  address contractAddress;
  enum MarketCoreUpgradeable.TokenType tokenType;
  uint256[] tokenIds;
  uint256[] values;
  address bidToken;
  uint256 startTime;
  uint256 duration;
  uint256 extensionDuration;
  uint256 endTime;
  address bidder;
  uint256 bidAmount;
}
```

### saleIdToSale

```solidity
mapping(uint256 => struct MarketCoreUpgradeable.Sale) saleIdToSale
```

### SaleCreated

```solidity
event SaleCreated(uint256 saleId, enum MarketCoreUpgradeable.SaleType saleType, address seller, address contractAddress, uint256[] tokenIds, uint256[] values, address bidToken, uint256 startTime, uint256 duration, uint256 extensionDuration, uint256 endTime, uint256 minPrice)
```

### SaleCanceled

```solidity
event SaleCanceled(uint256 saleId, string reason)
```

### BidPlaced

```solidity
event BidPlaced(uint256 saleId, address bidder, uint256 bidAbount, uint256 endTime)
```

### AuctionFinalized

```solidity
event AuctionFinalized(uint256 saleId, address seller, address bidder, uint256 royalty, uint256 marketFee, uint256 ownerRev)
```

### FixedPriceFinalized

```solidity
event FixedPriceFinalized(uint256 saleId, address seller, address buyer, uint256 royalty, uint256 marketFee, uint256 ownerRev)
```

### OfferFinalized

```solidity
event OfferFinalized(uint256 saleId, address seller, address buyer, uint256 royalty, uint256 marketFee, uint256 ownerRev)
```

### __MarketCore_init

```solidity
function __MarketCore_init(uint256 maxRoyaltyBps, uint256 marketFeeBps, address treasury, uint256 nexBidPercentBps) internal
```

### _makeSaleInfo

```solidity
function _makeSaleInfo(enum MarketCoreUpgradeable.SaleType saleType, address contractAddress, enum MarketCoreUpgradeable.TokenType tokenType, uint256[] tokenIds, uint256[] values, address bidToken, uint256 startTime, uint256 duration, uint256 minPrice) internal view returns (struct MarketCoreUpgradeable.Sale)
```

### _createSale

```solidity
function _createSale(struct MarketCoreUpgradeable.Sale sale, uint256 royaltyBps) internal
```

### cancelSale

```solidity
function cancelSale(uint256 saleId, string reason) external
```

### cancelSaleByAdmin

```solidity
function cancelSaleByAdmin(uint256 saleId, string reason) external
```

### getAuctionMinBidAmount

```solidity
function getAuctionMinBidAmount(uint256 saleId) external view returns (uint256)
```

### bidAuction

```solidity
function bidAuction(uint256 saleId, uint256 bidAmount) external
```

### finalizeAuction

```solidity
function finalizeAuction(uint256 saleId) external
```

### buyFixedPrice

```solidity
function buyFixedPrice(uint256 saleId, uint256 buyAmount) external
```

### _makeOfferInfo

```solidity
function _makeOfferInfo(address contractAddress, enum MarketCoreUpgradeable.TokenType tokenType, uint256[] tokenIds, uint256[] values, address bidToken, uint256 duration, uint256 price) internal view returns (struct MarketCoreUpgradeable.Sale)
```

### _createOffer

```solidity
function _createOffer(struct MarketCoreUpgradeable.Sale sale) internal
```

### cancelOffer

```solidity
function cancelOffer(uint256 saleId) external
```

### acceptOffer

```solidity
function acceptOffer(uint256 saleId) external
```

### activeSaleIds

```solidity
function activeSaleIds() public view returns (uint256[])
```

### activeSales

```solidity
function activeSales() public view returns (struct MarketCoreUpgradeable.Sale[])
```

## MarketCounterUpgradable

### _getSaleId

```solidity
function _getSaleId() internal returns (uint256)
```

## MarketFeeUpgradeable

### MarketFeesUpdated

```solidity
event MarketFeesUpdated(uint256 marketFeeBps)
```

### __MarketFee_int

```solidity
function __MarketFee_int(uint256 marketFeeBps) internal
```

### getMarketFeeConfig

```solidity
function getMarketFeeConfig() external view returns (uint256)
```

### setMarketFeeConfig

```solidity
function setMarketFeeConfig(uint256 marketFeeBps) external
```

### _getFees

```solidity
function _getFees(uint256 price) internal view returns (uint256)
```

## MarketFundDistributorUpgradeable

### __MarketFundDistributor_int

```solidity
function __MarketFundDistributor_int(uint256 maxRoyaltyBps, uint256 marketFeeBps, address treasury) internal
```

### _distributeFunds

```solidity
function _distributeFunds(address contractAddress, uint256 tokenId, address bidTokenAddress, address seller, uint256 price) internal returns (uint256, uint256, uint256)
```

## MarketRoyaltyUpgradeable

### RoyaltyInfo

```solidity
struct RoyaltyInfo {
  address recipient;
  uint256 amount;
}
```

### royalties

```solidity
mapping(address => mapping(uint256 => struct MarketRoyaltyUpgradeable.RoyaltyInfo)) royalties
```

### MarketRoyaltyUpdated

```solidity
event MarketRoyaltyUpdated(uint256 maxRoyaltiyBps)
```

### __MarketRoyalty_int

```solidity
function __MarketRoyalty_int(uint256 maxRoyaltyBps) internal
```

### getMarketRoyaltyConfig

```solidity
function getMarketRoyaltyConfig() external view returns (uint256)
```

### setMarketRoyaltyConfig

```solidity
function setMarketRoyaltyConfig(uint256 maxRoyaltyBps) external
```

### setRoyaltyFor

```solidity
function setRoyaltyFor(address from, address contractAddress, uint256 tokenId, uint256 royaltyBps) internal
```

### _getRoyalty

```solidity
function _getRoyalty(address contractAddress, uint256 tokenId, uint256 price) internal view returns (address, uint256)
```

## TreasuryNode

### __TreasuryNode_init

```solidity
function __TreasuryNode_init(address treasury) internal
```

### getTreasury

```solidity
function getTreasury() public view returns (address)
```

## Cosmic

### totalUpgraded

```solidity
uint256 totalUpgraded
```

### totalBurned

```solidity
uint256 totalBurned
```

### constructor

```solidity
constructor() public
```

### leftToUpgrade

```solidity
function leftToUpgrade() external view virtual returns (uint256)
```

Get the amount of CosmicCoin left in circulation

_Convenience proxy function to get the remaining balance of
     CosmicCoin, represented as an 18 decimal token_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | balance of CosmicCoin represented as an 18 decimal token |

### upgradeAll

```solidity
function upgradeAll() external
```

Upgrade all CosmicCoin to Cosmic

_Gets the entire balance of the calling wallet's old CosmicCoin and
     transfers it to the predefined burn address. It then converts the
     9 decimal balance to an 18 decimal balance, mints it as Cosmic,
     and then stores the balance for convenience calling._

### missingBurn

```solidity
function missingBurn() public view virtual returns (uint256)
```

Check for burn discrepancy

_Checks to see if cosmic v1 has been burned through a means
     other than upgrade_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | amount available to burn |

### burnSync

```solidity
function burnSync() public returns (uint256)
```

_Burns Cosmic to match CosmicCoin_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | amount burned |

### pause

```solidity
function pause() external
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     upgradeAll and transferFrom functions_

### unpause

```solidity
function unpause() external
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     upgradeAll and transferFrom functions_

### convert9to18

```solidity
function convert9to18(uint256 amount) internal pure returns (uint256)
```

_Convenience function to convert a 9 decimal value into
     an 18 decimal value_

### burn

```solidity
function burn(uint256 amount) public virtual
```

Burn Cosmic, destroying it permanently

_Destroys the `amount` of tokens sent by the caller and
     adds that amount to the balance of totalBurned_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | Quantity of Cosmic to burn |

### burnFrom

```solidity
function burnFrom(address account, uint256 amount) public virtual
```

Burn Cosmic from an address, destroying it permanently

_Destroys the `amount` of tokens set by the caller from
     `account` and adds that amount to the balance of
     totalBurned. The caller must have an allowance for the
     `account`_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | Address to burn Cosmic from |
| amount | uint256 | Quantity of Cosmic to burn |

### _mint

```solidity
function _mint(address account, uint256 amount) internal virtual
```

_Required override for _mint because both ERC20Capped and
ERC20 have the same function, so the derived contract must
override it_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | Address of the account to send Cosmic to |
| amount | uint256 | Quantity of Cosmic to mint |

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal
```

_Required override for _beforeTokenTransfer because both
ERC20Pausable and ERC20 have the same function, so the derived
contract must override it_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | Address of the sender |
| to | address | Address of the recipient |
| amount | uint256 | Amount of Cosmic to transfer |

## IFramedWizards

### safeMint

```solidity
function safeMint(address, uint256) external
```

## CosmicWizards3D

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

### upgrade2DWizards

```solidity
function upgrade2DWizards(uint256[] tokenIds) public
```

Upgrade all 2D Wizards to 3D Wizards

_Gets the entire balance of the calling wallet's 2D Wizards and
     transfers them all to the predefined burn address. It then
     mints a 3D wizard, as well as minting a Framed Wizard collectable_

### burn

```solidity
function burn(uint256 tokenId) public virtual
```

Burn a wizard, destroying is permanently

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

Set the BaseURI of all wizards

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

Set the TokenURI of a single wizard

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
     the upgrade2DWizards and transferFrom functions_

### unpause

```solidity
function unpause() public
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     the upgrade2DWizards and transferFrom functions_

### setBurnable

```solidity
function setBurnable(uint256 state) external
```

Set the ability to burn wizards

_Sets the burnable state of wizards, with 0 being false
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

## TestWizards2D

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### MINTER_ROLE

```solidity
bytes32 MINTER_ROLE
```

### ComicWizardDetail

```solidity
struct ComicWizardDetail {
  uint256 first_encounter;
}
```

### TokenMinted

```solidity
event TokenMinted(uint256 tokenId, address owner, uint256 first_encounter)
```

### PROVENANCE

```solidity
string PROVENANCE
```

### MAX_PURCHASE

```solidity
uint256 MAX_PURCHASE
```

### MAX_TOKENS

```solidity
uint256 MAX_TOKENS
```

### CURRENT_PRICE

```solidity
uint256 CURRENT_PRICE
```

### saleIsActive

```solidity
bool saleIsActive
```

### constructor

```solidity
constructor() public
```

Contract constructor

### withdraw

```solidity
function withdraw() public
```

With

### reserveTokens

```solidity
function reserveTokens() public
```

Reserve tokens

### mintTokenId

```solidity
function mintTokenId(uint256 tokenId) public
```

Mint a specific token.

### setProvenanceHash

```solidity
function setProvenanceHash(string provenanceHash) public
```

### setMaxTokens

```solidity
function setMaxTokens(uint256 maxTokens) public
```

### setSaleState

```solidity
function setSaleState(bool newState) public
```

### mintComicWizard

```solidity
function mintComicWizard(uint256 numberOfTokens) public payable
```

Mint ComicWizard World

### setBaseURI

```solidity
function setBaseURI(string BaseURI) public
```

_Changes the base URI if we want to move things in the future (Callable by owner only)_

### _baseURI

```solidity
function _baseURI() internal view virtual returns (string)
```

_Base URI for computing {tokenURI}. Empty by default, can be overriden
in child contracts._

### setCurrentPrice

```solidity
function setCurrentPrice(uint256 currentPrice) public
```

Set the current token price

### getComicWizardDetail

```solidity
function getComicWizardDetail(uint256 tokenId) public view returns (struct TestWizards2D.ComicWizardDetail detail)
```

Get the token detail

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

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

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address operator, address from, address to, uint256[] ids, uint256[] amounts, bytes data) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

## CosmicBundles

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

### burn

```solidity
function burn(address account, uint256 id, uint256 amount) public
```

### uri

```solidity
function uri(uint256 tokenId) public view virtual returns (string)
```

### setBridgeContract

```solidity
function setBridgeContract(address _bridgeContract) public
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address operator, address from, address to, uint256[] ids, uint256[] amounts, bytes data) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

## CosmicComponents

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

### uri

```solidity
function uri(uint256 tokenId) public view returns (string)
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

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address operator, address from, address to, uint256[] ids, uint256[] amounts, bytes data) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

## CosmicPotions

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

### uri

```solidity
function uri(uint256 tokenId) public view returns (string)
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 id, uint256 amount) external view returns (bytes)
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

### burn

```solidity
function burn(address account, uint256 id, uint256 amount) public
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address operator, address from, address to, uint256[] ids, uint256[] amounts, bytes data) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

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

## CosmicRefinedResources

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

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 id, uint256 amount) external view returns (bytes)
```

### setBridgeContract

```solidity
function setBridgeContract(address _bridgeContract) public
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

## CosmicSkins

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

### burn

```solidity
function burn(address account, uint256 id, uint256 amount) public
```

### burnBatch

```solidity
function burnBatch(address from, uint256[] ids, uint256[] amounts) public
```

### uri

```solidity
function uri(uint256 tokenId) public view returns (string)
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256, uint256) external pure returns (bytes)
```

### setBridgeContract

```solidity
function setBridgeContract(address _bridgeContract) public
```

### pause

```solidity
function pause() public
```

### unpause

```solidity
function unpause() public
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address operator, address from, address to, uint256[] ids, uint256[] amounts, bytes data) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

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

## ERC1155Metadata

### name

```solidity
string name
```

### symbol

```solidity
string symbol
```

### __ERC1155Metadata_init

```solidity
function __ERC1155Metadata_init(string _name, string _symbol) internal
```

### setMetadata

```solidity
function setMetadata(string _name, string _symbol) internal
```

## ERC1155Soulbound

_Contract to lock items to wallets_

### SOULBOUND_WHITELIST_ROLE

```solidity
bytes32 SOULBOUND_WHITELIST_ROLE
```

### notSoulbound

```solidity
modifier notSoulbound(uint256[] tokenIds, address from, address to)
```

### __ERC1155Soulbound_init

```solidity
function __ERC1155Soulbound_init() internal
```

### setSoulbound

```solidity
function setSoulbound(uint256 tokenId) public
```

### unsetSoulbound

```solidity
function unsetSoulbound(uint256 tokenId) public
```

### isSoulbound

```solidity
function isSoulbound(uint256 tokenId) public view returns (bool)
```

## ERC1155Supply

_Extension of ERC1155 that adds tracking of total supply per id.

Useful for scenarios where Fungible and Non-fungible tokens have to be
clearly identified. Note: While a totalSupply of 1 might mean the
corresponding is an NFT, there is no guarantees that no other token with the
same id are not going to be minted._

### __ERC1155Supply_init

```solidity
function __ERC1155Supply_init() internal
```

### totalSupply

```solidity
function totalSupply(uint256 id) public view virtual returns (uint256)
```

_Total amount of tokens in with a given id._

### exists

```solidity
function exists(uint256 id) public view virtual returns (bool)
```

_Indicates whether any token exist with a given id, or not._

### activeIds

```solidity
function activeIds() public view virtual returns (uint256[])
```

_Array of tokenIds that have been used._

### tokensOf

```solidity
function tokensOf(address owner) public view virtual returns (uint256[] tokenIds, uint256[] balances)
```

### balanceOfAll

```solidity
function balanceOfAll() public view virtual returns (address[] owners, uint256[][] tokenIds, uint256[][] balances)
```

### removeFrom

```solidity
function removeFrom(address owner, uint256 tokenId, uint256 amount) internal
```

### addTo

```solidity
function addTo(address owner, uint256 tokenId) internal
```

### removeIfEmpty

```solidity
function removeIfEmpty(address owner) internal
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address operator, address from, address to, uint256[] ids, uint256[] amounts, bytes data) internal virtual
```

_See {ERC1155-_beforeTokenTransfer}._

## ERC1155URITokenJSON

_ERC1155 token with JSON based token URI management._

### imageBaseURI

```solidity
string imageBaseURI
```

### __ERC1155URITokenJSON_init

```solidity
function __ERC1155URITokenJSON_init(string _imageBaseUri) internal
```

### uri

```solidity
function uri(uint256 tokenIds) public view virtual returns (string)
```

### batchUri

```solidity
function batchUri(uint256[] tokenIds) public view virtual returns (string[])
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) public view virtual returns (string[])
```

### _makeBase64

```solidity
function _makeBase64(string json) internal view virtual returns (string)
```

### _makeJSON

```solidity
function _makeJSON(uint256 tokenId, string name, string description, struct CosmicStructs.Attribute[] attributes) internal view returns (string)
```

### _makeMetadata

```solidity
function _makeMetadata(uint256 tokenId, string name, string description) internal view returns (string)
```

### _makeAttributes

```solidity
function _makeAttributes(struct CosmicStructs.Attribute[] attributes) internal pure returns (string)
```

### _setImageBaseURI

```solidity
function _setImageBaseURI(string _imageBaseURI) internal virtual
```

## CosmicStructs

### Attribute

```solidity
struct Attribute {
  string name;
  string display;
  string value;
}
```

## ICosmicBundles

### mint

```solidity
function mint(address account, uint256 id, uint256 amount, bytes data) external
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
function burnBatch(address from, uint256[] ids, uint256[] amounts) external
```

### uri

```solidity
function uri(uint256 tokenId) external view returns (string)
```

## IStandardERC1155

### mint

```solidity
function mint(address to, uint256 id, uint256 amount, bytes data) external
```

### burn

```solidity
function burn(address account, uint256 id, uint256 amount) external
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 id, uint256 amount) external view returns (bytes)
```

### bridgeContract

```solidity
function bridgeContract() external returns (address)
```

## CosmicUpgradeable

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
function pause() external
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     upgradeAll and transferFrom functions_

### unpause

```solidity
function unpause() external
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     upgradeAll and transferFrom functions_

### mint

```solidity
function mint(address account, uint256 amount) public
```

### _mint

```solidity
function _mint(address account, uint256 amount) internal virtual
```

_Required override for _mint because both ERC20Capped and
ERC20 have the same function, so the derived contract must
override it_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | Address of the account to send Cosmic to |
| amount | uint256 | Quantity of Cosmic to mint |

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal
```

_Required override for _beforeTokenTransfer because both
ERC20Pausable and ERC20 have the same function, so the derived
contract must override it_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | Address of the sender |
| to | address | Address of the recipient |
| amount | uint256 | Amount of Cosmic to transfer |

## Magic

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
function pause() external
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     upgradeAll and transferFrom functions_

### unpause

```solidity
function unpause() external
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     upgradeAll and transferFrom functions_

### mint

```solidity
function mint(address account, uint256 amount) public
```

### mint

```solidity
function mint(address account, uint256 amount, bytes) public
```

### _mint

```solidity
function _mint(address account, uint256 amount) internal virtual
```

_Required override for _mint because both ERC20Capped and
ERC20 have the same function, so the derived contract must
override it_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | Address of the account to send Cosmic to |
| amount | uint256 | Quantity of Cosmic to mint |

### burn

```solidity
function burn(uint256 amount) public virtual
```

_Destroys `amount` tokens from the caller.

See {ERC20-_burn}._

### burn

```solidity
function burn(address to, uint256 amount) public virtual
```

### bridgeExtraData

```solidity
function bridgeExtraData() external pure returns (bytes)
```

### setBridgeContract

```solidity
function setBridgeContract(address _address) external
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal
```

_Required override for _beforeTokenTransfer because both
ERC20Pausable and ERC20 have the same function, so the derived
contract must override it_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | Address of the sender |
| to | address | Address of the recipient |
| amount | uint256 | Amount of Cosmic to transfer |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

## MagicL2

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
function pause() external
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     upgradeAll and transferFrom functions_

### unpause

```solidity
function unpause() external
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     upgradeAll and transferFrom functions_

### mint

```solidity
function mint(address account, uint256 amount) public
```

### mint

```solidity
function mint(address account, uint256 amount, bytes) public
```

### burn

```solidity
function burn(uint256 amount) public virtual
```

_Destroys `amount` tokens from the caller.

See {ERC20-_burn}._

### burn

```solidity
function burn(address to, uint256 amount) public virtual
```

### burnFrom

```solidity
function burnFrom(address account, uint256 amount) public virtual
```

_Destroys `amount` tokens from `account`, deducting from the caller's
allowance.

See {ERC20-_burn} and {ERC20-allowance}.

Requirements:

- the caller must have allowance for ``accounts``'s tokens of at least
`amount`._

### bridgeExtraData

```solidity
function bridgeExtraData() external pure returns (bytes)
```

Overrides

### setBridgeContract

```solidity
function setBridgeContract(address _address) external
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal
```

_Required override for _beforeTokenTransfer because both
ERC20Pausable and ERC20 have the same function, so the derived
contract must override it_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | Address of the sender |
| to | address | Address of the recipient |
| amount | uint256 | Amount of Cosmic to transfer |

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal
```

_Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
{upgradeTo} and {upgradeToAndCall}.

Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.

```solidity
function _authorizeUpgrade(address) internal override onlyOwner {}
```_

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

## ERC20BurnableUpgradeable

_Extension of {ERC20} that allows token holders to destroy both their own
tokens and those that they have an allowance for, in a way that can be
recognized off-chain (via event analysis)._

### __ERC20Burnable_init

```solidity
function __ERC20Burnable_init() internal
```

### __ERC20Burnable_init_unchained

```solidity
function __ERC20Burnable_init_unchained() internal
```

### totalBurned

```solidity
function totalBurned() public view virtual returns (uint256)
```

### burn

```solidity
function burn(uint256 amount) public virtual
```

_Destroys `amount` tokens from the caller.

See {ERC20-_burn}._

### unBurn

```solidity
function unBurn(uint256 amount) internal virtual
```

### burnFrom

```solidity
function burnFrom(address account, uint256 amount) public virtual
```

_Destroys `amount` tokens from `account`, deducting from the caller's
allowance.

See {ERC20-_burn} and {ERC20-allowance}.

Requirements:

- the caller must have allowance for ``accounts``'s tokens of at least
`amount`._

## IERC20ExtendedUpgradeable

_Interface of the ERC20 standard as defined in the EIP._

### cap

```solidity
function cap() external view returns (uint256)
```

### mint

```solidity
function mint(address to, uint256 amount) external
```

### burn

```solidity
function burn(address account, uint256 amount) external
```

## IMintable

### mint

```solidity
function mint(address to, uint256 amount) external
```

### batchMint

```solidity
function batchMint(address to, uint256[] ids) external
```

### bridgeMint

```solidity
function bridgeMint(address to, uint256 id) external
```

### burn

```solidity
function burn(address account, uint256 amount) external
```

### burn

```solidity
function burn(uint256 amount) external
```

## IStandardERC20

### mint

```solidity
function mint(address to, uint256 amount, bytes data) external
```

### burn

```solidity
function burn(address from, uint256 amount) external
```

### bridgeContract

```solidity
function bridgeContract() external returns (address)
```

## IlMagic

_Interface of the ERC20 standard as defined in the EIP._

### cap

```solidity
function cap() external view returns (uint256)
```

### mint

```solidity
function mint(address to, uint256 amount) external
```

### burnFrom

```solidity
function burnFrom(address account, uint256 amount) external
```

### burn

```solidity
function burn(address account, uint256 amount) external
```

## lMagicUpgradeable

### onlyWhitelist

```solidity
modifier onlyWhitelist(address from, address to)
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
function mint(address _address, uint256 amount) public
```

### burn

```solidity
function burn(uint256 amount) public virtual
```

_Destroys `amount` tokens from the caller.

See {ERC20-_burn}._

### burnFrom

```solidity
function burnFrom(address account, uint256 amount) public virtual
```

_Destroys `amount` tokens from `account`, deducting from the caller's
allowance.

See {ERC20-_burn} and {ERC20-allowance}.

Requirements:

- the caller must have allowance for ``accounts``'s tokens of at least
`amount`._

### claimPending

```solidity
function claimPending() public
```

### pendingOf

```solidity
function pendingOf(address _address) public view returns (uint256)
```

### totalOf

```solidity
function totalOf(address _address) public view returns (uint256)
```

### addGlobalWhitelist

```solidity
function addGlobalWhitelist(address to) public
```

### addWhitelist

```solidity
function addWhitelist(address from, address to) public
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal
```

_Hook that is called before any transfer of tokens. This includes
minting and burning.

Calling conditions:

- when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
will be transferred to `to`.
- when `from` is zero, `amount` tokens will be minted for `to`.
- when `to` is zero, `amount` of ``from``'s tokens will be burned.
- `from` and `to` are never both zero.

To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks]._

## xMagicUpgradeable

### PAUSER_ROLE

```solidity
bytes32 PAUSER_ROLE
```

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### deposit

```solidity
function deposit(uint256 amount) public
```

### withdraw

```solidity
function withdraw(uint256 amount) public
```

### pause

```solidity
function pause() public
```

### unpause

```solidity
function unpause() public
```

### setBaseToken

```solidity
function setBaseToken(address _address) public
```

## CosmicElves

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
function mint(address to, uint256 tokenId) public
```

### batchMint

```solidity
function batchMint(address to, uint256[] tokenIds) public
```

### tokenURIJSON

```solidity
function tokenURIJSON(uint256 tokenId) public view virtual returns (string)
```

### mint

```solidity
function mint(address to, uint256 tokenId, bytes data) public
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 tokenId) external view returns (bytes)
```

### pause

```solidity
function pause() public
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     updateSkill and transferFrom functions_

### unpause

```solidity
function unpause() public
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     the upgrade2DWizards and transferFrom functions_

### setImageBaseURI

```solidity
function setImageBaseURI(string _imageBaseURI) public
```

### setBridgeContract

```solidity
function setBridgeContract(address _bridgeContract) public
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view returns (string)
```

### burn

```solidity
function burn(uint256 tokenId) public virtual
```

### _burn

```solidity
function _burn(uint256 tokenId) internal virtual
```

_Destroys `tokenId`.
The approval is cleared when the token is burned.
This is an internal function that does not check if the sender is authorized to operate on the token.

Requirements:

- `tokenId` must exist.

Emits a {Transfer} event._

### _exists

```solidity
function _exists(uint256 tokenId) internal view virtual returns (bool)
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

## CosmicElvesTicket

### PendingMint

```solidity
struct PendingMint {
  uint256[] ids;
  uint256 requestId;
  uint256[] words;
}
```

### treasury

```solidity
address treasury
```

### price

```solidity
uint256 price
```

### cap

```solidity
uint256 cap
```

### imageBaseURI

```solidity
string imageBaseURI
```

### notBlacklisted

```solidity
modifier notBlacklisted(address _address)
```

### notFinished

```solidity
modifier notFinished()
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
function mint(uint256 count) public
```

### mint

```solidity
function mint(address to, uint256 id) public
```

### batchMint

```solidity
function batchMint(address to, uint256[] ids) public
```

### reveal

```solidity
function reveal() public
```

### partialReveal

```solidity
function partialReveal(uint256 count) public
```

### _partialRevealFor

```solidity
function _partialRevealFor(address _address, uint256 count) internal
```

### partialRevealFor

```solidity
function partialRevealFor(address _address, uint256 count) public
```

### discountOf

```solidity
function discountOf(uint256 tokenId) public view returns (uint256 discount)
```

### batchDiscountOf

```solidity
function batchDiscountOf(uint256[] tokenIds) public view returns (uint256[])
```

### tokensAndDiscountsOfOwner

```solidity
function tokensAndDiscountsOfOwner(address _address) public view returns (uint256[] tokens, uint256[] discounts)
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

_See {IERC721Metadata-tokenURI}._

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) public view returns (string[])
```

### oddsOf

```solidity
function oddsOf(uint256 chance) internal pure returns (string)
```

### lastTokenId

```solidity
function lastTokenId() public view returns (uint256)
```

### revealsPendingOf

```solidity
function revealsPendingOf(address _address) public view returns (uint256[], bool)
```

### adminCheckPendingMintDataOf

```solidity
function adminCheckPendingMintDataOf(address _address) public view returns (struct CosmicElvesTicket.PendingMint)
```

### adminGetNewRandomnessFor

```solidity
function adminGetNewRandomnessFor(address _address) public
```

### fulfillRandomWords

```solidity
function fulfillRandomWords(uint256 requestId, uint256[] randomWords) internal
```

fulfillRandomness handles the VRF response. Your contract must
implement it. See "SECURITY CONSIDERATIONS" above for important
principles to keep in mind when implementing your fulfillRandomness
method.

_VRFConsumerBaseV2 expects its subcontracts to have a method with this
signature, and will call it once it has verified the proof
associated with the randomness. (It is triggered via a call to
rawFulfillRandomness, below.)_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| requestId | uint256 | The Id initially returned by requestRandomness |
| randomWords | uint256[] | the VRF output expanded to the requested number of words |

### setTicketPrice

```solidity
function setTicketPrice(uint256 _price) public
```

### setCap

```solidity
function setCap(uint256 _cap) public
```

### addBlacklist

```solidity
function addBlacklist(address _address) public
```

### removeBlacklist

```solidity
function removeBlacklist(address _address) public
```

### setImageBaseURI

```solidity
function setImageBaseURI(string _imageBaseURI) public
```

### setDiscountsOf

```solidity
function setDiscountsOf(uint256[] tokenIds, uint256[] discounts) public
```

### pause

```solidity
function pause() external
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     upgradeAll and transferFrom functions_

### unpause

```solidity
function unpause() external
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     upgradeAll and transferFrom functions_

### _exists

```solidity
function _exists(uint256 tokenId) internal view virtual returns (bool)
```

### approve

```solidity
function approve(address to, uint256 tokenId) public virtual
```

### setApprovalForAll

```solidity
function setApprovalForAll(address operator, bool approved) public virtual
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

## CosmicIslandLand

### Region

```solidity
enum Region {
  Road,
  Water,
  ElysianFields,
  EnchantedForest,
  MysticAlpines,
  ForestOfWhimsy
}
```

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

CosmicAttributeStorage

### bridgeContract

```solidity
address bridgeContract
```

### ValueUpdated

```solidity
event ValueUpdated(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value)
```

### TextUpdated

```solidity
event TextUpdated(uint256 tokenId, uint256 customId, string value)
```

### notBlacklisted

```solidity
modifier notBlacklisted(address _address)
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
function mint(address to, uint256 tokenId) public
```

### batchMint

```solidity
function batchMint(address to, uint256[] tokenIds) public
```

### mint

```solidity
function mint(address to, uint256 tokenId, bytes data) public
```

### pause

```solidity
function pause() public
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     the upgrade2DWizards and transferFrom functions_

### unpause

```solidity
function unpause() public
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     the upgrade2DWizards and transferFrom functions_

### updateSkill

```solidity
function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) public
```

### updateString

```solidity
function updateString(uint256 tokenId, uint256 customId, string value) public
```

### getSkill

```solidity
function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) public view returns (uint256 value)
```

### getSkillsByTree

```solidity
function getSkillsByTree(uint256 tokenId, uint256 treeId, uint256[] skillIds) public view returns (uint256[])
```

### getString

```solidity
function getString(uint256 tokenId, uint256 customId) public view returns (string value)
```

### getStrings

```solidity
function getStrings(uint256 tokenId, uint256[] customIds) public view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(uint256[] tokenIds, uint256 customId) public view returns (string[])
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) public view returns (string[])
```

### tokenURIJSON

```solidity
function tokenURIJSON(uint256 tokenId) public view virtual returns (string)
```

### batchTokenURIJSON

```solidity
function batchTokenURIJSON(uint256[] tokenIds) public view returns (string[])
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 tokenId) external view returns (bytes)
```

### setTokenURI

```solidity
function setTokenURI(uint256 tokenId, uint256 attrId, uint256 value) public
```

### setTokenURIs

```solidity
function setTokenURIs(uint256[] tokenIds, uint256[] attrIds, uint256[] values) public
```

### setImageBaseURI

```solidity
function setImageBaseURI(string _imageBaseURI) public
```

### burn

```solidity
function burn(uint256 tokenId) public virtual
```

### _burn

```solidity
function _burn(uint256 tokenId) internal virtual
```

### _exists

```solidity
function _exists(uint256 tokenId) internal view virtual returns (bool)
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

## CosmicTools

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
function mint(address to, uint256 tokenId, bytes data) public
```

### mint

```solidity
function mint(address to, bytes data) external
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

### tokenURIJSON

```solidity
function tokenURIJSON(uint256 tokenId) public view virtual returns (string)
```

### imageURISuffix

```solidity
function imageURISuffix(uint256 tokenId) internal view returns (string)
```

### setBridgeContract

```solidity
function setBridgeContract(address _bridgeContract) external
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 tokenId) external view returns (bytes)
```

### nextId

```solidity
function nextId() public view returns (uint256)
```

### setMaxDurability

```solidity
function setMaxDurability(uint256 tokenId) public
```

### maxDurability

```solidity
function maxDurability(enum SharedStructs.Rarity rarity) internal pure returns (uint256)
```

### rarityString

```solidity
function rarityString(enum SharedStructs.Rarity rarity) internal pure returns (string)
```

### pause

```solidity
function pause() public
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     updateSkill and transferFrom functions_

### unpause

```solidity
function unpause() public
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     the upgrade2DWizards and transferFrom functions_

### setNextId

```solidity
function setNextId(uint256 id) public
```

### setImageBaseURI

```solidity
function setImageBaseURI(string _imageBaseURI) public
```

### burn

```solidity
function burn(uint256 tokenId) public
```

### _burn

```solidity
function _burn(uint256 tokenId) internal virtual
```

_Destroys `tokenId`.
The approval is cleared when the token is burned.
This is an internal function that does not check if the sender is authorized to operate on the token.

Requirements:

- `tokenId` must exist.

Emits a {Transfer} event._

### _exists

```solidity
function _exists(uint256 tokenId) internal view virtual returns (bool)
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

## CosmicWizards

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

CosmicAttributeStorage

### bridgeContract

```solidity
address bridgeContract
```

### ValueUpdated

```solidity
event ValueUpdated(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value)
```

### TextUpdated

```solidity
event TextUpdated(uint256 tokenId, uint256 customId, string value)
```

### notActive

```solidity
modifier notActive(uint256 tokenId)
```

### notBlacklisted

```solidity
modifier notBlacklisted(address _address)
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
function mint(address to, uint256 tokenId) public
```

### batchMint

```solidity
function batchMint(address to, uint256[] tokenIds) public
```

### mint

```solidity
function mint(address to, uint256 tokenId, bytes data) public
```

### pause

```solidity
function pause() public
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     the upgrade2DWizards and transferFrom functions_

### unpause

```solidity
function unpause() public
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     the upgrade2DWizards and transferFrom functions_

### updateSkill

```solidity
function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) public
```

### batchUpdateSkills

```solidity
function batchUpdateSkills(uint256[] tokenIds, uint256[] treeIds, uint256[] skillIds, uint256[] values) public
```

### batchUpdateSkillsOfToken

```solidity
function batchUpdateSkillsOfToken(uint256 tokenId, uint256 treeId, uint256[] skillIds, uint256[] values) public
```

### updateString

```solidity
function updateString(uint256 tokenId, uint256 customId, string value) public
```

### updateAttributeStrings

```solidity
function updateAttributeStrings(uint256 treeId, uint256 skillId, uint256[] values, string[] stringValues) public
```

### getSkill

```solidity
function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) public view returns (uint256 value)
```

### getSkillsByTree

```solidity
function getSkillsByTree(uint256 tokenId, uint256 treeId, uint256[] skillIds) public view returns (uint256[])
```

### getString

```solidity
function getString(uint256 tokenId, uint256 customId) public view returns (string value)
```

### getStrings

```solidity
function getStrings(uint256 tokenId, uint256[] customIds) public view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(uint256[] tokenIds, uint256 customId) public view returns (string[])
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

### tokenURIJSON

```solidity
function tokenURIJSON(uint256 tokenId) public view returns (string)
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) public view returns (string[])
```

### batchTokenURIJSON

```solidity
function batchTokenURIJSON(uint256[] tokenIds) public view returns (string[])
```

### bridgeExtraData

```solidity
function bridgeExtraData(uint256 tokenId) external view returns (bytes)
```

### adminRescue

```solidity
function adminRescue(address from, address[] accounts, uint256[] tokenIds) external
```

### setImageBaseURI

```solidity
function setImageBaseURI(string _imageBaseURI) public
```

### setBridgeContract

```solidity
function setBridgeContract(address _bridgeContract) public
```

### burn

```solidity
function burn(uint256 tokenId) public virtual
```

### _burn

```solidity
function _burn(uint256 tokenId) internal virtual
```

### _exists

```solidity
function _exists(uint256 tokenId) internal view virtual returns (bool)
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

## FramedWizardsUpgradeable

### notBlacklisted

```solidity
modifier notBlacklisted(address _address)
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
function mint(address to, uint256 tokenId) public
```

### batchMint

```solidity
function batchMint(address to, uint256[] tokenIds) public
```

### pause

```solidity
function pause() public
```

Pause token upgrades and transfers

_Allows the owner of the contract to stop the execution of
     the upgrade2DWizards and transferFrom functions_

### unpause

```solidity
function unpause() public
```

Unpause token upgrades and transfers

_Allows the owner of the contract to resume the execution of
     the upgrade2DWizards and transferFrom functions_

### setTokenURI

```solidity
function setTokenURI(uint256 token, bytes uri) public
```

### setTokenURIs

```solidity
function setTokenURIs(uint256[] tokens, bytes[] uris) public
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) public view returns (string[])
```

### _burn

```solidity
function _burn(uint256 tokenId) internal virtual
```

### _exists

```solidity
function _exists(uint256 tokenId) internal view virtual returns (bool)
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view returns (bool)
```

## CosmicAttributeStorageUpgradeable

_Central storage contract for Cosmic Universe NFTs_

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

### ValueUpdated

```solidity
event ValueUpdated(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value)
```

### TextUpdated

```solidity
event TextUpdated(uint256 tokenId, uint256 customId, string value)
```

### __CosmicAttributeStorage_init

```solidity
function __CosmicAttributeStorage_init() internal
```

### __CosmicAttributeStorage_init_unchained

```solidity
function __CosmicAttributeStorage_init_unchained() internal
```

### updateSkill

```solidity
function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) public
```

_Update a single skill to value_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | ID of the NFT |
| treeId | uint256 | ID of the storage tree |
| skillId | uint256 | ID of the skill |
| value | uint256 | new skill value |

### batchUpdateSkills

```solidity
function batchUpdateSkills(uint256[] tokenIds, uint256[] treeIds, uint256[] skillIds, uint256[] values) public
```

### batchUpdateSkillsOfToken

```solidity
function batchUpdateSkillsOfToken(uint256 tokenId, uint256 treeId, uint256[] skillIds, uint256[] values) public
```

### updateString

```solidity
function updateString(uint256 tokenId, uint256 customId, string value) public
```

### setSkillName

```solidity
function setSkillName(uint256 treeId, uint256 skillId, string name) public
```

### batchSetSkillName

```solidity
function batchSetSkillName(uint256 treeId, uint256[] skillIds, string[] names) public
```

### getSkill

```solidity
function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) public view returns (uint256)
```

_Get a single skill value_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | ID of the NFT |
| treeId | uint256 | ID of the storage tree |
| skillId | uint256 | ID of the skill |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | value skill value |

### getSkillsByTree

```solidity
function getSkillsByTree(uint256 tokenId, uint256 treeId, uint256[] skillIds) public view returns (uint256[])
```

### getString

```solidity
function getString(uint256 tokenId, uint256 customId) public view returns (string)
```

### getStrings

```solidity
function getStrings(uint256 tokenId, uint256[] customIds) public view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(uint256[] tokenIds, uint256 customId) public view returns (string[])
```

### getSkillName

```solidity
function getSkillName(uint256 treeId, uint256 skillId) public view returns (string)
```

## ERC721BurnableExtendedUpgradeable

_This implements an optional extension of {ERC721} defined in the EIP that adds
enumerability of all the token ids in the contract as well as all token ids owned by each
account._

### __ERC721BurnableExtended_init

```solidity
function __ERC721BurnableExtended_init() internal
```

### __ERC721BurnableExtended_init_unchained

```solidity
function __ERC721BurnableExtended_init_unchained() internal
```

### burn

```solidity
function burn(uint256 tokenId) public virtual
```

_Burns `tokenId`. See {ERC721-_burn}.

Requirements:

- The caller must own `tokenId` or be an approved operator._

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

_See {IERC165-supportsInterface}._

### _removeBurnedId

```solidity
function _removeBurnedId(uint256 tokenId) internal virtual
```

### _exists

```solidity
function _exists(uint256 tokenId) internal view virtual returns (bool)
```

_Returns whether `tokenId` exists.

Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.

Tokens start existing when they are minted (`_mint`),
and stop existing when they are burned (`_burn`)._

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual
```

## ERC721EnumerableExtendedUpgradeable

_This implements an optional extension of {ERC721} defined in the EIP that adds
enumerability of all the token ids in the contract as well as all token ids owned by each
account._

### __ERC721EnumerableExtended_init

```solidity
function __ERC721EnumerableExtended_init() internal
```

### __ERC721EnumerableExtended_init_unchained

```solidity
function __ERC721EnumerableExtended_init_unchained() internal
```

### batchTransferFrom

```solidity
function batchTransferFrom(address from, address to, uint256[] tokenIds) public virtual
```

### tokensOfOwner

```solidity
function tokensOfOwner(address owner) public view virtual returns (uint256[])
```

### getAllTokenIds

```solidity
function getAllTokenIds() public view returns (uint256[])
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual
```

## ERC721URIStorageExtendedUpgradeable

_ERC721 token with storage based token URI management._

### imageBaseURI

```solidity
string imageBaseURI
```

### __ERC721URIStorageExtended_init

```solidity
function __ERC721URIStorageExtended_init() internal
```

### __ERC721URIStorageExtended_init_unchained

```solidity
function __ERC721URIStorageExtended_init_unchained() internal
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

_See {IERC721Metadata-tokenURI}._

### _setImageBaseURI

```solidity
function _setImageBaseURI(string _imageBaseURI) internal virtual
```

### _setTokenURI

```solidity
function _setTokenURI(uint256 tokenId, bytes _tokenURI) internal virtual
```

### _presetTokenURI

```solidity
function _presetTokenURI(uint256 tokenId, bytes _tokenURI) internal virtual
```

### _burn

```solidity
function _burn(uint256 tokenId) internal virtual
```

_Destroys `tokenId`.
The approval is cleared when the token is burned.
This is an internal function that does not check if the sender is authorized to operate on the token.

Requirements:

- `tokenId` must exist.

Emits a {Transfer} event._

## ERC721URITokenJSON

_ERC721 token with storage based token URI management._

### imageBaseURI

```solidity
string imageBaseURI
```

### __ERC721URITokenJSON_init

```solidity
function __ERC721URITokenJSON_init() internal
```

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

_See {IERC721Metadata-tokenURI}._

### tokenURIJSON

```solidity
function tokenURIJSON(uint256 tokenId) public view virtual returns (string)
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) public view virtual returns (string[])
```

### batchTokenURIJSON

```solidity
function batchTokenURIJSON(uint256[] tokenIds) public view virtual returns (string[])
```

### makeMetadataJSON

```solidity
function makeMetadataJSON(uint256 tokenId, string name, string description, struct TokenMetadata.Attribute[] attributes) internal view virtual returns (string)
```

### imageURISuffix

```solidity
function imageURISuffix(uint256 tokenId) internal view virtual returns (string)
```

## ICosmicAttributeStorage

### updateSkill

```solidity
function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) external
```

### updateString

```solidity
function updateString(uint256 tokenId, uint256 customId, string value) external
```

### getSkill

```solidity
function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) external view returns (uint256 value)
```

### getSkillsByTree

```solidity
function getSkillsByTree(uint256 tokenId, uint256 treeId, uint256[] skillIds) external view returns (uint256[])
```

### getString

```solidity
function getString(uint256 tokenId, uint256 customId) external view returns (string value)
```

### getStrings

```solidity
function getStrings(uint256 tokenId, uint256[] customIds) external view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(uint256[] tokenIds, uint256 customId) external view returns (string[])
```

## ICosmicElves

### Elf

```solidity
struct Elf {
  uint256[] base;
  uint256[] adventures;
  uint256[] professions;
}
```

### mint

```solidity
function mint(address to, uint256 tokenId) external
```

### getAllTokenIds

```solidity
function getAllTokenIds() external view returns (uint256[])
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) external view returns (string[])
```

### batchMint

```solidity
function batchMint(address to, uint256[] tokenIds) external
```

### updateSkill

```solidity
function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) external
```

### batchUpdateSkillsOfToken

```solidity
function batchUpdateSkillsOfToken(uint256 tokenId, uint256 treeId, uint256[] skillIds, uint256[] values) external
```

### updateString

```solidity
function updateString(uint256 tokenId, uint256 customId, string value) external
```

### getSkill

```solidity
function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) external view returns (uint256 value)
```

### getSkillsByTree

```solidity
function getSkillsByTree(uint256 tokenId, uint256 treeId, uint256[] skillIds) external view returns (uint256[])
```

### getString

```solidity
function getString(uint256 tokenId, uint256 customId) external view returns (string value)
```

### getStrings

```solidity
function getStrings(uint256 tokenId, uint256[] customIds) external view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(uint256[] tokenIds, uint256 customId) external view returns (string[])
```

## ICosmicElvesTicket

### batchDiscountOf

```solidity
function batchDiscountOf(uint256[] tokenIds) external view returns (uint256[])
```

### burn

```solidity
function burn(uint256 tokenId) external
```

### lastTokenId

```solidity
function lastTokenId() external view returns (uint256)
```

## ICosmicWizards

### Wizard

```solidity
struct Wizard {
  uint256[] base;
  uint256[] professions;
  uint256[] extra;
}
```

### mint

```solidity
function mint(address to, uint256 tokenId) external
```

### getAllTokenIds

```solidity
function getAllTokenIds() external view returns (uint256[])
```

### batchTokenURI

```solidity
function batchTokenURI(uint256[] tokenIds) external view returns (string[])
```

### batchMint

```solidity
function batchMint(address to, uint256[] tokenIds) external
```

### updateSkill

```solidity
function updateSkill(uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) external
```

### batchUpdateSkillsOfToken

```solidity
function batchUpdateSkillsOfToken(uint256 tokenId, uint256 treeId, uint256[] skillIds, uint256[] values) external
```

### updateString

```solidity
function updateString(uint256 tokenId, uint256 customId, string value) external
```

### getSkill

```solidity
function getSkill(uint256 tokenId, uint256 treeId, uint256 skillId) external view returns (uint256 value)
```

### getSkillsByTree

```solidity
function getSkillsByTree(uint256 tokenId, uint256 treeId, uint256[] skillIds) external view returns (uint256[])
```

### getString

```solidity
function getString(uint256 tokenId, uint256 customId) external view returns (string value)
```

### getStrings

```solidity
function getStrings(uint256 tokenId, uint256[] customIds) external view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(uint256[] tokenIds, uint256 customId) external view returns (string[])
```

## TokenMetadata

### TokenType

```solidity
enum TokenType {
  ERC20,
  ERC1155,
  ERC721
}
```

### Attribute

```solidity
struct Attribute {
  string name;
  string displayType;
  string value;
  bool isNumber;
}
```

### toBase64

```solidity
function toBase64(string json) internal pure returns (string)
```

### makeMetadataJSON

```solidity
function makeMetadataJSON(uint256 tokenId, address owner, string name, string imageURI, string description, enum TokenMetadata.TokenType tokenType, struct TokenMetadata.Attribute[] attributes) internal pure returns (string)
```

### makeMetadataString

```solidity
function makeMetadataString(uint256 tokenId, address owner, string name, string imageURI, string description, enum TokenMetadata.TokenType tokenType) internal pure returns (string)
```

### toJSONString

```solidity
function toJSONString(struct TokenMetadata.Attribute[] attributes) internal pure returns (string)
```

### toString

```solidity
function toString(enum TokenMetadata.TokenType tokenType) internal pure returns (string)
```

### makeContractURI

```solidity
function makeContractURI(string name, string description, string imageURL, string externalLinkURL, uint256 sellerFeeBasisPoints, address feeRecipient) internal pure returns (string)
```

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

## ChestRedeemer

### Resource

```solidity
struct Resource {
  uint256 firstId;
  uint256 min;
  uint256 max;
}
```

### ResourceConfig

```solidity
struct ResourceConfig {
  address _address;
  struct ChestRedeemer.Resource a;
  struct ChestRedeemer.Resource b;
  struct ChestRedeemer.Resource c;
}
```

### bundles

```solidity
address bundles
```

### tools

```solidity
address tools
```

### rawResources

```solidity
address rawResources
```

### refinedResources

```solidity
address refinedResources
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### redeem

```solidity
function redeem(uint256 id) external payable
```

### rollVipPass

```solidity
function rollVipPass(uint256 rand, bool mythical) internal
```

### rollPet

```solidity
function rollPet(uint256 rand) internal
```

### rollRune

```solidity
function rollRune(uint256 rand, bool mythical) internal
```

### rollTool

```solidity
function rollTool(uint256 rand1, uint256 rand2, bool mythical) internal
```

### rollResources

```solidity
function rollResources(uint256[] randomChunks, bool mythical) internal
```

### rollResource

```solidity
function rollResource(uint256 skillId, struct ChestRedeemer.Resource r, uint256 rand1, uint256 rand2, bool mythical) internal
```

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

### setResourcesConfig

```solidity
function setResourcesConfig(uint256[] skillIds, struct ChestRedeemer.ResourceConfig[] configs) external
```

### resourcesConfig

```solidity
function resourcesConfig() external view returns (struct ChestRedeemer.ResourceConfig[] config)
```

## CosmicElvesMinter

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

### ELVES

```solidity
contract ICosmicElves ELVES
```

### ETICKET

```solidity
contract ICosmicElvesTicket ETICKET
```

### USDC

```solidity
contract IERC20Upgradeable USDC
```

### PendingMint

```solidity
struct PendingMint {
  uint256[] ids;
  uint256 requestId;
  uint256[] words;
}
```

### startTime

```solidity
uint256 startTime
```

### cap

```solidity
uint256 cap
```

### treasury

```solidity
address treasury
```

### price

```solidity
uint256 price
```

### TEAM_ROLE

```solidity
bytes32 TEAM_ROLE
```

### gated

```solidity
modifier gated()
```

### creditsAdded

```solidity
event creditsAdded(address from, address to, uint256 amount)
```

### creditsUsed

```solidity
event creditsUsed(address from, uint256 amount)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### buy

```solidity
function buy(uint256 count, uint256[] tickets) public
```

### adminRequest

```solidity
function adminRequest(uint256 count) public
```

### adminAddRandomness

```solidity
function adminAddRandomness(address account, uint256 count) external
```

### adminForceMint

```solidity
function adminForceMint(address account, uint256 count) public
```

### mint

```solidity
function mint(uint256 count) public
```

### _mint

```solidity
function _mint(address account, uint256 count) public
```

### adminForceSpecific

```solidity
function adminForceSpecific(address account, uint256 begin, uint256 end) public
```

### _getAttributes

```solidity
function _getAttributes(uint256[] randomChunks) internal view returns (uint256[])
```

### _attributeRoll

```solidity
function _attributeRoll(uint256[] weights, uint256 roll) internal pure returns (uint256)
```

### setAttributeWeights

```solidity
function setAttributeWeights(uint256 gender, uint256 attribute, uint256[] weights) public
```

### setAttributesWeights

```solidity
function setAttributesWeights(uint256 gender, uint256[] attributes, uint256[][] weights) public
```

### setTotalElvesTickets

```solidity
function setTotalElvesTickets(uint256 total) public
```

### fulfillRandomWords

```solidity
function fulfillRandomWords(uint256 requestId, uint256[] randomWords) internal
```

fulfillRandomness handles the VRF response. Your contract must
implement it. See "SECURITY CONSIDERATIONS" above for important
principles to keep in mind when implementing your fulfillRandomness
method.

_VRFConsumerBaseV2 expects its subcontracts to have a method with this
signature, and will call it once it has verified the proof
associated with the randomness. (It is triggered via a call to
rawFulfillRandomness, below.)_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| requestId | uint256 | The Id initially returned by requestRandomness |
| randomWords | uint256[] | the VRF output expanded to the requested number of words |

### pendingMintsOf

```solidity
function pendingMintsOf(address user) public view returns (uint256[], bool)
```

### pendingData

```solidity
function pendingData(address user) public view returns (uint256[], uint256[], uint256)
```

### lastTokenId

```solidity
function lastTokenId() public view returns (uint256)
```

### creditOf

```solidity
function creditOf(address account) public view returns (uint256)
```

### addCredit

```solidity
function addCredit(address[] accounts, uint256[] amounts) external
```

### setCredit

```solidity
function setCredit(address[] accounts, uint256[] amounts) external
```

### setPrice

```solidity
function setPrice(uint256 _price) external
```

## IProfessionStakingAvalanche

### isOwner

```solidity
function isOwner(uint256 tokenId, address owner) external view returns (bool)
```

## ProfessionStakingAvalanche

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### NFT

```solidity
struct NFT {
  address _address;
  uint256 tokenId;
  uint256 rewardFrom;
}
```

### ParticipantData

```solidity
struct ParticipantData {
  struct EnumerableSetUpgradeable.UintSet nftIds;
  mapping(uint256 => struct ProfessionStakingAvalanche.NFT) nfts;
  uint256 rewards;
}
```

### Attribute

```solidity
struct Attribute {
  uint256 treeId;
  uint256 skillId;
}
```

### TrainingLevelConfig

```solidity
struct TrainingLevelConfig {
  uint256 cost;
  uint256 time;
}
```

### StakingConfig

```solidity
struct StakingConfig {
  uint256 startTime;
  uint256 maxPointsPerSkill;
  uint256 treeId;
  uint256[] skillIds;
  contract IERC20Upgradeable rewardToken;
  mapping(uint256 => struct ProfessionStakingAvalanche.TrainingLevelConfig) trainingLevelConfig;
  contract ICosmicAttributeStorage stakingToken;
  struct ProfessionStakingAvalanche.Attribute stakingEnabledAttribute;
}
```

### TrainingStatus

```solidity
struct TrainingStatus {
  address _address;
  uint256 tokenId;
  uint256 level;
  uint256 treeId;
  uint256 skillId;
  uint256 startedAt;
  uint256 completeAt;
}
```

### treasury

```solidity
address treasury
```

### StakingConfigCreated

```solidity
event StakingConfigCreated(address nftAddress, address rewardToken, uint256 startTime)
```

### StakingConfigUpdated

```solidity
event StakingConfigUpdated(address nftAddress, address rewardToken, uint256 startTime)
```

### StakingConfigDeleted

```solidity
event StakingConfigDeleted(address nftAddress)
```

### Staked

```solidity
event Staked(address from, address nftAddress, uint256 tokenId)
```

### Unstaked

```solidity
event Unstaked(address from, address nftAddress, uint256 tokenId)
```

### Claimed

```solidity
event Claimed(address by, address token, uint256 amount)
```

### PoolRewardsDeposited

```solidity
event PoolRewardsDeposited(address from, address token, uint256 amount)
```

### PoolRewardsWithdrawn

```solidity
event PoolRewardsWithdrawn(address by, address to, address token, uint256 amount)
```

### StakingUnlocked

```solidity
event StakingUnlocked(address by, address nftAddress, uint256 tokenId)
```

### TrainingStarted

```solidity
event TrainingStarted(address by, address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 level, uint256 startedAt, uint256 completeAt)
```

### TrainingFinished

```solidity
event TrainingFinished(address by, address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 level)
```

### TrainingCanceled

```solidity
event TrainingCanceled(address by, address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 canceledAt)
```

### onlyStaked

```solidity
modifier onlyStaked(uint256 tokenId)
```

### onlyNotStaked

```solidity
modifier onlyNotStaked(uint256 tokenId)
```

### onlyUnlocked

```solidity
modifier onlyUnlocked(uint256 tokenId)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### enableStaking

```solidity
function enableStaking(uint256 tokenId) public
```

PUBLIC functions

### batchEnableStaking

```solidity
function batchEnableStaking(uint256[] tokenIds) public
```

### stake

```solidity
function stake(uint256 tokenId) public
```

### batchStake

```solidity
function batchStake(uint256[] tokenIds) public
```

### unstake

```solidity
function unstake(uint256 tokenId) public
```

### batchUnstake

```solidity
function batchUnstake(uint256[] tokenIds) public
```

### startTraining

```solidity
function startTraining(uint256 tokenId, uint256 skillId) public
```

### isAllowedOption

```solidity
function isAllowedOption(uint256 tokenId, uint256 skillId) internal view returns (bool)
```

### batchStartTraining

```solidity
function batchStartTraining(uint256[] tokenIds, uint256[] skillIds) public
```

### finishTraining

```solidity
function finishTraining(uint256 tokenId) public
```

### batchFinishTraining

```solidity
function batchFinishTraining(uint256[] tokenIds) public
```

### cancelTraining

```solidity
function cancelTraining(uint256 tokenId) public
```

### batchCancelTraining

```solidity
function batchCancelTraining(uint256[] tokenIds) public
```

### setTrainingCost

```solidity
function setTrainingCost(uint256 level, uint256 cost, uint256 time) public
```

UPDATER_ROLE functions

### batchSetTrainingCosts

```solidity
function batchSetTrainingCosts(uint256[] level, uint256[] cost, uint256[] time) public
```

### setSkillPointer

```solidity
function setSkillPointer(uint256 skillId) public
```

### createStakingConfig

```solidity
function createStakingConfig(address stakingToken, address rewardToken, uint256 startTime, uint256 maxPointsPerSkill, uint256 treeId, uint256[] skillIds) public
```

### updateStakingConfig

```solidity
function updateStakingConfig(address nftAddress, contract IERC20Upgradeable rewardToken, uint256 startTime, uint256 maxPointsPerSkill) public
```

### deleteStakingConfig

```solidity
function deleteStakingConfig(address nftAddress) public
```

### _depositFee

```solidity
function _depositFee() internal
```

### getStakedOf

```solidity
function getStakedOf(address _address) public view returns (struct ProfessionStakingAvalanche.NFT[])
```

Helpers

### isStakingEnabled

```solidity
function isStakingEnabled(uint256 tokenId) public view returns (bool)
```

### getActiveTrainingOf

```solidity
function getActiveTrainingOf(address _address) public view returns (struct ProfessionStakingAvalanche.TrainingStatus[])
```

### isOwner

```solidity
function isOwner(uint256 tokenId, address owner) public view returns (bool)
```

### adminMigrateStaked

```solidity
function adminMigrateStaked(address[] accounts, uint256[] tokenIds) public
```

### getTrainingStatus

```solidity
function getTrainingStatus(address account, uint256 tokenId) public view returns (struct ProfessionStakingAvalanche.TrainingStatus)
```

### getAllowedSkillChoices

```solidity
function getAllowedSkillChoices(uint256 tokenId) public view returns (uint256[])
```

### forceCancelTraining

```solidity
function forceCancelTraining(address account, uint256 tokenId) public
```

### modifyActiveTrainingSkill

```solidity
function modifyActiveTrainingSkill(address account, uint256 tokenId, uint256 skillId) public
```

### getTotalProfessionSkillPoints

```solidity
function getTotalProfessionSkillPoints(uint256 tokenId) public view returns (uint256)
```

### getAllParticipantData

```solidity
function getAllParticipantData() public view returns (address[] addresses, struct ProfessionStakingAvalanche.NFT[][] nfts)
```

### setTrainingLevelConfig

```solidity
function setTrainingLevelConfig(uint256[] levels, uint256[] times, uint256[] costs) public
```

internal

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

### onERC721Received

```solidity
function onERC721Received(address, address, uint256, bytes) external pure returns (bytes4)
```

## StakingRewardsClaimAvalanche

### WIZARDS

```solidity
contract ICosmicWizards WIZARDS
```

### BUNDLES

```solidity
contract ICosmicBundles BUNDLES
```

### ChestClaimed

```solidity
event ChestClaimed(address from, uint256 tokenID, uint256 chestId)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### claim

```solidity
function claim(uint256 tokenId) public
```

### batchClaim

```solidity
function batchClaim(uint256[] tokenIds) public
```

### stakedClaim

```solidity
function stakedClaim(uint256 tokenId, address owner) public
```

### batchStakedClaim

```solidity
function batchStakedClaim(uint256[] tokenIds, address[] owners) public
```

### checkEligibility

```solidity
function checkEligibility(uint256 tokenId) public view returns (address owner, uint256 points, uint256 claimed)
```

### getTotalProfessionSkillPoints

```solidity
function getTotalProfessionSkillPoints(uint256 tokenId) internal view returns (uint256)
```

### pause

```solidity
function pause() public
```

### unpause

```solidity
function unpause() public
```

## ElvenAdventures

### onAdventure

```solidity
modifier onAdventure(uint256 tokenId)
```

### notOnAdventure

```solidity
modifier notOnAdventure(uint256 tokenId)
```

### onlyUnlocked

```solidity
modifier onlyUnlocked(uint256 tokenId)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### unlockAdventures

```solidity
function unlockAdventures(uint256 tokenId) public
```

### batchUnlockAdventures

```solidity
function batchUnlockAdventures(uint256[] tokenIds) external
```

### beginAdventure

```solidity
function beginAdventure(uint256 tokenId) public
```

### batchBeginAdventure

```solidity
function batchBeginAdventure(uint256[] tokenIds) external
```

### finishAdventure

```solidity
function finishAdventure(uint256 tokenId) public
```

### batchFinishAdventure

```solidity
function batchFinishAdventure(uint256[] tokenIds) external
```

### _startQuest

```solidity
function _startQuest(uint256 tokenId, uint256 skillId, bool leveling) internal
```

### startQuest

```solidity
function startQuest(uint256 tokenId, uint256 skillId) public
```

### batchStartQuest

```solidity
function batchStartQuest(uint256[] tokenIds) external
```

_Start a quest for multiple tokenIds at once. If any tokenId is not currently leveling(e.g. their
     profession level is in the range of 1-19) it will revert._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenIds | uint256[] | Array of tokenIds |

### finishQuest

```solidity
function finishQuest(uint256 tokenId) public
```

### batchFinishQuest

```solidity
function batchFinishQuest(uint256[] tokenIds) external
```

### abandonQuest

```solidity
function abandonQuest(uint256 tokenId) public
```

### batchAbandonQuest

```solidity
function batchAbandonQuest(uint256[] tokenIds) external
```

### sendReward

```solidity
function sendReward(uint256 level, uint256 skillId) internal
```

### isRefResID

```solidity
function isRefResID(uint256 rewardId) internal pure returns (bool)
```

### isValidSkill

```solidity
function isValidSkill(uint256 tokenId, uint256 skillId) internal view returns (bool)
```

### setQuestTime

```solidity
function setQuestTime(uint256 level, uint256 time) public
```

### batchSetQuestTime

```solidity
function batchSetQuestTime(uint256[] levels, uint256[] time) public
```

### setRewards

```solidity
function setRewards(uint256[] levels, struct IElvenAdventures.Reward[] rewards) external
```

### setRewardAddressFor

```solidity
function setRewardAddressFor(uint256 level, address _address) public
```

### setLateInit

```solidity
function setLateInit() external
```

### getQuest

```solidity
function getQuest(uint256 tokenId) public view returns (struct IElvenAdventures.Quest)
```

### getQuests

```solidity
function getQuests(uint256[] tokenIds) external view returns (struct IElvenAdventures.Quest[])
```

### getQuestsArray

```solidity
function getQuestsArray(uint256[] tokenIds) external view returns (uint256[], uint256[] levels, uint256[] skillIds, uint256[] completeAts)
```

### getAllowedSkillChoices

```solidity
function getAllowedSkillChoices(uint256 tokenId) public view returns (uint256[])
```

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal
```

_Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
{upgradeTo} and {upgradeToAndCall}.

Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.

```solidity
function _authorizeUpgrade(address) internal override onlyOwner {}
```_

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

## ProfessionStakingHarmony

### PAUSER_ROLE

```solidity
bytes32 PAUSER_ROLE
```

### UPDATER_ROLE

```solidity
bytes32 UPDATER_ROLE
```

### GAME_STORAGE

```solidity
contract IGameStorageUpgradeable GAME_STORAGE
```

### NFT

```solidity
struct NFT {
  address _address;
  uint256 tokenId;
  uint256 rewardFrom;
}
```

### Token

```solidity
struct Token {
  address _address;
  uint256 amount;
}
```

### ParticipantData

```solidity
struct ParticipantData {
  struct ProfessionStakingHarmony.NFT[] nfts;
  struct ProfessionStakingHarmony.Token[] rewards;
}
```

### StakingConfig

```solidity
struct StakingConfig {
  uint256 startTime;
  uint256 maxPointsPerSkill;
  uint256[] treeIds;
  uint256[] skillIds;
  address rewardToken;
}
```

### StakingEnabledPointer

```solidity
struct StakingEnabledPointer {
  uint256 treeId;
  uint256 skillId;
}
```

### TrainingLevelConfig

```solidity
struct TrainingLevelConfig {
  uint256 cost;
  uint256 time;
}
```

### TrainingStatus

```solidity
struct TrainingStatus {
  address _address;
  uint256 tokenId;
  uint256 level;
  uint256 treeId;
  uint256 skillId;
  uint256 startedAt;
  uint256 completeAt;
}
```

### LAST_REWARD_TIME

```solidity
uint256 LAST_REWARD_TIME
```

### StakingConfigCreated

```solidity
event StakingConfigCreated(address nftAddress, address rewardToken, uint256 startTime)
```

### StakingConfigUpdated

```solidity
event StakingConfigUpdated(address nftAddress, address rewardToken, uint256 startTime)
```

### StakingConfigDeleted

```solidity
event StakingConfigDeleted(address nftAddress)
```

### Staked

```solidity
event Staked(address from, address nftAddress, uint256 tokenId)
```

### Unstaked

```solidity
event Unstaked(address from, address nftAddress, uint256 tokenId)
```

### Claimed

```solidity
event Claimed(address by, address token, uint256 amount)
```

### PoolRewardsDeposited

```solidity
event PoolRewardsDeposited(address from, address token, uint256 amount)
```

### PoolRewardsWithdrawn

```solidity
event PoolRewardsWithdrawn(address by, address to, address token, uint256 amount)
```

### StakingUnlocked

```solidity
event StakingUnlocked(address by, address nftAddress, uint256 tokenId)
```

### TrainingStarted

```solidity
event TrainingStarted(address by, address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 level, uint256 startedAt, uint256 completeAt)
```

### TrainingFinished

```solidity
event TrainingFinished(address by, address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 level)
```

### TrainingCanceled

```solidity
event TrainingCanceled(address by, address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 canceledAt)
```

### ClaimBlocked

```solidity
event ClaimBlocked(address from, uint256 stakedCount, uint256 amount)
```

### onlyStaked

```solidity
modifier onlyStaked(address nftAddress, uint256 tokenId)
```

### onlyNotStaked

```solidity
modifier onlyNotStaked(address nftAddress, uint256 tokenId)
```

### onlyUnlocked

```solidity
modifier onlyUnlocked(address nftAddress, uint256 tokenId)
```

### whenNotFinished

```solidity
modifier whenNotFinished()
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### enableStaking

```solidity
function enableStaking(address nftAddress, uint256 tokenId) public
```

PUBLIC functions

### batchEnableStaking

```solidity
function batchEnableStaking(address[] nftAddresses, uint256[] tokenIds) public
```

### stake

```solidity
function stake(address nftAddress, uint256 tokenId) public
```

### batchStake

```solidity
function batchStake(address[] nftAddresses, uint256[] tokenIds) public
```

### unstake

```solidity
function unstake(address nftAddress, uint256 tokenId) public
```

### _unstake

```solidity
function _unstake(address _address, address nftAddress, uint256 tokenId) internal
```

### batchUnstake

```solidity
function batchUnstake(address[] nftAddresses, uint256[] tokenIds) public
```

### claim

```solidity
function claim() public
```

### _claim

```solidity
function _claim(address _address) internal
```

### startTraining

```solidity
function startTraining(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId) public
```

### batchStartTraining

```solidity
function batchStartTraining(address[] nftAddresses, uint256[] tokenIds, uint256[] treeIds, uint256[] skillIds) public
```

### finishTraining

```solidity
function finishTraining(address nftAddress, uint256 tokenId) public
```

### batchFinishTraining

```solidity
function batchFinishTraining(address[] nftAddresses, uint256[] tokenIds) public
```

### cancelTraining

```solidity
function cancelTraining(address nftAddress, uint256 tokenId) public
```

### batchCancelTraining

```solidity
function batchCancelTraining(address[] nftAddresses, uint256[] tokenIds) public
```

### setTrainingCost

```solidity
function setTrainingCost(uint256 level, uint256 cost, uint256 time) public
```

UPDATER_ROLE functions

### batchSetTrainingCosts

```solidity
function batchSetTrainingCosts(uint256[] level, uint256[] cost, uint256[] time) public
```

### setGameStorage

```solidity
function setGameStorage(address _address) public
```

### setSkillPointer

```solidity
function setSkillPointer(address nftAddress, uint256 treeId, uint256 skillId) public
```

### createStakingConfig

```solidity
function createStakingConfig(address nftAddress, address rewardToken, uint256 startTime, uint256 maxPointsPerSkill, uint256[] treeIds, uint256[] skillIds) public
```

### updateStakingConfig

```solidity
function updateStakingConfig(address nftAddress, address rewardToken, uint256 startTime, uint256 maxPointsPerSkill) public
```

### deleteStakingConfig

```solidity
function deleteStakingConfig(address nftAddress) public
```

### withdrawPoolRewards

```solidity
function withdrawPoolRewards(address to, address token, uint256 amount) public
```

### pendingRewards

```solidity
function pendingRewards() public view returns (uint256)
```

Helpers

### pendingRewardsOf

```solidity
function pendingRewardsOf(address _address) public view returns (uint256)
```

### getStaked

```solidity
function getStaked() public view returns (struct ProfessionStakingHarmony.NFT[])
```

### getStakedOf

```solidity
function getStakedOf(address _address) public view returns (struct ProfessionStakingHarmony.NFT[])
```

### isStakingEnabled

```solidity
function isStakingEnabled(address nftAddress, uint256 tokenId) public view returns (bool)
```

### getActiveTraining

```solidity
function getActiveTraining() public view returns (struct ProfessionStakingHarmony.TrainingStatus[])
```

### getActiveTrainingOf

```solidity
function getActiveTrainingOf(address _address) public view returns (struct ProfessionStakingHarmony.TrainingStatus[])
```

### getTrainingStatus

```solidity
function getTrainingStatus(address _address, address nftAddress, uint256 tokenId) public view returns (struct ProfessionStakingHarmony.TrainingStatus)
```

### getAllowedSkillChoices

```solidity
function getAllowedSkillChoices(address nftAddress, uint256 tokenId) public view returns (uint256[])
```

### forceCancelTraining

```solidity
function forceCancelTraining(address _address, address nftAddress, uint256 tokenId) public
```

### modifyActiveTrainingSkill

```solidity
function modifyActiveTrainingSkill(address _address, address nftAddress, uint256 tokenId, uint256 skillId) public
```

### adminUpdateNftData

```solidity
function adminUpdateNftData(address _address, uint256 index, address nftAddress, uint256 tokenId, uint256 rewardFrom) public
```

### adminBatchUpdateNftData

```solidity
function adminBatchUpdateNftData(address[] addresses, uint256[] indexes, address[] nftAddresses, uint256[] tokenIds, uint256[] rewardFrom) public
```

### getTotalProfessionSkillPoints

```solidity
function getTotalProfessionSkillPoints(address ntfAddress, uint256 tokenId) public view returns (uint256)
```

### getAllParticipantData

```solidity
function getAllParticipantData() public view returns (address[] addresses, struct ProfessionStakingHarmony.NFT[][] nfts, uint256[] rewards)
```

### _clear_if_empty

```solidity
function _clear_if_empty(address _address) internal
```

internal

### _disburse_all_rewards

```solidity
function _disburse_all_rewards() internal
```

### _disburse_rewards

```solidity
function _disburse_rewards(address _address) internal
```

### _disburse_reward

```solidity
function _disburse_reward(address _address, struct ProfessionStakingHarmony.NFT nft) internal
```

### _disburse_nft_reward

```solidity
function _disburse_nft_reward(address _address, address nftAddress, uint256 tokenId, uint256 rewardFrom) internal
```

### claimAndUnstakeForUser

```solidity
function claimAndUnstakeForUser(address _address) public
```

### batchClaimAndUnstakeForUser

```solidity
function batchClaimAndUnstakeForUser(address[] addresses) public
```

### adminGetData

```solidity
function adminGetData(address user) public view returns (uint256 contractBalance, uint256 userPending)
```

### setLastRewardTime

```solidity
function setLastRewardTime(uint256 time) public
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

### onERC721Received

```solidity
function onERC721Received(address, address, uint256, bytes) external pure returns (bytes4)
```

## SimpleMasterInvestor

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

### UserInfo

```solidity
struct UserInfo {
  uint256 amount;
  uint256 rewardDebt;
  uint256 rewardDebtAtTime;
  uint256 lastWithdrawTime;
  uint256 firstDepositTime;
  uint256 timeDelta;
  uint256 lastDepositTime;
}
```

### PoolInfo

```solidity
struct PoolInfo {
  contract IERC20ExtendedUpgradeable lpToken;
  uint256 allocPoint;
  uint256 lastRewardTime;
  uint256 accGovTokenPerShare;
}
```

### ConstructorParams

```solidity
struct ConstructorParams {
  contract IERC20ExtendedUpgradeable govToken;
  uint256 rewardPerSecond;
  uint256 startTime;
  uint256 userDepositFee;
  uint256 devDepositFee;
  address devFundAddress;
  address feeShareFundAddress;
  address marketingFundAddress;
  address foundersFundAddress;
  uint256[] userFeeStages;
  uint256[] devFeeStages;
}
```

### GOV_TOKEN

```solidity
contract IERC20ExtendedUpgradeable GOV_TOKEN
```

### DEV_FUND_ADDRESS

```solidity
address DEV_FUND_ADDRESS
```

### FEE_SHARE_FUND_ADDRESS

```solidity
address FEE_SHARE_FUND_ADDRESS
```

### MARKETING_FUND_ADDRESS

```solidity
address MARKETING_FUND_ADDRESS
```

### FOUNDERS_FUND_ADDRESS

```solidity
address FOUNDERS_FUND_ADDRESS
```

### REWARD_PER_SECOND

```solidity
uint256 REWARD_PER_SECOND
```

### USER_FEE_STAGES

```solidity
uint256[] USER_FEE_STAGES
```

### DEV_FEE_STAGES

```solidity
uint256[] DEV_FEE_STAGES
```

### USER_DEP_FEE

```solidity
uint256 USER_DEP_FEE
```

### DEV_DEP_FEE

```solidity
uint256 DEV_DEP_FEE
```

### START_TIME

```solidity
uint256 START_TIME
```

### TOTAL_ALLOCATION_POINTS

```solidity
uint256 TOTAL_ALLOCATION_POINTS
```

### PERCENT_FOR_DEV

```solidity
uint256 PERCENT_FOR_DEV
```

### PERCENT_FOR_FEE_SHARE

```solidity
uint256 PERCENT_FOR_FEE_SHARE
```

### PERCENT_FOR_MARKETING

```solidity
uint256 PERCENT_FOR_MARKETING
```

### PERCENT_FOR_FOUNDERS

```solidity
uint256 PERCENT_FOR_FOUNDERS
```

### poolInfo

```solidity
struct SimpleMasterInvestor.PoolInfo[] poolInfo
```

### poolId

```solidity
mapping(address => uint256) poolId
```

### userInfo

```solidity
mapping(uint256 => mapping(address => struct SimpleMasterInvestor.UserInfo)) userInfo
```

### poolExistence

```solidity
mapping(contract IERC20ExtendedUpgradeable => bool) poolExistence
```

### FINISH_BONUS_AT_TIME

```solidity
uint256 FINISH_BONUS_AT_TIME
```

### HALVING_AT_TIMES

```solidity
uint256[] HALVING_AT_TIMES
```

### REWARD_MULTIPLIERS

```solidity
uint256[] REWARD_MULTIPLIERS
```

### PERCENT_LOCK_BONUS_REWARD

```solidity
uint256[] PERCENT_LOCK_BONUS_REWARD
```

### Deposit

```solidity
event Deposit(address user, uint256 pid, uint256 amount)
```

### Withdraw

```solidity
event Withdraw(address user, uint256 pid, uint256 amount)
```

### EmergencyWithdraw

```solidity
event EmergencyWithdraw(address user, uint256 pid, uint256 amount)
```

### SendGovernanceTokenReward

```solidity
event SendGovernanceTokenReward(address user, uint256 pid, uint256 amount, uint256 lockAmount)
```

### nonDuplicated

```solidity
modifier nonDuplicated(contract IERC20ExtendedUpgradeable _lpToken)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize(struct SimpleMasterInvestor.ConstructorParams params) public
```

### poolLength

```solidity
function poolLength() external view returns (uint256)
```

### reconfigure

```solidity
function reconfigure() public
```

### add

```solidity
function add(uint256 _allocPoint, contract IERC20ExtendedUpgradeable _lpToken, bool _withUpdate) public
```

### set

```solidity
function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public
```

### massUpdatePools

```solidity
function massUpdatePools() public
```

### updatePool

```solidity
function updatePool(uint256 _pid) public
```

### getMultiplier

```solidity
function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256)
```

### getLockPercentage

```solidity
function getLockPercentage(uint256 _from, uint256 _to) public view returns (uint256)
```

### getPoolReward

```solidity
function getPoolReward(uint256 _from, uint256 _to, uint256 _allocPoint) public view returns (uint256 forDev, uint256 forFarmer, uint256 forLP, uint256 forCom, uint256 forFounders)
```

### pendingReward

```solidity
function pendingReward(uint256 _pid, address _user) external view returns (uint256)
```

### claimRewards

```solidity
function claimRewards(uint256[] _pids) public
```

### claimReward

```solidity
function claimReward(uint256 _pid) public
```

### _harvest

```solidity
function _harvest(uint256 _pid) internal
```

### _harvestFor

```solidity
function _harvestFor(uint256 _pid, address _address) internal
```

### deposit

```solidity
function deposit(uint256 _pid, uint256 _amount) public
```

### withdraw

```solidity
function withdraw(uint256 _pid, uint256 _amount) public
```

### emergencyWithdraw

```solidity
function emergencyWithdraw(uint256 _pid) public
```

### safeGovTokenTransfer

```solidity
function safeGovTokenTransfer(address _to, uint256 _amount) internal
```

### getNewRewardPerSecond

```solidity
function getNewRewardPerSecond(uint256 pid1) public view returns (uint256)
```

### userDelta

```solidity
function userDelta(uint256 _pid) public view returns (uint256)
```

### userDeltaOf

```solidity
function userDeltaOf(uint256 _pid, address _address) public view returns (uint256)
```

### updateLastRewardTime

```solidity
function updateLastRewardTime(uint256 time) public
```

### updateHalvingAtTimes

```solidity
function updateHalvingAtTimes(uint256[] times) public
```

### updateRewardPerSecond

```solidity
function updateRewardPerSecond(uint256 reward) public
```

### updateRewardMultipliers

```solidity
function updateRewardMultipliers(uint256[] multipliers) public
```

### updateUserLockPercents

```solidity
function updateUserLockPercents(uint256[] lockPercents) public
```

### updateStartTime

```solidity
function updateStartTime(uint256 time) public
```

### updateAddress

```solidity
function updateAddress(uint256 kind, address _address) public
```

### updateLockPercent

```solidity
function updateLockPercent(uint256 kind, uint256 percent) public
```

### updateDepositFee

```solidity
function updateDepositFee(uint256 kind, uint256 fee) public
```

### updateFeeStages

```solidity
function updateFeeStages(uint256 kind, uint256[] feeStages) public
```

### reviseWithdraw

```solidity
function reviseWithdraw(uint256 _pid, address _user, uint256 _time) public
```

### reviseDeposit

```solidity
function reviseDeposit(uint256 _pid, address _user, uint256 _time) public
```

### correctWithdrawal

```solidity
function correctWithdrawal(uint256 _pid, address _user, uint256 _amount) public
```

### totalAllocPoint

```solidity
function totalAllocPoint() public view returns (uint256)
```

## GameStorageUpgradeable

_Central storage contract for Cosmic Universe NFTs_

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

### PAUSER_ROLE

```solidity
bytes32 PAUSER_ROLE
```

### ValueUpdated

```solidity
event ValueUpdated(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value)
```

### TextUpdated

```solidity
event TextUpdated(address nftAddress, uint256 tokenId, uint256 customId, string value)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### updateSkill

```solidity
function updateSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) public
```

_Update a single skill to value_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| nftAddress | address | Address of the NFT collection |
| tokenId | uint256 | ID of the NFT |
| treeId | uint256 | ID of the storage tree |
| skillId | uint256 | ID of the skill |
| value | uint256 | new skill value |

### updateString

```solidity
function updateString(address nftAddress, uint256 tokenId, uint256 customId, string value) public
```

### getSkill

```solidity
function getSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId) public view returns (uint256 value)
```

_Get a single skill value_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| nftAddress | address | Address of the NFT collection |
| tokenId | uint256 | ID of the NFT |
| treeId | uint256 | ID of the storage tree |
| skillId | uint256 | ID of the skill |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| value | uint256 | skill value |

### getSkillsByTree

```solidity
function getSkillsByTree(address nftAddress, uint256 tokenId, uint256 treeId, uint256[] skillIds) public view returns (uint256[])
```

### getSkillOfTokens

```solidity
function getSkillOfTokens(address nftAddress, uint256[] tokenIds, uint256 treeId, uint256 skillId) public view returns (uint256[])
```

### getString

```solidity
function getString(address nftAddress, uint256 tokenId, uint256 customId) public view returns (string value)
```

### getStrings

```solidity
function getStrings(address nftAddress, uint256 tokenId, uint256[] customIds) public view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(address nftAddress, uint256[] tokenIds, uint256 customId) public view returns (string[])
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

## IGameStorageUpgradeable

### getSkill

```solidity
function getSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId) external view returns (uint256 value)
```

### getSkillsByTree

```solidity
function getSkillsByTree(address nftAddress, uint256 tokenId, uint256 treeId, uint256[] skillIds) external view returns (uint256[])
```

### updateSkill

```solidity
function updateSkill(address nftAddress, uint256 tokenId, uint256 treeId, uint256 skillId, uint256 value) external
```

### getString

```solidity
function getString(address nftAddress, uint256 tokenId, uint256 customId) external view returns (string value)
```

### getStrings

```solidity
function getStrings(address nftAddress, uint256 tokenId, uint256[] customIds) external view returns (string[])
```

### getStringOfTokens

```solidity
function getStringOfTokens(address nftAddress, uint256[] tokenIds, uint256 customIds) external view returns (string[])
```

### updateString

```solidity
function updateString(address nftAddress, uint256 tokenId, uint256 customId, string value) external
```

## Blacklistable

### notBlacklisted

```solidity
modifier notBlacklisted(address user)
```

### __Blacklistable_init

```solidity
function __Blacklistable_init() internal
```

### _addBlacklisted

```solidity
function _addBlacklisted(address user) internal virtual
```

### _removeBlacklisted

```solidity
function _removeBlacklisted(address user) internal virtual
```

### isBlacklisted

```solidity
function isBlacklisted(address user) public view virtual returns (bool)
```

### getBlacklisted

```solidity
function getBlacklisted() public view virtual returns (address[])
```

## ChainlinkVRFConsumerUpgradeable

### _confirmations

```solidity
uint16 _confirmations
```

### __ChainlinkVRFConsumer_init

```solidity
function __ChainlinkVRFConsumer_init(address coordinator, bytes32 keyHash, uint64 subscriptionId, uint16 confirmations) internal
```

### __ChainlinkVRFConsumer_init_unchained

```solidity
function __ChainlinkVRFConsumer_init_unchained(address coordinator, bytes32 keyHash, uint64 subscriptionId, uint16 confirmations) internal
```

### requestRandomWords

```solidity
function requestRandomWords(uint32 count) internal returns (uint256 requestId)
```

### fulfillRandomWords

```solidity
function fulfillRandomWords(uint256 requestId, uint256[] randomWords) internal virtual
```

fulfillRandomness handles the VRF response. Your contract must
implement it. See "SECURITY CONSIDERATIONS" above for important
principles to keep in mind when implementing your fulfillRandomness
method.

_VRFConsumerBaseV2 expects its subcontracts to have a method with this
signature, and will call it once it has verified the proof
associated with the randomness. (It is triggered via a call to
rawFulfillRandomness, below.)_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| requestId | uint256 | The Id initially returned by requestRandomness |
| randomWords | uint256[] | the VRF output expanded to the requested number of words |

### chunkWord

```solidity
function chunkWord(uint256 word, uint256 modulus, uint256 chunkCount) internal pure returns (uint256[])
```

## ContractConstants

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### CONTRACT_ROLE

```solidity
bytes32 CONTRACT_ROLE
```

## ERC721QueryHelper

### SaleType

```solidity
enum SaleType {
  AUCTION,
  FIXED,
  OFFER
}
```

### TokenType

```solidity
enum TokenType {
  ERC721,
  ERC1155
}
```

### Sale

```solidity
struct Sale {
  enum ERC721QueryHelper.SaleType saleType;
  address seller;
  address contractAddress;
  enum ERC721QueryHelper.TokenType tokenType;
  address bidToken;
  uint256 startTime;
  uint256 duration;
  uint256 extensionDuration;
  uint256 endTime;
  address bidder;
  uint256 bidAmount;
}
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### tokensOfOwner

```solidity
function tokensOfOwner(address token, address owner) public view returns (uint256[])
```

### getActiveSales

```solidity
function getActiveSales() public view returns (uint256[], struct ERC721QueryHelper.Sale[])
```

### getSalePart1

```solidity
function getSalePart1(uint256 i) internal view returns (struct ERC721QueryHelper.Sale)
```

### getSalePart2

```solidity
function getSalePart2(uint256 i) internal view returns (struct ERC721QueryHelper.Sale)
```

## TokenConstants

### ADMIN_ROLE

```solidity
bytes32 ADMIN_ROLE
```

### MINTER_ROLE

```solidity
bytes32 MINTER_ROLE
```

## UEQueryHelper

### ELVES

```solidity
contract ICosmicElves ELVES
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize() public
```

### getAllElves

```solidity
function getAllElves() public view returns (string[])
```

## VRFConsumerBaseV2Upgradeable

***************************************************************************
Interface for contracts using VRF randomness
*****************************************************************************

_PURPOSE

Reggie the Random Oracle (not his real job) wants to provide randomness
to Vera the verifier in such a way that Vera can be sure he's not
making his output up to suit himself. Reggie provides Vera a public key
to which he knows the secret key. Each time Vera provides a seed to
Reggie, he gives back a value which is computed completely
deterministically from the seed and the secret key.

Reggie provides a proof by which Vera can verify that the output was
correctly computed once Reggie tells it to her, but without that proof,
the output is indistinguishable to her from a uniform random sample
from the output space.

The purpose of this contract is to make it easy for unrelated contracts
to talk to Vera the verifier about the work Reggie is doing, to provide
simple access to a verifiable source of randomness. It ensures 2 things:
1. The fulfillment came from the VRFCoordinator
2. The consumer contract implements fulfillRandomWords.
*****************************************************************************
USAGE

Calling contracts must inherit from VRFConsumerBase, and can
initialize VRFConsumerBase's attributes in their constructor as
shown:

  contract VRFConsumer {
    constructor(<other arguments>, address _vrfCoordinator, address _link)
      VRFConsumerBase(_vrfCoordinator) public {
        <initialization with other arguments goes here>
      }
  }

The oracle will have given you an ID for the VRF keypair they have
committed to (let's call it keyHash). Create subscription, fund it
and your consumer contract as a consumer of it (see VRFCoordinatorInterface
subscription management functions).
Call requestRandomWords(keyHash, subId, minimumRequestConfirmations,
callbackGasLimit, numWords),
see (VRFCoordinatorInterface for a description of the arguments).

Once the VRFCoordinator has received and validated the oracle's response
to your request, it will call your contract's fulfillRandomWords method.

The randomness argument to fulfillRandomWords is a set of random words
generated from your requestId and the blockHash of the request.

If your contract could have concurrent requests open, you can use the
requestId returned from requestRandomWords to track which response is associated
with which randomness request.
See "SECURITY CONSIDERATIONS" for principles to keep in mind,
if your contract could have multiple requests in flight simultaneously.

Colliding `requestId`s are cryptographically impossible as long as seeds
differ.

*****************************************************************************
SECURITY CONSIDERATIONS

A method with the ability to call your fulfillRandomness method directly
could spoof a VRF response with any random value, so it's critical that
it cannot be directly called by anything other than this base contract
(specifically, by the VRFConsumerBase.rawFulfillRandomness method).

For your users to trust that your contract's random behavior is free
from malicious interference, it's best if you can write it so that all
behaviors implied by a VRF response are executed *during* your
fulfillRandomness method. If your contract must store the response (or
anything derived from it) and use it later, you must ensure that any
user-significant behavior which depends on that stored value cannot be
manipulated by a subsequent VRF request.

Similarly, both miners and the VRF oracle itself have some influence
over the order in which VRF responses appear on the blockchain, so if
your contract could have multiple VRF requests in flight simultaneously,
you must ensure that the order in which the VRF responses arrive cannot
be used to manipulate your contract's user-significant behavior.

Since the block hash of the block which contains the requestRandomness
call is mixed into the input to the VRF *last*, a sufficiently powerful
miner could, in principle, fork the blockchain to evict the block
containing the request, forcing the request to be included in a
different block with a different hash, and therefore a different input
to the VRF. However, such an attack would incur a substantial economic
cost. This cost scales with the number of blocks the VRF oracle waits
until it calls responds to a request. It is for this reason that
that you can signal to an oracle you'd like them to wait longer before
responding to the request (however this is not enforced in the contract
and so remains effective only in the case of unmodified oracle software)._

### OnlyCoordinatorCanFulfill

```solidity
error OnlyCoordinatorCanFulfill(address have, address want)
```

### __VRFConsumerBaseV2_init

```solidity
function __VRFConsumerBaseV2_init(address _vrfCoordinator) internal
```

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vrfCoordinator | address | address of VRFCoordinator contract |

### __VRFConsumerBaseV2_init_unchained

```solidity
function __VRFConsumerBaseV2_init_unchained(address _vrfCoordinator) internal
```

### fulfillRandomWords

```solidity
function fulfillRandomWords(uint256 requestId, uint256[] randomWords) internal virtual
```

fulfillRandomness handles the VRF response. Your contract must
implement it. See "SECURITY CONSIDERATIONS" above for important
principles to keep in mind when implementing your fulfillRandomness
method.

_VRFConsumerBaseV2 expects its subcontracts to have a method with this
signature, and will call it once it has verified the proof
associated with the randomness. (It is triggered via a call to
rawFulfillRandomness, below.)_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| requestId | uint256 | The Id initially returned by requestRandomness |
| randomWords | uint256[] | the VRF output expanded to the requested number of words |

### rawFulfillRandomWords

```solidity
function rawFulfillRandomWords(uint256 requestId, uint256[] randomWords) external
```

## StandardAccessControl

### __StandardAccessControl_init

```solidity
function __StandardAccessControl_init() internal
```

### onlyDefaultAdmin

```solidity
modifier onlyDefaultAdmin()
```

### onlyAdmin

```solidity
modifier onlyAdmin()
```

### onlyContract

```solidity
modifier onlyContract()
```

### onlyMinter

```solidity
modifier onlyMinter()
```

### onlyPrivate

```solidity
modifier onlyPrivate()
```

### onlyBridge

```solidity
modifier onlyBridge()
```

### _hasDefaultAdminRole

```solidity
function _hasDefaultAdminRole(address _address) internal view returns (bool)
```

### _hasAdminRole

```solidity
function _hasAdminRole(address _address) internal view returns (bool)
```

### _hasContractRole

```solidity
function _hasContractRole(address _address) internal view returns (bool)
```

### _hasMinterRole

```solidity
function _hasMinterRole(address _address) internal view returns (bool)
```

### _hasPrivateRole

```solidity
function _hasPrivateRole(address _address) internal view returns (bool)
```

### _hasBridgeRole

```solidity
function _hasBridgeRole(address _address) internal view returns (bool)
```

### _checkRoles

```solidity
function _checkRoles(bytes32[] roles) internal view virtual
```

### _checkRoles

```solidity
function _checkRoles(bytes32[] roles, address account) internal view virtual
```

## ChainlinkVRFConsumerUpgradeable

### _confirmations

```solidity
uint16 _confirmations
```

### __ChainlinkVRFConsumer_init

```solidity
function __ChainlinkVRFConsumer_init(address coordinator, bytes32 keyHash, uint64 subscriptionId, uint16 confirmations) internal
```

### __ChainlinkVRFConsumer_init_unchained

```solidity
function __ChainlinkVRFConsumer_init_unchained(address coordinator, bytes32 keyHash, uint64 subscriptionId, uint16 confirmations) internal
```

### requestRandomWords

```solidity
function requestRandomWords(uint32 count) internal returns (uint256 requestId)
```

### fulfillRandomWords

```solidity
function fulfillRandomWords(uint256 requestId, uint256[] randomWords) internal virtual
```

fulfillRandomness handles the VRF response. Your contract must
implement it. See "SECURITY CONSIDERATIONS" above for important
principles to keep in mind when implementing your fulfillRandomness
method.

_VRFConsumerBaseV2 expects its subcontracts to have a method with this
signature, and will call it once it has verified the proof
associated with the randomness. (It is triggered via a call to
rawFulfillRandomness, below.)_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| requestId | uint256 | The Id initially returned by requestRandomness |
| randomWords | uint256[] | the VRF output expanded to the requested number of words |

