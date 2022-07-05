// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";

import "../utils/ChainlinkVRFConsumerUpgradeable.sol";
import "./extensions/ERC721EnumerableExtendedUpgradeable.sol";
import "./extensions/ERC721BurnableExtendedUpgradeable.sol";

/**
* @title Cosmic Elves Ticket v2.0.0
* @author @DirtyCajunRice
*/
contract CosmicElvesTicketUpgradeable is Initializable, ERC721Upgradeable, ERC721EnumerableExtendedUpgradeable,
PausableUpgradeable, AccessControlEnumerableUpgradeable, ERC721BurnableExtendedUpgradeable,
ChainlinkVRFConsumerUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using StringsUpgradeable for uint256;

    struct PendingMint {
        uint256[] ids;
        uint256 requestId;
        uint256[] words;
    }

    mapping (address => PendingMint) private _pending;
    mapping (uint256 => address) private _requestIdToAddress;

    CountersUpgradeable.Counter private _tokenIdCounter;

    EnumerableSetUpgradeable.AddressSet private blacklist;

    EnumerableSetUpgradeable.UintSet private percent5;
    EnumerableSetUpgradeable.UintSet private percent10;
    EnumerableSetUpgradeable.UintSet private percent15;
    EnumerableSetUpgradeable.UintSet private percent20;

    IERC20Upgradeable private usdc;

    address public treasury;

    uint256 public price;
    uint256 public cap;

    string public imageBaseURI;

    modifier notBlacklisted(address _address) {
        require(!blacklist.contains(_address), "Blacklisted address");
        _;
    }
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __ERC721_init("ElvesTicket", "ETICKET");
        __ERC721Enumerable_init();
        __Pausable_init();
        __AccessControl_init();
        __ERC721Burnable_init();

        address chainlinkCoordinator = 0xd5D517aBE5cF79B7e95eC98dB0f0277788aFF634;
        bytes32 keyHash = 0x83250c5584ffa93feb6ee082981c5ebe484c865196750b39835ad4f13780435d;
        uint64 subscriptionId = 27;
        uint16 confirmations = 3;

        __ChainlinkVRFConsumer_init(chainlinkCoordinator, keyHash, subscriptionId, confirmations);

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());

        usdc = IERC20Upgradeable(0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E);
        treasury = 0xD2578A0b2631E591890f28499E9E8d73F21e5895;
        price = 10_000_000; // USDC is 6 decimals
        cap = 5000;
        imageBaseURI = "https://images.cosmicuniverse.one/elves-tickets/";

        if (_tokenIdCounter.current() < 871) {
            _tokenIdCounter._value = 871;
        }
    }

    function mint(uint256 count) public whenNotPaused {
        PendingMint storage pending = _pending[_msgSender()];
        require(pending.requestId == 0, "Existing mint in progress");
        require(count <= 500, "Maximum 500 per mint");

        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId < cap, "Sold out");
        require(tokenId + count <= cap, "Insufficient remaining NFTs");

        usdc.transferFrom(_msgSender(), treasury, price * count);

        pending.requestId = requestRandomWords(uint32(count));
        _requestIdToAddress[pending.requestId] = _msgSender();

        for (uint256 i = 0; i < count; i++) {
            _tokenIdCounter.increment();
            pending.ids.push(_tokenIdCounter.current());
        }
    }

    function mint(address to, uint256 id) public whenNotPaused onlyRole(MINTER_ROLE) {
        _safeMint(to, id);
    }

    function batchMint(address to, uint256[] memory ids) public whenNotPaused onlyRole(MINTER_ROLE) {
        for (uint256 i = 0; i < ids.length; i++) {
            _safeMint(to, ids[i]);
        }
    }

    function reveal() public {
        PendingMint storage pending = _pending[_msgSender()];
        require(pending.requestId > 0, "No pending mint");
        require(pending.words.length > 0, "Results still pending");

        for (uint256 i = 0; i < pending.ids.length; i++) {
            uint256 outcome = pending.words[i] % 1000;
            if (outcome >= 990) {
                percent20.add(pending.ids[i]);
                return;
            } else if (outcome >= 950) {
                percent15.add(pending.ids[i]);
                return;
            } else if (outcome >= 750) {
                percent10.add(pending.ids[i]);
                return;
            } else {
                percent5.add(pending.ids[i]);
            }
            _safeMint(_msgSender(), pending.ids[i]);
        }
        delete _requestIdToAddress[pending.requestId];
        delete _pending[_msgSender()];
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

    function tokensAndDiscountsOfOwner(address _address) public view
    returns(uint256[] memory tokens, uint256[] memory discounts) {
        uint256[] memory _tokens = tokensOfOwner(_address);
        uint256[] memory _discounts = batchDiscountOf(_tokens);
        return(_tokens, _discounts);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        uint256 discount = discountOf(tokenId);
        string memory discountStr = string(abi.encodePacked(discount.toString(), '%'));
        string memory imageURI = string(abi.encodePacked(imageBaseURI, discount.toString()));
        string memory oddsOfStr = oddsOf(discount);
        bytes memory dataURIGeneral = abi.encodePacked(
            '"name": "Cosmic Elves Discount Ticket #', tokenId.toString(), '",',
            '"description": "7 day reserve discount ticket valid for 1 Cosmic Elf",',
            '"image": "', imageURI, '",',
            '"animation_url": "', imageURI, '",'
        );
        bytes memory dataURIAttributes = abi.encodePacked(
            '"attributes": [',
                '{',
                    '"trait_type": "discount",',
                    '"value": "',  discountStr, '"',
                '},',
                '{',
                    '"trait_type": "odds",',
                    '"value": "', oddsOfStr, '"',
                '}',
            ']'
        );
        bytes memory dataURI = abi.encodePacked('{', string(dataURIGeneral), string(dataURIAttributes), '}');
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64Upgradeable.encode(dataURI)
            )
        );
    }

    function oddsOf(uint256 chance) internal pure returns(string memory) {
        if (chance == 20) {
            return "1:100";
        } else if (chance == 15) {
            return "1:25";
        } else if (chance == 10) {
            return "1:5";
        } else if (chance == 5) {
            return "3:1";
        }
        return "0:0";
    }

    // Admin

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        _pending[_requestIdToAddress[requestId]].words = randomWords;
    }

    function setTicketPrice(uint256 _price) public onlyRole(ADMIN_ROLE) {
        price = _price;
    }

    function setCap(uint256 _cap) public onlyRole(ADMIN_ROLE) {
        cap = _cap;
    }

    function addBlacklist(address _address) public onlyRole(ADMIN_ROLE) {
        blacklist.add(_address);
    }

    function removeBlacklist(address _address) public onlyRole(ADMIN_ROLE) {
        blacklist.remove(_address);
    }

    function setImageBaseURI(string memory _imageBaseURI) public onlyRole(ADMIN_ROLE) {
        imageBaseURI = _imageBaseURI;
    }

    function setDiscountsOf(uint256[] memory tokenIds, uint256[] memory discounts) public onlyRole(ADMIN_ROLE) {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            if (discounts[i] == 20) {
                percent20.add(tokenIds[i]);
                continue;
            } else if (discounts[i] == 15) {
                percent15.add(tokenIds[i]);
                continue;
            } else if (discounts[i] == 10) {
                percent10.add(tokenIds[i]);
                continue;
            } else {
                percent5.add(tokenIds[i]);
            }
        }
    }
    /**
    * @notice Pause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to stop the execution of
    *      upgradeAll and transferFrom functions
    */
    function pause() external onlyRole(ADMIN_ROLE) {
        _pause();
    }

    /**
    * @notice Unpause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to resume the execution of
    *      upgradeAll and transferFrom functions
    */
    function unpause() external onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    // Overrides

    function _exists(uint256 tokenId) internal view virtual
    override(ERC721Upgradeable, ERC721BurnableExtendedUpgradeable) returns (bool) {
        return super._exists(tokenId);
    }

    function approve(address to, uint256 tokenId) public virtual override notBlacklisted(to) {
        super.approve(to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public virtual override notBlacklisted(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    whenNotPaused
    notBlacklisted(from)
    notBlacklisted(to)
    override(ERC721Upgradeable, ERC721EnumerableExtendedUpgradeable, ERC721BurnableExtendedUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(
        ERC721Upgradeable,
        ERC721BurnableExtendedUpgradeable,
        ERC721EnumerableExtendedUpgradeable,
        AccessControlEnumerableUpgradeable
    )
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}