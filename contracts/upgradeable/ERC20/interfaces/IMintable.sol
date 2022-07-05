// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IMintable {
    function mint(address to, uint256 amount) external;
    function batchMint(address to, uint256[] memory ids) external;
    function bridgeMint(address to, uint256 id) external;
    function burn(address account, uint256 amount) external;
}
