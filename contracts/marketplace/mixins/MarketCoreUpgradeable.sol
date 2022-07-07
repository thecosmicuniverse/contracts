// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

import "./MarketContractWhitelistUpgradeable.sol";
import "./MarketFundDistributorUpgradeable.sol";
import "../libraries/ArrayCheckUpgradeable.sol";
import "./AuctionConfigUpgradeable.sol";
import "./MarketCounterUpgradable.sol";


abstract contract MarketCoreUpgradeable is
    Initializable,
    AccessControlEnumerableUpgradeable,
    ReentrancyGuardUpgradeable,
    MarketCounterUpgradable,
    MarketContractWhitelistUpgradeable,
    MarketFundDistributorUpgradeable,
    AuctionConfigUpgradeable
{
    using SafeMathUpgradeable for uint256;
    using ArrayCheckUpgradeable for uint256[];
    using AddressUpgradeable for address;
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    enum SaleType {
        AUCTION,
        FIXED,
        OFFER
    }

    enum TokenType {
        ERC721,
        ERC1155
    }

    struct Sale {
        SaleType saleType;
        address seller;
        address contractAddress;
        TokenType tokenType;
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

    mapping(uint256 => Sale) public saleIdToSale;

    EnumerableSetUpgradeable.UintSet private _activeSaleIds;

    event SaleCreated(
        uint256 indexed saleId,
        SaleType saleType,
        address indexed seller,
        address indexed contractAddress,
        uint256[] tokenIds,
        uint256[] values,
        address bidToken,
        uint256 startTime,
        uint256 duration,
        uint256 extensionDuration,
        uint256 endTime,
        uint256 minPrice
    );

    event SaleCanceled(
        uint256 indexed saleId,
        string reason
    );

    event BidPlaced(
        uint256 indexed saleId,
        address bidder,
        uint256 bidAbount,
        uint256 endTime
    );

    event AuctionFinalized(
        uint256 indexed saleId,
        address indexed seller,
        address indexed bidder,
        uint256 royalty,
        uint256 marketFee,
        uint256 ownerRev
    );

    event FixedPriceFinalized(
        uint256 indexed saleId,
        address indexed seller,
        address indexed buyer,
        uint256 royalty,
        uint256 marketFee,
        uint256 ownerRev
    );

    event OfferFinalized(
        uint256 indexed saleId,
        address indexed seller,
        address indexed buyer,
        uint256 royalty,
        uint256 marketFee,
        uint256 ownerRev
    );

    function __MarketCore_init(
        uint256 maxRoyaltyBps, uint256 marketFeeBps, address treasury, uint256 nexBidPercentBps
    ) internal onlyInitializing {
        __AccessControlEnumerable_init();
        __ReentrancyGuard_init();
        __MarketContractWhitelist_init();
        __MarketFundDistributor_int(maxRoyaltyBps, marketFeeBps, treasury);
        __AuctionConfig_init(nexBidPercentBps);

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(AUTHORIZED_ROLE, _msgSender());
    }

    function _transferAssets(
        TokenType tokenType, address contractAddress, address from, address to, uint256[] memory tokenIds, uint256[] memory values
    ) private {
        if (tokenType == TokenType.ERC1155) {
            IERC1155Upgradeable(contractAddress).safeBatchTransferFrom(from, to, tokenIds, values, "");
        } else if (tokenType == TokenType.ERC721) {
            IERC721Upgradeable asset = IERC721Upgradeable(contractAddress);
            for (uint256 i = 0; i < tokenIds.length; ++i) {
                asset.transferFrom(from, to, tokenIds[i]);
            }
        }
    }

    function _makeSaleInfo(
        SaleType saleType, address contractAddress, TokenType tokenType, uint256[] memory tokenIds, uint256[] memory values, address bidToken,
        uint256 startTime, uint256 duration, uint256 minPrice
    ) internal view returns (Sale memory) {
        require(tokenIds.length > 0, "MarketCoreUpgradeable: Invalid tokenIds length");
        require(tokenIds.length == values.length, "MarketCoreUpgradeable: TokenIds length dont match");
        require(isValidBidToken(contractAddress, bidToken), "MarketCoreUpgradeable: Invalid bid token");
        require(values.checkgte(1), "MarketCoreUpgradeable: Invalid value");
        require(startTime >= block.timestamp, "MarketCoreUpgradeable: Invalid satrtTime");
        require(duration > 0, "MarketCoreUpgradeable: Invalid duration");
        require(minPrice >= 0, "MarketCoreUpgradeable: Invalid minPrice");

        return Sale(
            saleType,
            _msgSender(),
            contractAddress,
            tokenType,
            tokenIds,
            values,
            bidToken,
            startTime,
            duration,
            EXTENSION_DURATION,
            startTime + duration,
            address(0),
            minPrice
        );
    }

    function _createSale(
        Sale memory sale, uint256 royaltyBps
    ) internal {
        if (royaltyBps > 0) {
            setRoyaltyFor(_msgSender(), sale.contractAddress, sale.tokenIds[0], royaltyBps);
        }

        uint256 saleId = _getSaleId();
        saleIdToSale[saleId] = sale;
        _activeSaleIds.add(saleId);

        _transferAssets(sale.tokenType, sale.contractAddress, _msgSender(), address(this), sale.tokenIds, sale.values);

        emit SaleCreated(
            saleId,
            sale.saleType,
            sale.seller,
            sale.contractAddress,
            sale.tokenIds,
            sale.values,
            sale.bidToken,
            sale.startTime,
            sale.duration,
            EXTENSION_DURATION,
            sale.startTime + sale.duration,
            sale.bidAmount            
        );
    }

    function cancelSale(uint256 saleId, string memory reason) external nonReentrant {
        require(bytes(reason).length > 0, "MarketCoreUpgradeable: Include a reason for this cancellation");

        Sale memory sale = saleIdToSale[saleId];

        require(sale.seller == _msgSender(), "MarketCoreUpgradeable: Not your sale");

        delete saleIdToSale[saleId];
        _activeSaleIds.remove(saleId);

        _transferAssets(sale.tokenType, sale.contractAddress, address(this), sale.seller, sale.tokenIds, sale.values);
        if (sale.bidder != address(0)) {
            IERC20Upgradeable(sale.bidToken).safeTransfer(sale.bidder, sale.bidAmount);
        }

        emit SaleCanceled(saleId, reason);
    }

    function cancelSaleByAdmin(uint256 saleId, string memory reason) external nonReentrant onlyRole(ADMIN_ROLE) {
        require(bytes(reason).length > 0, "MarketCoreUpgradeable: Include a reason for this cancellation");

        Sale memory sale = saleIdToSale[saleId];

        require(sale.endTime > 0, "MarketCoreUpgradeable: Sale not found");

        delete saleIdToSale[saleId];
        _activeSaleIds.remove(saleId);

        _transferAssets(sale.tokenType, sale.contractAddress, address(this), sale.seller, sale.tokenIds, sale.values);
        if (sale.bidder != address(0)) {
            IERC20Upgradeable(sale.bidToken).safeTransfer(sale.bidder, sale.bidAmount);
        }

        emit SaleCanceled(saleId, reason);
    }

    function getAuctionMinBidAmount(uint256 saleId) external view returns (uint256) {
        Sale storage sale = saleIdToSale[saleId];
        if (sale.bidder == address(0)) {
            return sale.bidAmount;
        }
        return _getNextBidAmount(sale.bidAmount);
    }

    function bidAuction(uint256 saleId, uint256 bidAmount) external nonReentrant {
        Sale storage sale = saleIdToSale[saleId];
    
        require(sale.saleType == SaleType.AUCTION, "MarketCoreUpgradeable: Not Auction");
        require(sale.endTime > block.timestamp, "MarketCoreUpgradeable: Sale is over");
        require(sale.startTime <= block.timestamp, "MarketCoreUpgradeable: Sale not started");
        require(sale.bidder != _msgSender(), "MarketCoreUpgradeable: You already are current bidder");
        require(sale.seller != _msgSender(), "MarketCoreUpgradeable: Self bid");

        if (sale.bidder == address(0)) {
            require(sale.bidAmount <= bidAmount, "MarketCoreUpgradeable: Bid amount too low");
        } else {
            uint256 minAmount = _getNextBidAmount(sale.bidAmount);
            require(bidAmount >= minAmount, "MarketCoreUpgradeable: Bid amount too low");
        }

        uint256 prevBidAmount = sale.bidAmount;
        address prevBidder = sale.bidder;
        sale.bidAmount = bidAmount;
        sale.bidder = _msgSender();

        if (sale.endTime - block.timestamp < sale.extensionDuration) {
            sale.endTime = block.timestamp + sale.extensionDuration;
        }

        IERC20Upgradeable bidToken = IERC20Upgradeable(sale.bidToken);
        bidToken.safeTransferFrom(_msgSender(), address(this), bidAmount);
        if (prevBidder != address(0)){
            bidToken.safeTransfer(prevBidder, prevBidAmount);
        }

        emit BidPlaced(saleId, _msgSender(), bidAmount, sale.endTime);
    }

    function finalizeAuction(uint256 saleId) external nonReentrant {
        Sale memory sale = saleIdToSale[saleId];

        require(sale.endTime > 0, "MarketCoreUpgradeable: Auction not found");
        require(sale.endTime < block.timestamp, "MarketCoreUpgradeable: Auction still in progress");

        delete saleIdToSale[saleId];
        _activeSaleIds.remove(saleId);

        _transferAssets(sale.tokenType, sale.contractAddress, address(this), sale.bidder, sale.tokenIds, sale.values);

        (uint256 royalty, uint256 marketFee, uint256 sellerRev) = _distributeFunds(
            sale.contractAddress, sale.tokenIds[0], sale.bidToken, sale.seller, sale.bidAmount
        );

        emit AuctionFinalized(saleId, sale.seller, sale.bidder, royalty, marketFee, sellerRev);
    }

    function buyFixedPrice(uint256 saleId, uint256 buyAmount) external nonReentrant {
        Sale memory sale = saleIdToSale[saleId];
    
        require(sale.saleType == SaleType.FIXED, "MarketCoreUpgradeable: Not Fixed-price");
        require(sale.endTime >= block.timestamp, "MarketCoreUpgradeable: Sale is over");
        require(sale.startTime <= block.timestamp, "MarketCoreUpgradeable: Sale not started");
        require(sale.bidAmount == buyAmount, "MarketCoreUpgradeable: Wrong buy amount");
        require(sale.seller != _msgSender(), "MarketCoreUpgradeable: Self buy");

        delete saleIdToSale[saleId];
        _activeSaleIds.remove(saleId);

        address from = _msgSender(); 

        IERC20Upgradeable(sale.bidToken).safeTransferFrom(_msgSender(), address(this), sale.bidAmount);
        _transferAssets(sale.tokenType, sale.contractAddress, address(this), from, sale.tokenIds, sale.values);

        (uint256 royalty, uint256 marketFee, uint256 sellerRev) = _distributeFunds(
            sale.contractAddress, sale.tokenIds[0], sale.bidToken, sale.seller, sale.bidAmount
        );

        emit FixedPriceFinalized(saleId, sale.seller, from, royalty, marketFee, sellerRev);
    }

    function _checkSelfOffer(address contractAddress, uint256[] memory tokenIds) private view returns (bool) {
        if  (_msgSender() == IERC721Upgradeable(contractAddress).ownerOf(tokenIds[0])) {
            return false;
        }
        return true;
    }

    function _makeOfferInfo(
        address contractAddress, TokenType tokenType, uint256[] memory tokenIds, uint256[] memory values, address bidToken,
        uint256 duration, uint256 price
    ) internal view returns (Sale memory) {
        require(tokenIds.length > 0, "MarketCoreUpgradeable: Invalid tokenIds length");
        require(tokenIds.length == values.length, "MarketCoreUpgradeable: TokenIds length dont match");
        require(isValidBidToken(contractAddress, bidToken), "MarketCoreUpgradeable: Invalid bid token");
        require(values.checkgte(1), "MarketCoreUpgradeable: Invalid value");
        require(duration > 0, "MarketCoreUpgradeable: Invalid duration");
        require(price >= 0, "MarketCoreUpgradeable: Invalid price");
        require(_checkSelfOffer(contractAddress, tokenIds), "MarketCoreUpgradeable: Self offer");

        uint256 startTime = block.timestamp;
        return Sale(
            SaleType.OFFER,
            address(0),
            contractAddress,
            tokenType,
            tokenIds,
            values,
            bidToken,
            startTime,
            duration,
            EXTENSION_DURATION,
            startTime + duration,
            _msgSender(),
            price
        );
    }

    function _createOffer(
        Sale memory sale
    ) internal {
        uint256 saleId = _getSaleId();
        saleIdToSale[saleId] = sale;

        IERC20Upgradeable IbidToken = IERC20Upgradeable(sale.bidToken);
        IbidToken.safeTransferFrom(_msgSender(), address(this), sale.bidAmount);

        emit SaleCreated(
            saleId,
            SaleType.OFFER,
            sale.bidder, // Offerer instead of seller to index it properly
            sale.contractAddress,
            sale.tokenIds,
            sale.values,
            sale.bidToken,
            sale.startTime,
            sale.duration,
            EXTENSION_DURATION,
            sale.startTime + sale.duration,
            sale.bidAmount
        );
    }

    function cancelOffer(uint256 saleId) external nonReentrant {
        Sale memory sale = saleIdToSale[saleId];
    
        require(sale.saleType == SaleType.OFFER, "MarketCoreUpgradeable: Not offer");
        require(sale.bidder == _msgSender(), "MarketCoreUpgradeable: Not your offer");

        delete saleIdToSale[saleId];
        _activeSaleIds.remove(saleId);

        IERC20Upgradeable(sale.bidToken).safeTransfer(sale.bidder, sale.bidAmount);

        emit SaleCanceled(saleId, "");
    }

    function acceptOffer(uint256 saleId) external nonReentrant {
        Sale memory sale = saleIdToSale[saleId];

        require(sale.saleType == SaleType.OFFER, "MarketCoreUpgradeable: Not offer.");
        require(sale.endTime <= block.timestamp, "MarketCoreUpgradeable: Offer is over");
        
        delete saleIdToSale[saleId];
        _activeSaleIds.remove(saleId);

        _transferAssets(sale.tokenType, sale.contractAddress, _msgSender(), sale.bidder, sale.tokenIds, sale.values);

        (uint256 royalty, uint256 marketFee, uint256 sellerRev) = _distributeFunds(
            sale.contractAddress, sale.tokenIds[0], sale.bidToken, _msgSender(), sale.bidAmount
        );

        emit OfferFinalized(saleId, sale.seller, sale.bidder, royalty, marketFee, sellerRev);
    }

    function activeSaleIds() public view returns (uint256[] memory) {
        return _activeSaleIds.values();
    }

    uint256[1000] private ______gap;
}