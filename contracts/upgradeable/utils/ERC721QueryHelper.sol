// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../../marketplace/MarketUpgradeable.sol";

contract ERC721QueryHelper is Initializable {
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
        address bidToken;
        uint256 startTime;
        uint256 duration;
        uint256 extensionDuration;
        uint256 endTime;
        address bidder;
        uint256 bidAmount;
    }
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {}

    function tokensOfOwner(address token, address owner) public view returns(uint256[] memory) {
        IERC721EnumerableUpgradeable t = IERC721EnumerableUpgradeable(token);
        uint256 count = t.balanceOf(owner);
        uint256[] memory tokenIds = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            tokenIds[i] = t.tokenOfOwnerByIndex(owner, i);
        }
        return tokenIds;
    }

    function getActiveSales() public view returns(uint256[] memory, Sale[] memory) {
        uint256[] memory saleIds;
        Sale[] memory sales;
        uint256 count = 0;
        for (uint256 i = 5000; i < 5500; i++) {
            Sale memory sale = getSalePart1(i);
            Sale memory sale2 = getSalePart2(i);
            sale.extensionDuration = sale2.extensionDuration;
            sale.endTime = sale2.endTime;
            sale.bidder = sale2.bidder;
            sale.bidAmount = sale2.bidAmount;
            if (sale.contractAddress != address(0)) {
                saleIds[count] = i;
                sales[count] = sale;
                count++;
            }
        }
        return (saleIds, sales);
    }

    function getSalePart1(uint256 i) internal view returns(Sale memory) {
        MarketUpgradeable market = MarketUpgradeable(0xC8cEdDf1b1592B3ef5646aF733F14d8fF51a2656);
        Sale memory sale;
        MarketUpgradeable.SaleType saleType;
        address seller;
        address contractAddress;
        MarketUpgradeable.TokenType tokenType;
        address bidToken;
        uint256 startTime;
        uint256 duration;
        (saleType,seller,contractAddress,tokenType,bidToken,startTime,duration,,,,) = market.saleIdToSale(i);
        //sale.saleType = SaleType(saleType);
        sale.seller = seller;
        sale.contractAddress = contractAddress;
        sale.bidToken = bidToken;
        sale.startTime = startTime;
        sale.duration = duration;
        return sale;
    }

    function getSalePart2(uint256 i) internal view returns(Sale memory) {
        MarketUpgradeable market = MarketUpgradeable(0xC8cEdDf1b1592B3ef5646aF733F14d8fF51a2656);
        Sale memory sale;
        uint256 extensionDuration;
        uint256 endTime;
        address bidder;
        uint256 bidAmount;
        (,,,,,,,extensionDuration,endTime,bidder,bidAmount) = market.saleIdToSale(i);
        sale.extensionDuration = extensionDuration;
        sale.endTime = endTime;
        sale.bidder = bidder;
        sale.bidAmount = bidAmount;
        return sale;
    }
}
