// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./mixins/MarketCoreUpgradeable.sol";

contract ERC721 is 
    Initializable,
    OwnableUpgradeable,
    ERC721Upgradeable
{
    string private currentBaseURI;

    function initialize() public initializer {
        __Ownable_init();
        __ERC721_init("ERC721", "ERC721");
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return currentBaseURI;
    }

    function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    function setBaseURI(string memory URI) public onlyOwner {
        currentBaseURI = URI;
    }

    function mint(uint256 tokenId) public onlyOwner {
        _safeMint(_msgSender(), tokenId);
    }
}