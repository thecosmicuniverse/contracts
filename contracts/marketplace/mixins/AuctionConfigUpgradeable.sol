// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

import "./Constants.sol";

abstract contract AuctionConfigUpgradeable is
    Initializable,
    OwnableUpgradeable,
    Constants
{
    using SafeMathUpgradeable for uint256;

    uint256 internal constant EXTENSION_DURATION = 15 minutes;

    uint256 internal _nexBidPercentBps;

    event AuctionConfigUpdated(
        uint256 nexBidPercentInBasisPoint, 
        uint256 extensionDuration
    );

    function __AuctionConfig_init(uint256 nexBidPercentBps) internal onlyInitializing {
        __Ownable_init();
        _nexBidPercentBps = nexBidPercentBps;
    }

    function getAuctionConfig() external view returns (uint256, uint256) {
        return (_nexBidPercentBps, EXTENSION_DURATION);
    }

    function updateAuctionConfig(uint256 nexBidPercentBps) external onlyOwner {
        require(0 <= nexBidPercentBps && nexBidPercentBps <= BASIS_POINTS, "AuctionCoreUpgradeable: Min increment must be >=0% and <= 100%");
        
        _nexBidPercentBps = nexBidPercentBps;

        emit AuctionConfigUpdated(nexBidPercentBps, EXTENSION_DURATION);
    }

    function _getNextBidAmount(uint256 currentBidAmount) internal view returns(uint256) {
        uint256 minIncrement = currentBidAmount.mul(_nexBidPercentBps) / BASIS_POINTS;
        if (minIncrement == 0) {
            return currentBidAmount.add(1);
        }
        return currentBidAmount.add(minIncrement);
    }

    uint256[1000] private ______gap;
}