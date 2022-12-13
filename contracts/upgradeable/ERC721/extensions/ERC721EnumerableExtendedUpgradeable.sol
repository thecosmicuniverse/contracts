// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

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

    function batchTransferFrom(address from, address to, uint256[] memory tokenIds) public virtual {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            ERC721Upgradeable.transferFrom(from, to, tokenIds[i]);
        }
    }

    function tokensOfOwner(address owner) public view virtual returns(uint256[] memory) {
        uint256 total = ERC721Upgradeable.balanceOf(owner);
        uint256[] memory tokens = new uint256[](total);
        for (uint256 i = 0; i < total; i++) {
            tokens[i] = ERC721EnumerableUpgradeable.tokenOfOwnerByIndex(owner, i);
        }
        return tokens;
    }

    function getAllTokenIds() public view returns (uint256[] memory) {
        uint256 count = 0;
        for (uint256 i = 1; i < 10_000; i++) {
            if (_exists(i)) {
                count++;
            }
        }
        uint256[] memory tokenIds = new uint256[](count);
        uint256 index = 0;
        for (uint256 i = 1; i < 10_000; i++) {
            if (_exists(i)) {
                tokenIds[index] = i;
                index++;
            }
        }
        return tokenIds;
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
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

    uint256[50] private __gap;
}