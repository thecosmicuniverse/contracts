// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";


abstract contract MarketContractWhitelistUpgradeable is
    Initializable,
    OwnableUpgradeable
{
    using AddressUpgradeable for address;

    mapping(address => address) public contractAddressToBidToken;

    event ContractBidTokenUpdated(
        address indexed contractAddress,
        address indexed bidToken
    );

    function __MarketContractWhitelist_init() internal onlyInitializing {
        __Ownable_init();
    }

    function setContractBidToken(address contractAddress, address bidTokenAddress) external onlyOwner {
        require(contractAddress.isContract(), "AuctionCoreUpgradeable: Not a contract");
        require(bidTokenAddress.isContract(), "AuctionCoreUpgradeable: Not a contract");

        contractAddressToBidToken[contractAddress] = bidTokenAddress;
    }

    function getContractBidToken(address contractAddress) external view returns(address) {
        return contractAddressToBidToken[contractAddress];
    }

    function removeContractBidToken(address contractAddress) external onlyOwner {
        delete contractAddressToBidToken[contractAddress];
    }

    function isValidBidToken(address contractAddress, address bidTokenAddress) internal view returns(bool) {
        return contractAddressToBidToken[contractAddress] == bidTokenAddress;
    }

    uint256[1000] private ______gap;
}