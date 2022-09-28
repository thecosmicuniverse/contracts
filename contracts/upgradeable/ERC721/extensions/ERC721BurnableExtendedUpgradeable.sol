// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
 * enumerability of all the token ids in the contract as well as all token ids owned by each
 * account.
 */
abstract contract ERC721BurnableExtendedUpgradeable is Initializable, ERC721Upgradeable, ERC721BurnableUpgradeable {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    EnumerableSetUpgradeable.UintSet private _burned;

    function __ERC721BurnableExtended_init() internal onlyInitializing {
        __ERC721Burnable_init();
    }

    function __ERC721BurnableExtended_init_unchained() internal onlyInitializing {
    }

    function burn(uint256 tokenId) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
        _burned.add(tokenId);
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Upgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _exists(uint256 tokenId) internal view virtual override(ERC721Upgradeable) returns (bool) {
        return super._exists(tokenId) || !_burned.contains(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual
    override(ERC721Upgradeable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    uint256[49] private __gap;
}