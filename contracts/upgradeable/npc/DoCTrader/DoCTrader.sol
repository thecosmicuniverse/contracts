// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@dirtycajunrice/contracts/third-party/boba/bridge/IStandardERC1155.sol";
import "@dirtycajunrice/contracts/third-party/boba/bridge/IStandardERC20.sol";
import "@dirtycajunrice/contracts/utils/access/StandardAccessControl.sol";

import { CosmicAddressBookBobaAvax as AddressBook } from "../../utils/AddressBook/AddressBookBobaAvax.sol";
import "../../ERC721/CosmicTools/ICosmicTools.sol";
import "../../common/SharedStructs.sol";
import "../../utils/Multicall.sol";

/**
* @title DoC Trader v1.0.0
* @author @DirtyCajunRice
* @notice NPC contract for Item purchases and resource trading in Dawn of Crypton
*/
contract DoCTrader is Initializable, PausableUpgradeable, StandardAccessControl, UUPSUpgradeable, Multicall {

    /*************
     * Libraries *
     *************/

    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
    using CountersUpgradeable for CountersUpgradeable.Counter;

    /*********
     * Types *
     *********/

    enum TokenType { ERC20, ERC1155, ERC721 }
    enum Location { Treasury, Burn, Mint, Local }

    struct Token {
        TokenType tokenType;
        Location location;
        address _address;
        uint256 id;
        uint256 quantity;
    }

    struct Item {
        Token cost;
        Token details;
    }

    /*************
     * Variables *
     *************/

    // Public

    /// @notice Cosmic Universe Treasury address
    address public treasury;

    // Private

    mapping (uint256 => Item) private _shop;
    EnumerableSetUpgradeable.UintSet private _shopIds;
    CountersUpgradeable.Counter private _nextShopId;

    /****************
     * Initializers *
     ****************/

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Pausable_init();
        __StandardAccessControl_init();
        __UUPSUpgradeable_init();
        __Multicall_init();

        treasury = address(0);
    }

    /**********
     * Public *
     **********/

    /**
     * @notice Trades raw or refined resources at a cost of (`weight` * 24) * (`weight` + 1)**(3 - `rarity`)
     *         for 1 Contribution Token
     * @dev The contract address for the resource is calculated based on `id`
     * @param id TokenID of the resource
     */
    function tradeResource(uint256 id) public whenNotPaused {
        uint256 rarity = id % 5;
        IStandardERC1155 resource = IStandardERC1155(
            isRefinedResourceID(id) ? AddressBook.RefinedResources() : AddressBook.RawResources()
        );
        uint256 weight = resourceWeight(id);
        uint256 cost = (weight * 24) * (weight + 1)**(3 - rarity);
        resource.burn(msg.sender, id, cost);
        IStandardERC1155(AddressBook.Bundles()).mint(msg.sender, 3, 1, "");
    }

    /**
     * @notice Breaks down raw or refined resources at a rate of (`weight` + 1)**(4 - `rarity`) * `quantity`
     *         into `rarity` - 1
     * @dev The contract address for the resource is calculated based on `id`
     * @param id TokenID of the resource
     * @param quantity Amount of resources to break down
     */
    function breakdownResource(uint256 id, uint256 quantity) public whenNotPaused {
        uint256 rarity = id % 5;
        require(rarity != 0, "Trader::Resource is already at the lowest rarity");
        IStandardERC1155 resource = IStandardERC1155(
            isRefinedResourceID(id) ? AddressBook.RefinedResources() : AddressBook.RawResources()
        );
        resource.burn(msg.sender, id, quantity);
        uint256 result = (resourceWeight(id) + 1)**(4 - rarity) * quantity;
        resource.mint(msg.sender, id - 1, result, "");
    }

    /**
     * @notice Purchase an Item from the Trader defined by `id`
     * @param id ID of the item in the Trader's shop
     */
    function buyItem(uint256 id) public whenNotPaused {
        require(_shopIds.contains(id), "Trader::Invalid item option");
        Item memory item = _shop[id];

        // Handle the cost
        if (item.cost.tokenType == TokenType.ERC20) {
            IStandardERC20 token = IStandardERC20(item.cost._address);
            if (item.cost.location == Location.Burn) {
                token.burn(msg.sender, item.cost.quantity);
            } else if (item.cost.location == Location.Treasury) {
                token.transferFrom(msg.sender, treasury, item.cost.quantity);
            } else {
                revert("Trader::Invalid item cost location");
            }
        } else if (item.cost.tokenType == TokenType.ERC1155) {
            IStandardERC1155 token = IStandardERC1155(item.cost._address);
            if (item.cost.location == Location.Burn) {
                token.burn(msg.sender, item.cost.id, item.cost.quantity);
            } else if (item.cost.location == Location.Treasury) {
                token.safeTransferFrom(msg.sender, treasury, item.cost.id, item.cost.quantity, "");
            } else {
                revert("Trader::Invalid item cost location");
            }
        } else {
            // No 721 item options yet
            revert("Trader::Invalid item cost type");
        }

        // Handle the item
        if (item.details.tokenType == TokenType.ERC20) {
            IStandardERC20 token = IStandardERC20(item.details._address);
            if (item.details.location == Location.Mint) {
                token.mint(msg.sender, item.details.quantity, "");
            } else if (item.details.location == Location.Treasury) {
                token.transferFrom(treasury, msg.sender, item.details.quantity);
            } else if (item.details.location == Location.Local) {
                token.transferFrom(address(this), msg.sender, item.details.quantity);
            } else {
                revert("Trader::Invalid item details location");
            }
        } else if (item.details.tokenType == TokenType.ERC1155) {
            IStandardERC1155 token = IStandardERC1155(item.details._address);
            if (item.details.location == Location.Mint) {
                token.mint(msg.sender, item.details.id, item.details.quantity, "");
            } else if (item.details.location == Location.Treasury) {
                token.safeTransferFrom(treasury, msg.sender, item.details.id, item.details.quantity, "");
            } else if (item.details.location == Location.Local) {
                token.safeTransferFrom(address(this), msg.sender, item.details.id, item.details.quantity, "");
            } else {
                revert("Trader::Invalid item details location");
            }
        } else {
            // No  721 item options yet
            revert("Trader::Invalid item details type");
        }
    }

    /**
     * @notice Purchase a common rarity tool for `professionId`
     * @param professionId ID of the profession
     */
    function buyTool(uint256 professionId) public whenNotPaused {
        IStandardERC20(AddressBook.MAGIC()).transferFrom(msg.sender, treasury, 250 ether);
        ICosmicTools(AddressBook.Tools()).mint(
            msg.sender,
            abi.encode(ICosmicTools.Tool(professionId, 0, SharedStructs.Rarity.Common))
        );
    }


    /********
     * Read *
     ********/

    /**
     * @notice Read an item available from the Trader
     * @param id ID of the item in the Trader's shop
     * @return item Item definition
     */
    function shopItem(uint256 id) public view returns (Item memory item) {
        require(_shopIds.contains(id), "Trader::Non-existent id");
        return _shop[id];
    }

    /**
     * @notice Read all items available from the Trader
     * @return ids Array of item ids
     * @return items Array of items
     */
    function shopItems() public view returns (uint256[] memory ids, Item[] memory items) {
        ids = _shopIds.values();
        items = new Item[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            items[i] = _shop[ids[i]];
        }
    }


    /************
     * Internal *
     ************/

    function resourceWeight(uint256 id) internal pure returns (uint256) {
        // Herbalism ? 4 : (Mining/tailoring) ? 3 : (Farming/Fishing || Woodcutting) ? 1 : 2;
        return (id >=120 && id < 135)
            ? 4
            : (id >=120 && id < 150)
                ? 3
                : ((id >=75 && id < 105) || (id >= 165 && id < 180))
                    ? 1
                    : 2;
    }

    function isRefinedResourceID(uint256 id) internal pure returns (bool) {
        return id < 60 || (id >= 105 && id < 120) || (id >= 150 && id < 165);
    }


    /*********
     * Admin *
     *********/

    /**
     * @notice Set the address of the Treasury
     * @param _treasury Treasury address
     */
    function setTreasury(address _treasury) external onlyAdmin {
        require(_treasury != address(0) && _treasury != treasury, "Trader::Invalid treasury address");
        treasury = _treasury;
    }

    /**
     * @notice Add an item to the Trader's shop
     * @param _item Shop Item definition
     */
    function addShopItem(Item memory _item) public onlyAdmin {
        uint256 id = _nextShopId.current();
        _nextShopId.increment();
        _shopIds.add(id);
        updateShopItem(id, _item);
    }

    /**
     * @notice Remove an item from the Trader's shop
     * @param id ID of the item
     */
    function removeShopItem(uint256 id) public onlyAdmin {
        require(_shopIds.contains(id), "Trader::Non-existent item id");
        _shopIds.remove(id);
        delete _shop[id];
    }

    /**
     * @notice Update an item in the Trader's shop
     * @param id ID of the item
     * @param _item Shop Item definition
     */
    function updateShopItem(uint256 id, Item memory _item) public onlyAdmin {
        require(_shopIds.contains(id), "Trader::Non-existent item id");
        _shop[id] = Item({
            cost: Token({
            tokenType: _item.cost.tokenType,
            location: _item.cost.location,
            _address: _item.cost._address,
            id: _item.cost.id,
            quantity: _item.cost.quantity
            }),
        details: Token({
            tokenType: _item.details.tokenType,
            location: _item.details.location,
            _address: _item.details._address,
            id: _item.details.id,
            quantity: _item.details.quantity
            })
        });
    }

    /*************
     * Overrides *
     *************/

    // @inheritdoc
    function _authorizeUpgrade(address newImplementation) internal virtual override onlyAdmin {}
}