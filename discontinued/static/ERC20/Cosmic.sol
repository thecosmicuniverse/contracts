pragma solidity ^0.8.9;
// SPDX-License-Identifier: Unlicensed

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
* @title Cosmic
* @author @DirtyCajunRice
*/

contract Cosmic is ERC20Capped, ERC20Burnable, ERC20Pausable, Ownable, ReentrancyGuard {

    using SafeERC20 for IERC20;

    // Original CosmicCoin
    IERC20 private constant _COSMIC_V1 = IERC20(0x6008C8769BFACd92251bA838382e7e5637C7e74D);
    // Original CosmicCoin BurnAddress
    address private constant _V1_BURN_ADDRESS = payable(0x0000000000000000000000000000000000000001);
    // Total amount of CosmicCoin upgraded
    uint256 public totalUpgraded;
    // Total amount of Cosmic burned
    uint256 public totalBurned;

    constructor() ERC20("Cosmic", "COSMIC") ERC20Capped(1000000000 * (10**18)) {
        burnSync();
    }

    // View functions

    /**
    * @notice Get the amount of CosmicCoin left in circulation
    *
    * @dev Convenience proxy function to get the remaining balance of
    *      CosmicCoin, represented as an 18 decimal token
    *
    * @return balance of CosmicCoin represented as an 18 decimal token
    */
    function leftToUpgrade() external view virtual returns(uint256) {
        return convert9to18(_COSMIC_V1.totalSupply() - _COSMIC_V1.balanceOf(_V1_BURN_ADDRESS));
    }

    // Custom functions

    /**
    * @notice Upgrade all CosmicCoin to Cosmic
    *
    * @dev Gets the entire balance of the calling wallet's old CosmicCoin and
    *      transfers it to the predefined burn address. It then converts the
    *      9 decimal balance to an 18 decimal balance, mints it as Cosmic,
    *      and then stores the balance for convenience calling.
    */
    function upgradeAll() external nonReentrant whenNotPaused {
        // Get current balance of cosmic v1
        uint256 userBalance = _COSMIC_V1.balanceOf(_msgSender());
        require(userBalance > 0, "No old COSMIC to upgrade");

        // Save burn address balance before and after to account for tax
        uint256 burnStartBalance = _COSMIC_V1.balanceOf(_V1_BURN_ADDRESS);
        _COSMIC_V1.safeTransferFrom(_msgSender(), _V1_BURN_ADDRESS, userBalance);
        uint256 burnEndBalance = _COSMIC_V1.balanceOf(_V1_BURN_ADDRESS);

        // Mint final balance
        uint256 burnBalance18 = convert9to18(burnEndBalance - burnStartBalance);
        _mint(_msgSender(), burnBalance18);

        totalUpgraded += burnBalance18;
    }

    /**
    * @notice Check for burn discrepancy
    *
    * @dev Checks to see if cosmic v1 has been burned through a means
    *      other than upgrade
    *
    * @return amount available to burn
    */
    function missingBurn() public view virtual returns(uint256) {
        return convert9to18(_COSMIC_V1.balanceOf(_V1_BURN_ADDRESS)) - totalUpgraded;
    }

    /**
    * @dev Burns Cosmic to match CosmicCoin
    *
    * @return amount burned
    */
    function burnSync() public nonReentrant whenNotPaused returns(uint256) {
        uint256 missing = missingBurn();
        require(missing > 0, "No old COSMIC to burn");
        _mint(_msgSender(), missing);
        burn(missing);
        totalUpgraded += missing;
        return missing;
    }

    // Owner Functions

    /**
    * @notice Pause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to stop the execution of
    *      upgradeAll and transferFrom functions
    */
    function pause() external onlyOwner {
        _pause();
    }

    /**
    * @notice Unpause token upgrades and transfers
    *
    * @dev Allows the owner of the contract to resume the execution of
    *      upgradeAll and transferFrom functions
    */
    function unpause() external onlyOwner {
        _unpause();
    }

    // Internal functions

    /**
    * @dev Convenience function to convert a 9 decimal value into
    *      an 18 decimal value
    */
    function convert9to18(uint256 amount) internal pure returns(uint256) {
        return amount * (10**9);
    }

    // Overrides

    /**
    * @notice Burn Cosmic, destroying it permanently
    *
    * @dev Destroys the `amount` of tokens sent by the caller and
    *      adds that amount to the balance of totalBurned
    *
    * @param amount Quantity of Cosmic to burn
    */
    function burn(uint256 amount) public virtual override {
        super.burn(amount);
        totalBurned += amount;
    }

    /**
    * @notice Burn Cosmic from an address, destroying it permanently
    *
    * @dev Destroys the `amount` of tokens set by the caller from
    *      `account` and adds that amount to the balance of
    *      totalBurned. The caller must have an allowance for the
    *      `account`
    *
    * @param account Address to burn Cosmic from
    * @param amount Quantity of Cosmic to burn
    */
    function burnFrom(address account, uint256 amount) public virtual override {
        super.burnFrom(account, amount);
        totalBurned += amount;
    }

    /**
    * @dev Required override for _mint because both ERC20Capped and
    * ERC20 have the same function, so the derived contract must
    * override it
    *
    * @param account Address of the account to send Cosmic to
    * @param amount Quantity of Cosmic to mint
    */
    function _mint(address account, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
        super._mint(account, amount);
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
    internal whenNotPaused override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }
}