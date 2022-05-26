// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";


import "./Constants.sol";

abstract contract MarketFeeUpgradeable is
    Initializable,
    OwnableUpgradeable,
    Constants
{
    using SafeMathUpgradeable for uint256;

    uint256 private _marketFeeBps;

    event MarketFeesUpdated(
        uint256 indexed marketFeeBps
    );

    function __MarketFee_int(uint256 marketFeeBps) internal onlyInitializing {
        require(marketFeeBps <= MAX_BPS, "MarketFeeUpgradeable: Fees > 10%");
        _marketFeeBps = marketFeeBps;
        __Ownable_init();
    }

    function getMarketFeeConfig() external view returns (uint256) {
        return _marketFeeBps;
    }

    function setMarketFeeConfig(uint256 marketFeeBps) external onlyOwner {
        require(marketFeeBps <= MAX_BPS, "MarketFeeUpgradeable: Fees > 10%");

        _marketFeeBps = marketFeeBps;

        emit MarketFeesUpdated(marketFeeBps);
    }

    function _getFees(uint256 price) internal view returns (uint256) {
        return price.mul(_marketFeeBps).div(BASIS_POINTS);
    }

    uint256[1000] private ______gap;
}
