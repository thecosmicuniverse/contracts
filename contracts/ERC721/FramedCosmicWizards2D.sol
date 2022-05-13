// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
* @title Framed Cosmic Wizards 2D
* @author @DirtyCajunRice
*/
contract FramedCosmicWizards2D is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Pausable, AccessControl {
    // Roles
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant METADATA_ROLE = keccak256("METADATA_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    // Updatable baseURI
    string private _BASE_URI;
    // Burned framed wizards
    uint256[] public burned;
    // Burnable status
    uint256 public burnable = 0;

    // Conditional for burning
    modifier whenBurnable {
        require(burnable == 0, "Burning is not enabled");
        _;
    }

    constructor() ERC721("Framed Cosmic Wizards 2D", "FRAMEDWIZARDS2D") {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(PAUSER_ROLE, _msgSender());
        _setRoleAdmin(PAUSER_ROLE, ADMIN_ROLE);
        _grantRole(METADATA_ROLE, _msgSender());
        _setRoleAdmin(METADATA_ROLE, ADMIN_ROLE);
        _grantRole(MINTER_ROLE, _msgSender());
        _setRoleAdmin(MINTER_ROLE, ADMIN_ROLE);
    }

    /**
    * @notice Mints a Framed Cosmic Wizard 2D
    */
    function safeMint(address _address, uint256 tokenId) external onlyRole(MINTER_ROLE) whenNotPaused {
        require(tokenId > 0 && tokenId < 10000, "Invalid tokenId");
        for (uint256 i=0;i<burned.length;i++) {
            require(tokenId != burned[i], "Token already minted and burned");
        }
        _safeMint(_address, tokenId);
    }

    /**
    * @notice Burn a token, destroying it permanently
    *
    * @dev Destroys the tokenId sent by the caller and
    *      adds it to the array of burned tokenIds
    *
    * @param tokenId ID of the token to burn
    */
    function burn(uint256 tokenId) public virtual override whenBurnable {
        super.burn(tokenId);
        burned.push(tokenId);
    }

    // METADATA_ROLE Functions

    /**
    * @notice Set the BaseURI of all tokens
    *
    * @dev Sets the base URI used by all tokens to prefix
    *      their tokenURI
    *
    * @param baseURI URI prefix of a tokenURI
    */
    function setBaseURI(string memory baseURI) public onlyRole(METADATA_ROLE) {
        _BASE_URI = baseURI;
    }

    /**
    * @notice Set the TokenURI of a single token
    *
    * @dev Sets the the TokenURI suffix of a single token
    *
    * @param tokenId ID of the token to set
    * @param _tokenURI URI to set
    */
    function setTokenURI(uint256 tokenId, string memory _tokenURI) public onlyRole(METADATA_ROLE) {
        _setTokenURI(tokenId, _tokenURI);
    }

    // PAUSER_ROLE Functions

    /**
    * @notice Pause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to stop the execution of
    *      the safeMint and transferFrom functions
    */
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /**
    * @notice Unpause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to resume the execution of
    *      the safeMint and transferFrom functions
    */
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    // ADMIN_ROLE Functions

    /**
    * @notice Set the ability to burn tokens
    *
    * @dev Sets the burnable state of tokens, with 0 being false
    *      and 1 being true
    *
    * @param state Burnable state
    */
    function setBurnable(uint256 state) external onlyRole(ADMIN_ROLE) {
        require(state == 0 || state == 1, "Invalid state");
        burnable = state;
    }

    // Overrides

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal whenNotPaused
    override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
        return _BASE_URI;
    }

    function tokenURI(uint256 tokenId) public view
    override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view
    override(ERC721, ERC721Enumerable, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
