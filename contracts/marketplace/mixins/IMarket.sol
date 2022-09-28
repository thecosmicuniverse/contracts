// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IMarket {
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

    function saleIdToSale(uint256) external view returns(Sale memory);
}