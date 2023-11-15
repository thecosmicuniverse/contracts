// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library CosmicAddressBookBobaAvax {

    /*********
     * ERC20 *
     *********/

    function MAGIC() internal pure returns (address) {
        return 0x245B4C64271e91C9FB6bE1971A0208dD92EFeBDe;
    }

    /***********
     * ERC1155 *
     ***********/

    function Components() internal pure returns (address) {
        return 0x753492646D652987bC20b3e8c72c7A9Be8809f5D;
    }
    function Potions() internal pure returns (address) {
        return 0x146D129F1aeBae23422D1f4613C75fFE4087329C;
    }
    function RawResources() internal pure returns (address) {
        return 0xCE953D1A6be7331EEf06ec9Ac8a4a22a4f2BDfB0;
    }
    function RefinedResources() internal pure returns (address) {
        return 0x4F82DFbEED2aa0686EB26ddba7a075406b4C6A67;
    }
    function Skins() internal pure returns (address) {
        return 0x9402aDCfb075155c245862a23F713C15E9CD71c7;
    }
    function Badges() internal pure returns (address) {
        return 0x9E2Aa514325e67D3bA78E575cAF6F90fBC628069;
    }
    function Bundles() internal pure returns (address) {
        return 0x69938433cB243721978986a5B3c981A681970212;
    }

    /**********
     * ERC721 *
     **********/

    function Elves() internal pure returns (address) {
        return 0x09692b3a53eB7870F00b342444E4f42e259e7999;
    }
    function Wizards() internal pure returns (address) {
        return 0x003b43A3876274b76Ee366cFFbC6bc53AB89Acd7;
    }

    function Tools() internal pure returns (address) {
        return 0x0458b679C30AA4B8622742eA9fb2A44660c4a2a1;
    }

    function CosmicIslandLand() internal pure returns (address) {
        return 0x3280522Ca527e3802bb90aC74AF6Ca3CB0433F73;
    }

    /*******
     * NPC *
     *******/

    function ChestRedeemer() internal pure returns (address) {
        return 0xf0D8537ca2D0F3e268aa01895AFe87a38Faf6D0E;
    }

    function ElvenAdventures() internal pure returns (address) {
        return 0x94932B53B666179cF0cFEB178BDa358f538f36c4;
    }

    /*******
     * NPC *
     *******/

    function Treasury() internal pure returns (address) {
        return address(0);
    }
}