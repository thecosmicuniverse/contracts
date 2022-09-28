// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

import "../interfaces/CosmicStructs.sol";

/**
 * @dev ERC1155 token with JSON based token URI management.
 */
abstract contract ERC1155URITokenJSON is Initializable, CosmicStructs {
    using StringsUpgradeable for uint256;

    string public imageBaseURI;

    function __ERC1155URITokenJSON_init(string memory _imageBaseUri) internal onlyInitializing {
        imageBaseURI = _imageBaseUri;
    }

    function uri(uint256 tokenIds) public view virtual returns (string memory);

    function batchUri(uint256[] memory tokenIds) public view virtual returns(string[] memory) {
        string[] memory uris = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uris[i] = tokenURI(tokenIds[i]);
        }
        return uris;
    }

    function tokenURI(uint256 tokenId) public view virtual returns(string memory) {
        return uri(tokenId);
    }

    function batchTokenURI(uint256[] memory tokenIds) public view virtual returns(string[] memory) {
        return batchUri(tokenIds);
    }

    function _makeBase64(string memory json) internal view virtual returns (string memory) {
        return string(abi.encodePacked("data:application/json;base64,", Base64Upgradeable.encode(bytes(json))));
    }

    function _makeJSON(
        uint256 tokenId,
        string memory name,
        string memory description,
        Attribute[] memory attributes
    ) internal view returns(string memory) {
        string memory metadataJSON = _makeMetadata(tokenId, name, description);
        string memory attributeJSON = _makeAttributes(attributes);
        return string(abi.encodePacked('{', metadataJSON, attributeJSON, '}'));
    }

    function _makeMetadata(
        uint256 tokenId,
        string memory name,
        string memory description
    ) internal view returns(string memory) {
        string memory imageURI = string(abi.encodePacked(imageBaseURI, tokenId.toString()));
        return string(abi.encodePacked(
            '"name":"', name, '",',
            '"tokenId":', tokenId.toString(), ',',
            '"description":"', description, '",',
            '"image":"', imageURI, '",',
            '"type":"ERC1155",'
        ));
    }

    function _makeAttributes(Attribute[] memory attributes) internal pure returns(string memory) {
        string memory allAttributes = "";
        for (uint256 i = 0; i < attributes.length; i++) {
            string memory comma = i == (attributes.length - 1) ? '' : ',';
            string memory displayType = bytes(attributes[i].display).length == 0
                ? ''
                :  string(abi.encodePacked('{"display_type":"', attributes[i].display, '",'));
            string memory a = string(
                abi.encodePacked(
                    allAttributes,
                    '{"trait_type":"', attributes[i].name, '",',
                    displayType,
                    '"value":', attributes[i].value.toString(), '}',
                    comma
                )
            );
            allAttributes = a;
        }
        return string(abi.encodePacked('"attributes":[', allAttributes, ']'));
    }

    function _setImageBaseURI(string memory _imageBaseURI) internal virtual {
        imageBaseURI = _imageBaseURI;
    }

    uint256[49] private __gap;
}