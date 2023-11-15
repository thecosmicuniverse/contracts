// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/Base64Upgradeable.sol";

library TokenMetadata {
    using StringsUpgradeable for uint256;
    using StringsUpgradeable for address;
    using Base64Upgradeable for bytes;
    using TokenMetadata for TokenType;
    using TokenMetadata for Attribute[];

    enum TokenType {
        ERC20,
        ERC1155,
        ERC721
    }

    enum DisplayType {
        Text,
        Number,
        Special,
        Value
    }
    struct Attribute {
        string name;
        string displayText;
        string value;
        DisplayType displayType;
    }

    function toBase64(string memory json) internal pure returns (string memory) {
        return string(abi.encodePacked("data:application/json;base64,", bytes(json).encode()));
    }

    function makeMetadataJSON(
        uint256 tokenId,
        address owner,
        string memory name,
        string memory imageURI,
        string memory description,
        TokenType tokenType,
        Attribute[] memory attributes
    ) internal pure returns(string memory) {
        string memory metadataJSON = makeMetadataString(tokenId, owner, name, imageURI, description, tokenType);
        return string(abi.encodePacked('{', metadataJSON, attributes.toJSONString(), '}'));
    }

    function makeMetadataString(
        uint256 tokenId,
        address owner,
        string memory name,
        string memory imageURI,
        string memory description,
        TokenType tokenType
    ) internal pure returns(string memory) {
        return string(abi.encodePacked(
                '"name":"', name, '",',
                '"tokenId":"', tokenId.toString(), '",',
                '"description":"', description, '",',
                '"image":"', imageURI, '",',
                '"owner":"', owner.toHexString(), '",',
                '"type":"', tokenType.toString(), '",'
            ));
    }

    function toJSONString(Attribute[] memory attributes) internal pure returns(string memory) {
        string memory attributeString = "";
        for (uint256 i = 0; i < attributes.length; i++) {
            string memory comma = i == (attributes.length - 1) ? '' : ',';
            string memory quote = attributes[i].displayType == DisplayType.Number
                || attributes[i].displayType == DisplayType.Special ? '' : '"';
            string memory traitType = attributes[i].displayType == DisplayType.Value
                ? ''
                : string(abi.encodePacked('"trait_type":"', attributes[i].name, '",'));
            string memory value = string(abi.encodePacked(quote, attributes[i].value, quote));
            string memory displayType = attributes[i].displayType == DisplayType.Special
            ? string(abi.encodePacked('"display_type":"', attributes[i].displayText, '",'))
            : '';
            string memory newAttributeString = string(
                abi.encodePacked(
                    attributeString,
                    '{', traitType, displayType, '"value":', value, '}',
                    comma
                )
            );
            attributeString = newAttributeString;
        }
        return string(abi.encodePacked('"attributes":[', attributeString, ']'));
    }

    function toString(TokenType tokenType) internal pure returns(string memory) {
        return tokenType == TokenType.ERC721 ? "ERC721" : tokenType == TokenType.ERC1155 ? "ERC1155" : "ERC20";
    }

    function makeContractURI(
        string memory name,
        string memory description,
        string memory imageURL,
        string memory externalLinkURL,
        uint256 sellerFeeBasisPoints,
        address feeRecipient
    ) internal pure returns(string memory) {
        return string(abi.encodePacked(
                '{"name":"', name, '",',
                '"description":"', description, '",',
                '"image":"', imageURL, '",',
                '"external_link":"', externalLinkURL, '",',
                '"seller_fee_basis_points":', sellerFeeBasisPoints.toString(), ',',
                '"fee_recipient":"', feeRecipient.toHexString(), '"}'
            ));
    }
}
