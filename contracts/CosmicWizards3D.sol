// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

interface IFramedWizards is IERC721 {
    function safeMint(address, uint256) external;
}

/**
* @title Cosmic Wizards 3D
* @author @DirtyCajunRice
*/
contract CosmicWizards3D is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Pausable, AccessControl {
    // Roles
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant METADATA_ROLE = keccak256("METADATA_ROLE");
    // 2D Wizards
    ERC721Enumerable private constant _WIZARDS = ERC721Enumerable(0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67);
    // 2D Framed Wizards
    IFramedWizards private constant _FRAMED_WIZARDS = IFramedWizards(0x37f47C343bfAF27A52bC1BD468b49d8E5eF89D67);
    // Burn address for 2D Wizards
    address private constant _V1_BURN_ADDRESS = payable(0x0000000000000000000000000000000000000001);
    // Updatable baseURI
    string private _BASE_URI;
    // Burned wizards
    uint256[] public burned;
    // Burnable status
    uint256 public burnable = 0;

    // Conditional for burning
    modifier whenBurnable {
        require(burnable == 0, "Burning is not enabled");
        _;
    }

    constructor() ERC721("Cosmic Wizards 3D", "WIZARDS3D") {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(PAUSER_ROLE, _msgSender());
        _setRoleAdmin(PAUSER_ROLE, ADMIN_ROLE);
        _grantRole(METADATA_ROLE, _msgSender());
        _setRoleAdmin(METADATA_ROLE, ADMIN_ROLE);
    }

    /**
    * @notice Upgrade all 2D Wizards to 3D Wizards
    *
    * @dev Gets the entire balance of the calling wallet's 2D Wizards and
    *      transfers them all to the predefined burn address. It then
    *      mints a 3D wizard, as well as minting a Framed Wizard collectable
    */
    function upgrade2DWizards() public whenNotPaused {
        require(_WIZARDS.isApprovedForAll(_msgSender(), address(this)), "Contract missing approval for 2D Wizards");
        uint256 wizardCount = _WIZARDS.balanceOf(_msgSender());
        for (uint256 i=0; i<wizardCount; i++) {
            uint256 wizardId = _WIZARDS.tokenOfOwnerByIndex(_msgSender(), i);
            _WIZARDS.safeTransferFrom(_msgSender(), _V1_BURN_ADDRESS, wizardId);
            _safeMint(_msgSender(), wizardId);
            _FRAMED_WIZARDS.safeMint(_msgSender(), wizardId);
        }
    }

    /**
    * @notice Burn a wizard, destroying is permanently
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
    * @notice Set the BaseURI of all wizards
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
    * @notice Set the TokenURI of a single wizard
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
    *      the upgrade2DWizards and transferFrom functions
    */
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /**
    * @notice Unpause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to resume the execution of
    *      the upgrade2DWizards and transferFrom functions
    */
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    // ADMIN_ROLE Functions

    /**
    * @notice Set the ability to burn wizards
    *
    * @dev Sets the burnable state of wizards, with 0 being false
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
