// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../ERC721/interfaces/ICosmicElves.sol";

contract UEQueryHelper is Initializable {
    ICosmicElves public constant ELVES = ICosmicElves(0x9a337A6F883De95f49e05CD7D801d475a40a9C70);
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {}

    function getAllElves() public view returns(string[] memory) {
        uint256[] memory allIds = ELVES.getAllTokenIds();
        return ELVES.batchTokenURI(allIds);
    }
}
