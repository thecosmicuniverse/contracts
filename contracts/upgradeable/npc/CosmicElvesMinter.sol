// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableMapUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

import "../utils/ChainlinkVRFConsumerUpgradeable.sol";
import "../ERC721/interfaces/ICosmicElvesTicket.sol";
import "../ERC721/interfaces/ICosmicElves.sol";
import "../ERC20/interfaces/IlMagic.sol";
import "../utils/Blacklistable.sol";

/**
* @title Cosmic Elves Minter v1.0.0
* @author @DirtyCajunRice
*/
contract CosmicElvesMinter is Initializable, PausableUpgradeable, AccessControlEnumerableUpgradeable,
ChainlinkVRFConsumerUpgradeable, Blacklistable {
    // libraries
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using EnumerableMapUpgradeable for EnumerableMapUpgradeable.AddressToUintMap;

    // constants
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");

    ICosmicElves public constant ELVES = ICosmicElves(0x9a337A6F883De95f49e05CD7D801d475a40a9C70);
    ICosmicElvesTicket public constant ETICKET = ICosmicElvesTicket(0x87D0F9ff4B51EEfe9f5f1578bc35e4ddA28bBd1e);
    IERC20Upgradeable public constant USDC = IERC20Upgradeable(0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E);
    IlMagic private constant LMAGIC = IlMagic(0x8EebaCaBD19B84AAe85821e9ffa5452b096e769D);

    // enums/structs
    struct PendingMint {
        uint256[] ids;
        uint256 requestId;
        uint256[] words;
    }
    // public vars
    uint256 public startTime;
    uint256 public cap;
    uint256 private unused;

    address public treasury;
    // private vars
    mapping (address => PendingMint) private _pending;
    mapping (uint256 => address) private _requestIdToAddress;
    mapping (address => uint256) private _mintCount;
    // gender => attribute => weights
    mapping (uint256 => mapping(uint256 => uint256[])) private _weights;

    EnumerableSetUpgradeable.AddressSet private _bonusEligible;

    uint256 public price;
    uint256 private USDCSpent;
    uint256 private lMAGICBurned;

    uint256 private totalElvesTickets;
    uint256 private elvesTicketsRedeemed;

    CountersUpgradeable.Counter private _counter;

    bytes32 public constant TEAM_ROLE = keccak256("TEAM_ROLE");

    EnumerableMapUpgradeable.AddressToUintMap private _credits;

    modifier gated() {
        require(
          block.timestamp >= startTime ||
          hasRole(ADMIN_ROLE, _msgSender()) ||
          hasRole(TEAM_ROLE, _msgSender())
          , "Mint has not started");
        _;
    }

    event creditsAdded(address indexed from, address indexed to, uint256 amount);
    event creditsUsed(address indexed from, uint256 amount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Pausable_init();
        __AccessControlEnumerable_init();

        address chainlinkCoordinator = 0xd5D517aBE5cF79B7e95eC98dB0f0277788aFF634;
        bytes32 keyHash = 0x83250c5584ffa93feb6ee082981c5ebe484c865196750b39835ad4f13780435d;
        uint64 subscriptionId = 27;
        uint16 confirmations = 3;

        __ChainlinkVRFConsumer_init(chainlinkCoordinator, keyHash, subscriptionId, confirmations);

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(CONTRACT_ROLE, _msgSender());

        startTime = 1661641200;
        treasury = 0xD2578A0b2631E591890f28499E9E8d73F21e5895;
        price = 250_000_000; // USDC is 6 decimals
        unused = 1_000_000 ether; // Overly high number to ensure it is set by automation
        cap = 10_000;

        totalElvesTickets = ETICKET.lastTokenId();
    }

    function buy(uint256 count, uint256[] memory tickets) public whenNotPaused gated {
        // get pending mint reference from storage
        PendingMint storage pending = _pending[_msgSender()];
        // pre-flight checks
        require(pending.requestId == 0, "Existing mint in progress");
        require(count > 0, "Minimum 1 per mint");
        require(count <= 50, "Maximum 50 per mint");
        require(tickets.length <= count, "Ticket count cannot exceed mint count");
        // cap checks
        uint256 tokenId = _counter.current();
        require(tokenId < cap, "Sold out");
        require(tokenId + count <= cap, "Insufficient remaining NFTs");
        // uint256 reserved = block.timestamp > (startTime + 7 days) ? 0 : totalElvesTickets - elvesTicketsRedeemed;
        require((cap + tickets.length - tokenId) >= count, "Insufficient unreserved NFTs remaining");

        // calculate total cost after discounts, if any
        uint256 totalCost = 0;
        uint256[] memory discounts = ETICKET.batchDiscountOf(tickets);
        for (uint256 i = 0; i < discounts.length; i++) {
            ETICKET.burn(tickets[i]);
            totalCost += price - (discounts[i] * price / 100);
        }

        elvesTicketsRedeemed += discounts.length;

        // add any/all full-price mints
        if (count > tickets.length) {
            totalCost += price * (count - tickets.length);
        }

        // use credit, if any
        uint256 credit = creditOf(msg.sender);
        if (credit >= totalCost) {
            totalCost = 0;
            _credits.set(msg.sender, credit - totalCost);
            emit creditsUsed(msg.sender, totalCost);
        } else if (credit < totalCost && credit > 0) {
            totalCost -= credit;
            _credits.remove(msg.sender);
            emit creditsUsed(msg.sender, credit);
        }

        // handle relative token transfers
        if (totalCost > 0) {
            USDC.transferFrom(msg.sender, treasury, totalCost);
            USDCSpent += totalCost;
        }

        // track mint count per wallet for elf island bonus
        _mintCount[_msgSender()] += count;
        if (_mintCount[_msgSender()] >= 3) {
            _bonusEligible.add(_msgSender());
        }

        // request randomness from chainlink
        pending.requestId = requestRandomWords(uint32(count));
        _requestIdToAddress[pending.requestId] = _msgSender();

        // store purchased token ids for mint
        for (uint256 i = 0; i < count; i++) {
            _counter.increment();
            pending.ids.push(_counter.current());
        }
    }

    function adminRequest(uint256 count) public whenNotPaused onlyRole(ADMIN_ROLE) {
        // get pending mint reference from storage
        PendingMint storage pending = _pending[msg.sender];
        // pre-flight checks
        require(pending.requestId == 0, "Existing mint in progress");
        require(count > 0, "Minimum 1 per mint");
        require(count <= 50, "Maximum 50 per mint");
        // cap checks
        uint256 tokenId = _counter.current();
        require(tokenId < cap, "Sold out");
        require(tokenId + count <= cap, "Insufficient remaining NFTs");

        // track mint count per wallet for elf island bonus
        _mintCount[msg.sender] += count;
        if (_mintCount[msg.sender] >= 3) {
            _bonusEligible.add(msg.sender);
        }

        // request randomness from chainlink
        pending.requestId = requestRandomWords(uint32(count));
        _requestIdToAddress[pending.requestId] = msg.sender;

        // store purchased token ids for mint
        for (uint256 i = 0; i < count; i++) {
            _counter.increment();
            pending.ids.push(_counter.current());
        }
    }

    function mint(uint256 count) public {
        // get pending mint reference from storage
        PendingMint storage pending = _pending[_msgSender()];
        // pre-flight checks
        require(pending.requestId > 0, "No pending mint");
        require(pending.words.length > 0, "Results still pending");
        require(pending.ids.length <= count, "Invalid mint count");

        uint256 remainingCount = 0;
        uint256[] memory remainingIds;
        uint256[] memory remainingWords;

        uint256[] memory dynamicIds = new uint256[](11);
        for (uint256 i = 0; i < 11; i++) {
            dynamicIds[i] = i;
        }

        for (uint256 i = 0; i < pending.ids.length; i++) {
            uint256 tokenId = pending.ids[i];
            if (i >= count) {
                remainingIds[remainingCount] = tokenId;
                remainingWords[remainingCount] = pending.words[i];
                remainingCount++;
                continue;
            }
            uint256[] memory randomChunks = chunkWord(pending.words[i], 10_000, 11);
            uint256[] memory attributes = _getAttributes(randomChunks);
            ELVES.mint(_msgSender(), tokenId);
            ELVES.batchUpdateSkillsOfToken(tokenId, 0, dynamicIds, attributes);
        }

        if (remainingIds.length > 0) {
            pending.ids = remainingIds;
            pending.words = remainingWords;
        } else {
            delete _requestIdToAddress[pending.requestId];
            delete _pending[_msgSender()];
        }
    }

    function _getAttributes(uint256[] memory randomChunks) internal view returns (uint256[] memory) {
        uint256[] memory attributes = new uint256[](11);
        uint256 gender = _attributeRoll(_weights[0][0], randomChunks[0]);
        attributes[0] = gender;
        for (uint256 i = 1; i < 11; i++) {
            attributes[i] = _attributeRoll(_weights[gender][i], randomChunks[i]);
        }

        return attributes;
    }

    function _attributeRoll(uint256[] memory weights, uint256 roll) internal pure returns (uint256) {
        for (uint256 i = 0; i < weights.length; i++) {
            if (roll < weights[i]) {
                return i - 1;
            }
        }
        return weights.length - 1;
    }

    function setAttributeWeights(uint256 gender, uint256 attribute, uint256[] memory weights) public onlyRole(ADMIN_ROLE) {
        _weights[gender][attribute] = new uint256[](weights.length);
        uint256[] storage attrWeights = _weights[gender][attribute];
        for (uint256 i = 0; i < weights.length; i++) {
            attrWeights[i] = weights[i];
        }
    }

    function setAttributesWeights(uint256 gender, uint256[] memory attributes, uint256[][] memory weights) public onlyRole(ADMIN_ROLE) {
        for (uint256 i = 0; i < attributes.length; i++) {
            setAttributeWeights(gender, attributes[i], weights[i]);
        }
    }

    function setTotalElvesTickets(uint256 total) public onlyRole(ADMIN_ROLE) {
        totalElvesTickets = total;
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        _pending[_requestIdToAddress[requestId]].words = randomWords;
    }

    function pendingMintsOf(address user) public view returns(uint256[] memory, bool) {
        return (_pending[user].ids, _pending[user].words.length > 0);
    }

    function lastTokenId() public view returns(uint256) {
        return _counter.current();
    }

    function creditOf(address account) public view returns (uint256) {
        (bool exists, uint256 credits) = _credits.tryGet(account);
        if (exists) {
            return credits;
        }
        return 0;
    }

    function addCredit(address[] memory accounts, uint256[] memory amounts) external onlyRole(ADMIN_ROLE) {
        require(accounts.length > 0, "ElvesMinter::No accounts specified");
        require(accounts.length == amounts.length, "ElvesMinter::Array length mismatch");
        for (uint256 i = 0; i < accounts.length; i++) {
            uint256 credits = creditOf(accounts[i]) + amounts[i];
            _credits.set(accounts[i], credits);
            emit creditsAdded(msg.sender, accounts[i], amounts[i]);
        }
    }

    function setPrice(uint256 _price) external onlyRole(ADMIN_ROLE) {
        price = _price;
    }
}