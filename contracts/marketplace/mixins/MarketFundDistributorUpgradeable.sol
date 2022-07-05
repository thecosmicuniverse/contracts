// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./MarketRoyaltyUpgradeable.sol";
import "./MarketFeeUpgradeable.sol";
import "./TreasuryNode.sol";

abstract contract MarketFundDistributorUpgradeable is
    Initializable,
    MarketRoyaltyUpgradeable,
    MarketFeeUpgradeable,
    TreasuryNode
{
    using SafeMathUpgradeable for uint256;
    using SafeERC20Upgradeable for IERC20Upgradeable;

    function __MarketFundDistributor_int(uint256 maxRoyaltyBps, uint256 marketFeeBps, address treasury) internal onlyInitializing {
        __MarketRoyalty_int(maxRoyaltyBps);
        __MarketFee_int(marketFeeBps);
        __TreasuryNode_init(treasury);
    }

    function _distributeFunds(
        address contractAddress, uint256 tokenId, address bidTokenAddress ,address seller, uint256 price
    ) internal returns (uint256, uint256, uint256) {
        uint256 marketFee = _getFees(price);
        (address royaltyReciever, uint256 royalty) = _getRoyalty(contractAddress, tokenId, price);
        uint256 sellerRev = price.sub(marketFee).sub(royalty);

        IERC20Upgradeable bidToken = IERC20Upgradeable(bidTokenAddress);
        if (royalty > 0) {
            bidToken.safeTransfer(royaltyReciever, royalty);
        }
        bidToken.safeTransfer(getTreasury(), marketFee);
        bidToken.safeTransfer(seller, sellerRev);

        return (royalty, marketFee, sellerRev);
    }

    uint256[1000] private ______gap;
}
