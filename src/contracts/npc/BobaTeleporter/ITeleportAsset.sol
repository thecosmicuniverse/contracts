// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ITeleportAsset {
    // ERC721
    function teleport(uint256 tokenId) external;
    // ERC20
    function teleport(address wallet, uint256 amount) external;
    // ERC1155
    function teleport(address wallet, uint256 id, uint256 amount) external;

    // ERC20 / ERC721
    function balanceOf(address account) external view returns (uint256);
    function tokensOfOwner(address owner) external view returns (uint256[] memory);
    // ERC1155
    function balanceOf(address account, uint256 id) external view returns (uint256);

    // ERC721
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    // ERC20
    function mint(address account, uint256 amount, bytes memory) external;
    // ERC1155
    function mint(address account, uint256 id, uint256 amount, bytes memory data) external;
    // ERC721
    function mint(address account, uint256 tokenId) external;
}
