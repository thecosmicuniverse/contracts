// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


library LibElves {


    function getRarityBonus(uint256[] memory attributes) internal pure returns (uint256) {
        uint256[10] memory bonuses = [
            getSkinToneBonus(attributes[1]),
            getHeadwearBonus(attributes[0], attributes[2]),
            getHairBonus(attributes[0], attributes[3]),
            getEyebrowsBonus(attributes[0], attributes[4]),
            getEyesBonus(attributes[5]),
            getEarsBonus(attributes[6]),
            getMouthBonus(attributes[0], attributes[7]),
            getAttireBonus(attributes[0], attributes[8]),
            getJewelryBonus(attributes[0], attributes[9]),
            getStaffBonus(attributes[0], attributes[10])
        ];
        uint256 bonus = 0;
        for (uint256 i = 0; i < 10; i++) {
            if (bonuses[i] > bonus) bonus = bonuses[i];
            if (bonus == 5) break;
        }
        return bonus;
    }

    // Type: Common | ID: 1
    function getSkinToneBonus(uint256 a) internal pure returns (uint256) {
        return a == 4 ? 4 : a == 3 ? 3 : 0;
    }

    // Type: Gender Specific | ID: 2
    function getHeadwearBonus(uint256 gender, uint256 a) internal pure returns (uint256) {
        if (gender == 0) {
            // male
            return a == 9 ? 5 : a == 8 ? 1 : 0;
        }
        // female
        return (a == 7 || a == 8) ? 1 : a == 9 ? 2 : (a == 10 || a == 11) ? 3 : (a == 12 || a == 13) ? 4 : (a >= 14 && a <= 15) ? 5 : 0;
    }

    // Type: Gender Specific | ID: 3
    function getHairBonus(uint256 gender, uint256 a) internal pure returns (uint256) {
        if (gender == 0) {
            // male
            return a == 8 ? 2 : (a >= 9 && a <= 11) ? 3 : a == 12 ? 4 : (a >= 13 && a <= 19) ? 5 : 0;
        }
        // female
        return a == 8 ? 2 : a == 9 ? 4 : (a >= 10 && a <= 19) ? 5 : 0;
    }

    // Type: Gender Specific | ID: 4
    function getEyebrowsBonus(uint256 gender, uint256 a) internal pure returns (uint256) {
        if (gender == 0) {
            // male
            return (a >= 5 && a <= 7) ? a - 4 : (a >= 8 && a <= 11) ? 5 : 0;
        }
        // female
        return (a == 8 || a == 9) ? 2 : (a == 10 || a == 11) ? 3 : 0;
    }

    // Type: Common | ID: 5
    function getEyesBonus(uint256 a) internal pure returns (uint256) {
        return (a >= 9 && a <= 11) ? 5 : 0;
    }

    // Type: Common | ID: 6
    function getEarsBonus(uint256 a) internal pure returns (uint256) {
        return a == 2 ? 1 : 0;
    }

    // Type: Gender Specific | ID: 7
    function getMouthBonus(uint256 gender, uint256 a) internal pure returns (uint256) {
        if (gender == 0) {
            // male
            return a == 5 ? 2 : (a >= 6 && a <= 8) ? 5 : 0;
        }
        // female
        return a == 9 ? 3 : 0;
    }

    // Type: Gender Specific | ID: 8
    function getAttireBonus(uint256 gender, uint256 a) internal pure returns (uint256) {
        if (gender == 0) {
            // male
            return a == 10 ? 2 : a == 11 ? 3 : 0;
        }
        // female
        return (a == 12 || a == 13) ? 3 : (a >= 14 && a <= 16) ? 4 : (a >= 17 && a <= 20) ? 5 : 0;
    }

    // Type: Gender Specific | ID: 9
    function getJewelryBonus(uint256 gender, uint256 a) internal pure returns (uint256) {
        if (gender == 0) {
            // male
            return a == 4 ? 3 : 0;
        }
        // female
        return (a == 6 || a == 7) ? 3 : a == 8 ? 4 : (a >= 9 && a <= 11) ? 5 : 0;
    }

    // Type: Gender Specific | ID: 10
    function getStaffBonus(uint256 gender, uint256 a) internal pure returns (uint256) {
        if (gender == 0) {
            // male
            return a == 5 ? 2 : 0;
        }
        // female
        return a == 5 ? 3 : 0;
    }
}