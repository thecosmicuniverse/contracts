// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
* @title xMagic v1.0.0
* @author @DirtyCajunRice
*/
contract xMagicUpgradeable is Initializable, PausableUpgradeable, AccessControlUpgradeable, ERC20Upgradeable {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");

    ERC20Upgradeable private BASE_TOKEN;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __ERC20_init("xMAGIC", "xMAGIC");
        __Pausable_init();
        __AccessControl_init();

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(PAUSER_ROLE, _msgSender());
        _grantRole(CONTRACT_ROLE, _msgSender());

        BASE_TOKEN = ERC20Upgradeable(0x9A8E0217cD870783c3f2317985C57Bf570969153);
    }

    function deposit(uint256 amount) public whenNotPaused {
        uint256 totalGovernanceToken = BASE_TOKEN.balanceOf(address(this));

        uint256 totalShares = totalSupply();

        if (totalShares == 0 || totalGovernanceToken == 0) {
            _mint(_msgSender(), amount);
        } else {
            uint256 what = amount * totalShares / totalGovernanceToken;
            _mint(_msgSender(), what);
        }

        BASE_TOKEN.transferFrom(_msgSender(), address(this), amount);
    }

    function withdraw(uint256 amount) public {
        uint256 totalShares = totalSupply();

        uint256 what = amount * BASE_TOKEN.balanceOf(address(this)) / totalShares;

        _burn(_msgSender(), amount);

        BASE_TOKEN.transfer(_msgSender(), what);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function setBaseToken(address _address) public onlyRole(DEFAULT_ADMIN_ROLE) {
        BASE_TOKEN = ERC20Upgradeable(_address);
    }
}