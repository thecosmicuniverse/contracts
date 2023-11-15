// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../../utils/TokenConstants.sol";
import "../interfaces/IStandardERC20.sol";
import "../../utils/access/StandardAccessControl.sol";

/**
* @title Magic L2 v1.0.0
* @author @DirtyCajunRice
*/
contract MagicL2 is Initializable, ERC20Upgradeable, IStandardERC20, PausableUpgradeable, StandardAccessControl,
ERC20PermitUpgradeable, UUPSUpgradeable {

    address public bridgeContract;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __ERC20_init("Magic", "MAGIC");
        __Pausable_init();
        __ERC20Permit_init("Magic");
        __StandardAccessControl_init();
        __UUPSUpgradeable_init();

    }

    // Owner Functions

    /**
    * @notice Pause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to stop the execution of
    *      upgradeAll and transferFrom functions
    */
    function pause() external onlyAdmin {
        _pause();
    }

    /**
    * @notice Unpause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to resume the execution of
    *      upgradeAll and transferFrom functions
    */
    function unpause() external onlyAdmin {
        _unpause();
    }

    function mint(address account, uint256 amount) public onlyMinter {
        _mint(account, amount);
    }

    function mint(address account, uint256 amount, bytes memory) public onlyBridge {
        _mint(account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(msg.sender, amount);
    }
    function burn(address to, uint256 amount) public virtual override(IStandardERC20)  {
        _spendAllowance(to, _msgSender(), amount);
        _burn(to, amount);
    }
    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual {
        _spendAllowance(account, _msgSender(), amount);
        _burn(account, amount);
    }

    function teleport(address wallet, uint256 amount) external onlyAdmin {
        super._burn(wallet, amount);
    }

    /// Overrides

    function bridgeExtraData() external pure returns(bytes memory) {
        return "";
    }

    function setBridgeContract(address _address) external onlyAdmin {
        bridgeContract = _address;
        _grantRole(keccak256("BRIDGE_ROLE"), _address);
    }
    /**
    * @dev Required override for _beforeTokenTransfer because both
    * ERC20Pausable and ERC20 have the same function, so the derived
    * contract must override it
    *
    * @param from Address of the sender
    * @param to Address of the recipient
    * @param amount Amount of Cosmic to transfer
    */
    function _beforeTokenTransfer(address from, address to, uint256 amount)
    internal whenNotPaused override(ERC20Upgradeable) {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal onlyDefaultAdmin override {}

    function supportsInterface(bytes4 interfaceId) public view override(AccessControlEnumerableUpgradeable, IERC165Upgradeable) returns (bool)
    {
        return interfaceId == type(IStandardERC20).interfaceId || super.supportsInterface(interfaceId);
    }
}
