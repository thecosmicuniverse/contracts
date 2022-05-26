// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TestWizards2D is ERC721, ERC721Enumerable, AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    using SafeMath for uint256;

    // Token detail
    struct ComicWizardDetail {
        uint256 first_encounter;
    }

    // Events
    event TokenMinted(uint256 tokenId, address owner, uint256 first_encounter);

    // Token Detail
    mapping(uint256 => ComicWizardDetail) private _comicWizard;

    // Provenance number
    string public PROVENANCE = "";

     // Max amount of tokens to purchase per account each time
    uint256 public MAX_PURCHASE = 20;

    // Maximum amount of tokens to supply.
    uint256 public MAX_TOKENS = 10000;

    // Current price.
    uint256 public CURRENT_PRICE = 1;

    // Define if sale is active
    bool public saleIsActive = true;

    // Base URI
    string private baseURI;

    /**
     * Contract constructor
     */
    constructor() ERC721("Cosmic Wizards 2D Test", "TESTWIZARDS2D") {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());
        _setRoleAdmin(MINTER_ROLE, ADMIN_ROLE);
    }

    /**
     * With
     */
    function withdraw() public onlyRole(ADMIN_ROLE) {
        uint256 balance = address(this).balance;
        payable(_msgSender()).transfer(balance);
    }
     
    /**
     * Reserve tokens
     */
    function reserveTokens() public onlyRole(ADMIN_ROLE) {
        uint256 i;
        uint256 tokenId;
        uint256 first_encounter = block.timestamp;

        for (i = 1; i <= 50; i++) {
            tokenId = totalSupply().add(1);
            if (tokenId <= MAX_TOKENS) {
                _safeMint(msg.sender, tokenId);
                emit TokenMinted(tokenId, msg.sender, first_encounter);
            }
        }
    }

    /**
     * Mint a specific token.
     */
    function mintTokenId(uint256 tokenId) public onlyRole(MINTER_ROLE) {
        require(!_exists(tokenId), "Token was minted");
        uint256 first_encounter = block.timestamp;
        _safeMint(msg.sender, tokenId);
        _comicWizard[tokenId] = ComicWizardDetail(first_encounter);
        emit TokenMinted(tokenId, msg.sender, first_encounter);
    }

    /*
     * Set provenance once it's calculated
     */
    function setProvenanceHash(string memory provenanceHash) public onlyRole(ADMIN_ROLE) {
        PROVENANCE = provenanceHash;
    }

    /*
     * Set max tokens
     */
    function setMaxTokens(uint256 maxTokens) public onlyRole(ADMIN_ROLE) {
        MAX_TOKENS = maxTokens;
    }

    /*
     * Pause sale if active, make active if paused
     */
    function setSaleState(bool newState) public onlyRole(ADMIN_ROLE) {
        saleIsActive = newState;
    }

    /**
     * Mint ComicWizard World
     */
    function mintComicWizard(uint256 numberOfTokens) public payable onlyRole(MINTER_ROLE) {
        require(saleIsActive, "Mint is not available right now");
        require(
            numberOfTokens <= MAX_PURCHASE,
            "Can only mint 20 tokens at a time"
        );
        require(
            totalSupply().add(numberOfTokens) <= MAX_TOKENS,
            "Purchase would exceed max supply of ComicWizard"
        );
        require(
            CURRENT_PRICE.mul(numberOfTokens) <= msg.value,
            "Value sent is not correct"
        );
        uint256 first_encounter = block.timestamp;
        uint256 tokenId;

        for (uint256 i = 1; i <= numberOfTokens; i++) {
            tokenId = totalSupply().add(1);
            if (tokenId <= MAX_TOKENS) {
                _safeMint(msg.sender, tokenId);
                _comicWizard[tokenId] = ComicWizardDetail(first_encounter);
                emit TokenMinted(tokenId, msg.sender, first_encounter);
            }
        }
    }    


    /**
     * @dev Changes the base URI if we want to move things in the future (Callable by owner only)
     */
    function setBaseURI(string memory BaseURI) public onlyRole(ADMIN_ROLE) {
        baseURI = BaseURI;
    }

    /**
     * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
     * in child contracts.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    /**
     * Set the current token price
     */
    function setCurrentPrice(uint256 currentPrice) public onlyRole(ADMIN_ROLE) {
        CURRENT_PRICE = currentPrice;
    }

    /**
     * Get the token detail
     */
    function getComicWizardDetail(uint256 tokenId)
        public
        view
        returns (ComicWizardDetail memory detail)
    {
        require(_exists(tokenId), "Token was not minted");

        return _comicWizard[tokenId];
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal
    override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view
    override(ERC721, ERC721Enumerable, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
