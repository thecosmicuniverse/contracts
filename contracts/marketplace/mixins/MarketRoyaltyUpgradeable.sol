// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./Constants.sol";

abstract contract MarketRoyaltyUpgradeable is Initializable, AccessControlEnumerableUpgradeable, Constants {
    using SafeMathUpgradeable for uint256;

    struct RoyaltyInfo {
        address recipient;
        uint256 amount;
    }

    uint256 private _maxRoyaltyBps;
    mapping(address => mapping(uint256 => RoyaltyInfo)) public royalties;

    event MarketRoyaltyUpdated(
        uint256 indexed maxRoyaltiyBps
    );

    function __MarketRoyalty_int(uint256 maxRoyaltyBps) internal onlyInitializing {
        require(maxRoyaltyBps <= MAX_BPS, "MarketRoyaltyUpgradeable: Royalty > 10%");
        _maxRoyaltyBps = maxRoyaltyBps;
        __AccessControlEnumerable_init();
    }

    function getMarketRoyaltyConfig() external view returns (uint256) {
        return _maxRoyaltyBps;
    }

    function setMarketRoyaltyConfig(uint256 maxRoyaltyBps) external onlyRole(ADMIN_ROLE) {
        require(maxRoyaltyBps <= MAX_BPS, "MarketRoyaltyUpgradeable: Royalty > 10%");

        _maxRoyaltyBps = maxRoyaltyBps;

        emit MarketRoyaltyUpdated(maxRoyaltyBps);
    }

    function setRoyaltyFor(address from, address contractAddress, uint256 tokenId, uint256 royaltyBps) internal {
        require(royalties[contractAddress][tokenId].recipient == address(0), "MarketRoyaltyUpgradeable: Royalty already set");
        require(royaltyBps > 0 && royaltyBps <= _maxRoyaltyBps, "MarketRoyaltyUpgradeable: Invalid royalty");
        royalties[contractAddress][tokenId] = RoyaltyInfo(
            from,
            royaltyBps
        );
    }

    function _getRoyalty(address contractAddress, uint256 tokenId, uint256 price) internal view returns (address, uint256) {
        RoyaltyInfo memory royalty = royalties[contractAddress][tokenId];
        if (royalty.recipient == address(0)) {
            return (address(0), 0);
        }

        uint256 royaltyAmount = price.mul(royalty.amount).div(BASIS_POINTS);
        
        return (royalty.recipient, royaltyAmount);
    }

    uint256[1000] private ______gap;
}
