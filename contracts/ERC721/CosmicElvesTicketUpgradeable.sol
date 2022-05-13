// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
/**
* @title Cosmic Elves Ticket v1.0.0
* @author @DirtyCajunRice
*/
contract CosmicElvesTicket is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721URIStorageUpgradeable, PausableUpgradeable, AccessControlUpgradeable, ERC721BurnableUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    struct Weights {
        uint256 percent5;
        uint256 percent10;
        uint256 percent15;
        uint256 percent20;
    }

    Weights private _weights;

    CountersUpgradeable.Counter private _tokenIdCounter;

    EnumerableSetUpgradeable.UintSet private percent5;
    EnumerableSetUpgradeable.UintSet private percent10;
    EnumerableSetUpgradeable.UintSet private percent15;
    EnumerableSetUpgradeable.UintSet private percent20;

    uint256 public ticketPrice;
    uint256 public startTime;
    uint256 public totalTickets;

    string public baseURI;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC721_init("CosmicElvesTicket", "CET");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Pausable_init();
        __AccessControl_init();
        __ERC721Burnable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);

        if (_tokenIdCounter.current() == 0) {
            _tokenIdCounter.increment();
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return baseURI;
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function mint(address to) public {
        safeMint(to, 0);
    }

    function batchMint(address to, uint256 amount) public {
        for (uint256 i = 0; i < amount; i++) {
            mint(to);
        }
    }

    function safeMint(address to, uint256 discount) internal {
        uint256 tokenId = _tokenIdCounter.current();
        require(startTime >= block.timestamp, "Mint has not started yet");
        require(tokenId < totalTickets, "Sold out");

        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        if (discount == 5) {
            percent5.add(tokenId);
        } else if (discount == 10) {
            percent10.add(tokenId);
        } else if (discount == 15) {
            percent15.add(tokenId);
        } else if (discount == 20) {
            percent20.add(tokenId);
        } else {
            revert("Invalid discount");
        }
    }

    function discountOf(uint256 tokenId) public view returns(uint256 discount) {
        require(super._exists(tokenId), "Discount query for nonexistent token");
        if (percent5.contains(tokenId)) {
            return 5;
        } else if (percent10.contains(tokenId)) {
            return 10;
        } else if (percent15.contains(tokenId)) {
            return 15;
        } else if (percent20.contains(tokenId)) {
            return 20;
        }
        return 0;
    }

    function batchDiscountOf(uint256[] memory tokenIds) public view returns(uint256[] memory) {
        uint256[] memory discounts = new uint256[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            discounts[i] = discountOf(tokenIds[i]);
        }
        return discounts;
    }

    function tokensOfOwner(address _address) public view returns(uint256[] memory) {
        uint256 total = super.balanceOf(_address);
        uint256[] memory tokens = new uint256[](total);
        for (uint256 i = 0; i < total; i++) {
            tokens[i] = tokenOfOwnerByIndex(i);
        }
        return tokens;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(super._exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory baseURI = _baseURI();
        uint256 discount = discountOf(tokenId);
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, discount.toString())) : "";
    }

    // Admin

    function setBaseURI(string memory baseUri) public onlyRole(DEFAULT_ADMIN_ROLE) {
        baseURI = baseURI;
    }

    function setWeights(uint256 _p5, uint256 _p10, uint256 _p15, uint256 _p20) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _weights.percent5 = _p5;
        _weights.percent5 = _p10;
        _weights.percent5 = _p15;
        _weights.percent5 = _p20;
    }

    function setStartTime(uint256 time) public onlyRole(DEFAULT_ADMIN_ROLE) {
        startTime = time;
    }

    function setTicketPrice(uint256 price) public onlyRole(DEFAULT_ADMIN_ROLE) {
        ticketPrice = price;
    }

    function setTotalTickets(uint256 total) public onlyRole(DEFAULT_ADMIN_ROLE) {
        totalTickets = total;
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }
    // Overrides

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    whenNotPaused
    override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
    internal
    override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721Upgradeable, ERC721EnumerableUpgradeable, AccessControlUpgradeable)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}