// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

library ArrayCheckUpgradeable {
    function checkgte(uint256[] memory array, uint256 num) internal pure returns (bool) {
        for (uint256 i = 0; i < array.length; ++i) {
            if (array[i] < num) return false;
        }
        return true;
    }
}