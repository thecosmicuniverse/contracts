// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../interfaces/IERC5192.sol";

// ERC5192 Upgradeable Stateless Abstract
abstract contract ERC5192_U_S is IERC5192, Initializable {
    function __ERC5192_init() internal onlyInitializing {

    }

    /// @notice emit locked based on 0 (false) or 1 (true)
    function _emitLocked(uint256 tokenId, uint256 _locked) internal {
        if (_locked == 1) {
            emit Locked(tokenId);
        }
        else if (_locked == 0) {
            emit Unlocked(tokenId);
        }
    }

    function locked(uint256 tokenId) external virtual override view returns (bool);
}
