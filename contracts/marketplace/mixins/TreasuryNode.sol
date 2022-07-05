// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

abstract contract TreasuryNode is Initializable {
    using AddressUpgradeable for address;

    address private _treasury;

    function __TreasuryNode_init(address treasury) internal initializer {
        require(treasury.isContract(), "TreasuryNode: Address is not a contract");
        _treasury = treasury;
    }

    function getTreasury() public view returns (address) {
        return _treasury;
    }

    uint256[1000] private __gap;
}
