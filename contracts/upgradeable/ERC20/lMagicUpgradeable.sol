// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableMapUpgradeable.sol";

import "./extensions/ERC20BurnableUpgradeable.sol";
import "../utils/TokenConstants.sol";
import "./interfaces/IMintable.sol";

/**
* @title Locked Magic v1.0.0
* @author @DirtyCajunRice
*/
contract lMagicUpgradeable is Initializable, ERC20Upgradeable, PausableUpgradeable, AccessControlUpgradeable,
ERC20PermitUpgradeable, ERC20BurnableUpgradeable, TokenConstants {
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    address private MAGIC;

    uint256 private GENESIS_TIMESTAMP;
    uint256 private OMEGA_TIMESTAMP;

    mapping (address => uint256) private _totalOf;

    EnumerableSetUpgradeable.AddressSet private _globalWhitelist;

    mapping (address => EnumerableSetUpgradeable.AddressSet) private _whitelist;

    modifier onlyWhitelist(address from, address to) {
        require(
            _globalWhitelist.contains(to)
            || _whitelist[from].contains(to)
            || from == address(0)
            || to == address(0),
            "cEVO is non-transferable"
        );
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __ERC20_init("lMAGIC", "lMAGIC");
        __Pausable_init();
        __AccessControl_init();
        __ERC20Permit_init("lMAGIC");
        __ERC20Burnable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());

        MAGIC = 0x9A8E0217cD870783c3f2317985C57Bf570969153;
        OMEGA_TIMESTAMP = 1673438400;
        GENESIS_TIMESTAMP = OMEGA_TIMESTAMP - 365 days;
    }

    function pause() public onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    function mint(address _address, uint256 amount) public onlyRole(MINTER_ROLE) {
        IMintable(MAGIC).mint(address(this), amount);
        _mint(_address, amount);
        _totalOf[_address] += amount;
    }

    function burn(uint256 amount) public virtual override(ERC20BurnableUpgradeable) {
        super.burn(amount);
        IMintable(MAGIC).burn(amount);
    }

    function burnFrom(address account, uint256 amount) public virtual override(ERC20BurnableUpgradeable) {
        super.burnFrom(account, amount);
        IMintable(MAGIC).burn(amount);
    }

    function claimPending() public whenNotPaused {
        uint256 pending = pendingOf(_msgSender());
        if (pending == 0) {
            return;
        }
        _burn(_msgSender(), pending);
        ERC20Upgradeable(MAGIC).transfer(_msgSender(), pending);
    }

    function pendingOf(address _address) public view returns(uint256) {
        uint256 balance = balanceOf(_address);
        uint256 claimed = _totalOf[_address] - balance;
        uint256 pendingPerSecond = _totalOf[_address] / (OMEGA_TIMESTAMP - GENESIS_TIMESTAMP);
        uint256 pending = ((block.timestamp - GENESIS_TIMESTAMP) * pendingPerSecond);
        if (claimed < pending) {
            return pending - claimed;
        }

        return 0;
    }

    function totalOf(address _address) public view returns(uint256) {
        return _totalOf[_address];
    }

    function addGlobalWhitelist(address to) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _globalWhitelist.add(to);
    }

    function addWhitelist(address from, address to) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _whitelist[from].add(to);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
    internal whenNotPaused override onlyWhitelist(from, to) {
        super._beforeTokenTransfer(from, to, amount);
    }
}