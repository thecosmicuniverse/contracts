// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
 * enumerability of all the token ids in the contract as well as all token ids owned by each
 * account.
 */
abstract contract ERC721EnumerableExtendedUpgradeable is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable {
    function __ERC721EnumerableExtended_init() internal onlyInitializing {
        __ERC721Enumerable_init();
    }

    function __ERC721EnumerableExtended_init_unchained() internal onlyInitializing {
    }

    function tokensOfOwner(address owner) public view virtual returns(uint256[] memory) {
        uint256 total = ERC721Upgradeable.balanceOf(owner);
        uint256[] memory tokens = new uint256[](total);
        for (uint256 i = 0; i < total; i++) {
            tokens[i] = ERC721EnumerableUpgradeable.tokenOfOwnerByIndex(owner, i);
        }
        return tokens;
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    uint256[50] private __gap;
}