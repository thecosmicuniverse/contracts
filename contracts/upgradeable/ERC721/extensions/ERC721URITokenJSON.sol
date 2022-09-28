// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

/**
 * @dev ERC721 token with storage based token URI management.
 */
abstract contract ERC721URITokenJSON is Initializable, ERC721Upgradeable {
    using StringsUpgradeable for uint256;
    using StringsUpgradeable for address;

    struct Attribute {
        string name;
        string display;
        string value;
        bool isNumber;
    }

    string public imageBaseURI;

    function __ERC721URITokenJSON_init() internal onlyInitializing {

    }

    function __ERC721URITokenJSON_init_unchained() internal onlyInitializing {
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721Upgradeable) returns(string memory) {
        return tokenId.toString();
    }

    function batchTokenURI(uint256[] memory tokenIds) public view virtual returns(string[] memory) {
        string[] memory uris = new string[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uris[i] = tokenURI(tokenIds[i]);
        }
        return uris;
    }

    function _makeBase64(string memory json) internal view virtual returns (string memory) {
        return string(abi.encodePacked("data:application/json;base64,", Base64Upgradeable.encode(bytes(json))));
    }

    function _makeJSON(
        uint256 tokenId,
        string memory name,
        string memory customName,
        string memory description,
        Attribute[] memory attributes
    ) internal view returns(string memory) {
        string memory metadataJSON = _makeMetadata(tokenId, name, customName, description);
        string memory attributeJSON = _makeAttributes(attributes);
        return string(abi.encodePacked('{', metadataJSON, attributeJSON, '}'));
    }

    function _makeMetadata(
        uint256 tokenId,
        string memory name,
        string memory customName,
        string memory description
    ) internal view returns(string memory) {
        string memory imageURI = string(abi.encodePacked(imageBaseURI, tokenId.toString()));
        address owner = ownerOf(tokenId);
        return string(abi.encodePacked(
            '"name":"', name, ' #', tokenId.toString(), '",',
            '"customName":"', customName, '",',
            '"description": "', description, '",',
            '"image": "', imageURI, '",',
            '"owner": "', owner.toHexString(), '",',
            '"type": "ERC721",'
        ));
    }

    function _makeAttributes(Attribute[] memory attributes) internal pure returns(string memory) {
        string memory allAttributes = "";
        for (uint256 i = 0; i < attributes.length; i++) {
            string memory comma = i == (attributes.length - 1) ? '' : ',';
            string memory quoted = attributes[i].isNumber ? '' : '"';
            string memory value = string(abi.encodePacked(quoted, attributes[i].value, quoted));
            string memory displayType = bytes(attributes[i].display).length == 0
                ? ''
                :  string(abi.encodePacked('{"display_type":"', attributes[i].display, '",'));
            string memory a = string(
                abi.encodePacked(
                    allAttributes,
                    '{"trait_type":"', attributes[i].name, '",',
                    displayType,
                    '"value":', value, '}',
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