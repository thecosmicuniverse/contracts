// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../common/SharedStructs.sol";

interface IElvenAdventures is SharedStructs {

    enum TokenType { ERC20, ERC1155, ERC721 }

    struct Quest {
        uint256 level;
        uint256 skillId;
        uint256 completeAt;
    }

    struct Reward {
        address _address;
        uint256 id;
        uint256 amount;
        TokenType tokenType;
    }

    event UnlockedAdventures(address indexed from, uint256 tokenId);
    event BeganQuest(address indexed from, uint256 tokenId, uint256 skillId, uint256 level, uint256 completeAt);
    event FinishedQuest(address indexed from, uint256 tokenId, uint256 skillId, uint256 level);
    event CancelledQuest(address indexed from, uint256 tokenId, uint256 skillId);
    event BeganAdventure(address indexed from, uint256 tokenId);
    event FinishedAdventure(address indexed from, uint256 tokenId);
}
