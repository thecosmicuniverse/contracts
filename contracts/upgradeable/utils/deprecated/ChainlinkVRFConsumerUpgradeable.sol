// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "../VRFConsumerBaseV2.sol";
import "../TokenConstants.sol";

abstract contract ChainlinkVRFConsumerUpgradeable is Initializable, VRFConsumerBaseV2Upgradeable,
AccessControlEnumerableUpgradeable, TokenConstants {
    VRFCoordinatorV2Interface private _coordinator;

    bytes32 private _keyHash;
    uint64 private _subscriptionId;
    uint16 _confirmations;

    function __ChainlinkVRFConsumer_init(
        address coordinator,
        bytes32 keyHash,
        uint64 subscriptionId,
        uint16 confirmations
    ) internal onlyInitializing {
        __AccessControlEnumerable_init();
        __VRFConsumerBaseV2_init(coordinator);
        __ChainlinkVRFConsumer_init_unchained(coordinator, keyHash, subscriptionId, confirmations);
    }

    function __ChainlinkVRFConsumer_init_unchained(
        address coordinator,
        bytes32 keyHash,
        uint64 subscriptionId,
        uint16 confirmations
    ) internal onlyInitializing {
        _coordinator = VRFCoordinatorV2Interface(coordinator);
        _subscriptionId = subscriptionId;
        _keyHash = keyHash;
        _confirmations = confirmations;
    }

    function requestRandomWords(uint32 count) internal returns(uint256 requestId) {
        uint32 gasLimit = (count * 20_000) + 100_000;
        return _coordinator.requestRandomWords(_keyHash, _subscriptionId, _confirmations, gasLimit, count);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal virtual override;

    uint256[46] private __gap;
}