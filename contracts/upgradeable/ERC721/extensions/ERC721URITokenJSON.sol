// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "../../library/TokenMetadata.sol";
/**
 * @dev ERC721 token with storage based token URI management.
 */
abstract contract ERC721URITokenJSON is Initializable, ERC721Upgradeable {
    using StringsUpgradeable for uint256;
    using TokenMetadata for string;

    string public imageBaseURI;

    function __ERC721URITokenJSON_init() internal onlyInitializing {}

    function tokenURI(uint256 tokenId) public view virtual override(ERC721Upgradeable) returns(string memory) {
        return tokenURIJSON(tokenId).toBase64();
    }

    function tokenURIJSON(uint256 tokenId) public view virtual returns(string memory);

    function batchTokenURI(uint256[] calldata tokenIds) public view virtual returns(string[] memory) {
        string[] memory uris = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uris[i] = tokenURI(tokenIds[i]);
        }
        return uris;
    }

    function batchTokenURIJSON(uint256[] memory tokenIds) public view virtual returns(string[] memory) {
        string[] memory uris = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uris[i] = tokenURIJSON(tokenIds[i]);
        }
        return uris;
    }

    function makeMetadataJSON(
        uint256 tokenId,
        string memory name,
        string memory description,
        TokenMetadata.Attribute[] memory attributes
    ) internal view virtual returns(string memory) {
        address owner = ownerOf(tokenId);
        string memory imageURI = string(abi.encodePacked(imageBaseURI, imageURISuffix(tokenId)));
        return TokenMetadata.makeMetadataJSON(
            tokenId,
            owner,
            name,
            imageURI,
            description,
            TokenMetadata.TokenType.ERC721,
            attributes
        );
    }

    function imageURISuffix(uint256 tokenId) internal view virtual returns (string memory) {
        return tokenId.toString();
    }

    uint256[49] private __gap;
}