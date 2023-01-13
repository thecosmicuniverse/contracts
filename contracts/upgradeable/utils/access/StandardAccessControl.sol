// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract StandardAccessControl is Initializable, AccessControlEnumerableUpgradeable {
    bytes32 private constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 private constant CONTRACT_ROLE = keccak256("CONTRACT_ROLE");
    bytes32 private constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 private constant PRIVATE_ROLE = keccak256("PRIVATE_ROLE");
    bytes32 private constant BRIDGE_ROLE = keccak256("BRIDGE_ROLE");

    function __StandardAccessControl_init() internal onlyInitializing {
        __AccessControlEnumerable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(CONTRACT_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(PRIVATE_ROLE, msg.sender);
        _grantRole(BRIDGE_ROLE, msg.sender);
    }

    modifier onlyDefaultAdmin() {
        _checkRole(DEFAULT_ADMIN_ROLE);
        _;
    }

    modifier onlyAdmin() {
        _checkRole(ADMIN_ROLE);
        _;
    }
    modifier onlyContract() {
        _checkRole(CONTRACT_ROLE);
        _;
    }
    modifier onlyMinter() {
        _checkRole(MINTER_ROLE);
        _;
    }
    modifier onlyPrivate() {
        _checkRole(PRIVATE_ROLE);
        _;
    }

    modifier onlyBridge() {
        _checkRole(BRIDGE_ROLE);
        _;
    }

    function _hasDefaultAdminRole(address _address) internal view returns(bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, _address);
    }

    function _hasAdminRole(address _address) internal view returns(bool) {
        return hasRole(ADMIN_ROLE, _address);
    }

    function _hasContractRole(address _address) internal view returns(bool) {
        return hasRole(CONTRACT_ROLE, _address);
    }

    function _hasMinterRole(address _address) internal view returns(bool) {
        return hasRole(MINTER_ROLE, _address);
    }

    function _hasPrivateRole(address _address) internal view returns(bool) {
        return hasRole(PRIVATE_ROLE, _address);
    }

    function _hasBridgeRole(address _address) internal view returns(bool) {
        return hasRole(BRIDGE_ROLE, _address);
    }

    function _checkRoles(bytes32[] calldata roles) internal view virtual {
        _checkRoles(roles, msg.sender);
    }

    function _checkRoles(bytes32[] calldata roles, address account) internal view virtual {
        for (uint256 i = 0; i < roles.length; i++) {
            if (hasRole(roles[i], account)) {
                return;
            }
        }
        revert(
            string(
                abi.encodePacked(
                    "AccessControl: account ",
                    StringsUpgradeable.toHexString(account),
                    " is missing role all roles"
                )
            )
        );
    }

    uint256[46] private __gap;
}