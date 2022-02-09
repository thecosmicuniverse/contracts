// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract CosmicGuild is ERC721Enumerable, Ownable {
    using Strings for uint256;
    uint256 public constant NFT_MAX = 12000;
    IERC20 private MAGIC ;
    string private _tokenBaseURI = "";
    string private _tokenRevealedBaseURI = "";
    // Epoch time set Sunday, February 20, 2022 3:00:00 PM GMT
    uint256 private _startTime = 1645369200;
    string private revealedBaseURI;
    uint256 private tokenId;
    address private withdrawalWallet;
    //Land Array
    mapping(uint256 => uint256) public landPrice;
    mapping(address => uint256) public whitelistUser;
    uint256[] public soldTokens;
    // address[] public whitelistUser;
    function isLandAvailable(uint256 _tokenId)
        public view
        returns (bool) {
            if(_exists(_tokenId) == true)return false; // Not sold out
            return (landPrice[_tokenId] != 0);
        }
    modifier isLandAvailableMod(uint256 _tokenId) {
        require(isLandAvailable(_tokenId), "Token is not Land or Sold out ");
        _;
    }
    modifier isLive() {
        require(block.timestamp >= (_startTime - 86400), "Sale hasn't started");
        _;
    }
    modifier canPurchase() {
        uint256 PURCHASE_LIMIT = (block.timestamp >= (_startTime - 86400) ) ? 75 : 10; // presale will start before 24 hours
        require(
            balanceOf(msg.sender) < PURCHASE_LIMIT,
            "Requested number exceeds purchase limit"
        );
        _;
    }
    // function isIndexBefore(uint n) private view returns(bool){
    //     for(uint i = 0;i<n;i++){
    //         if(whitelistUser[i] == msg.sender)return true;
    //     }
    //     return false;
    // }
    // modifier isWhiteListed(){
    //     if(block.timestamp >= _startTime) {
    //         // Everyone can purchase
    //     }else if(block.timestamp >= (_startTime - 28800)){
    //         // Tier 1 (before 8 hour of sale start)
    //         require(isIndexBefore(1000),"Tier 1 or above allowed");
    //     }else if(block.timestamp >= (_startTime - 56600)){
    //         // Tier 2 (before 16 hour of sale)
    //         require(isIndexBefore(500),"Tier 2 or above allowed");
    //     }else if(block.timestamp >= (_startTime - 86400)){
    //         // Tier 3 (before 24 hour of sale)
    //         require(isIndexBefore(250),"Tier 3 or above allowed");
    //     }else require(false,"Sale is not Start yet");
    //     _;
    // }
    modifier isWhiteListed(){
        if(block.timestamp >= _startTime) {
             // Everyone can purchase
        }else if(block.timestamp >= (_startTime - 28800)){
            // Tier 1 (before 8 hour of sale start)
            require(whitelistUser[msg.sender] >=1,"Tier 1 or above allowed");
        }else if(block.timestamp >= (_startTime - 56600)){
            // Tier 2 (before 16 hour of sale)
            require(whitelistUser[msg.sender] >=2,"Tier 2 or above allowed");
        }else if(block.timestamp >= (_startTime - 86400)){
            // Tier 3 (before 24 hour of sale)
            require(whitelistUser[msg.sender] >=3,"Tier 3 or above allowed");
        }else require(false,"Sale is not Start yet");
        _;
    }
    event Purchase(address receiver, uint256 tokenId);
    constructor(string memory name, string memory symbol, address wallet, address magic)
        ERC721(name, symbol)
    {
        withdrawalWallet = wallet;
        MAGIC = IERC20(magic);
    }
    function purchase(uint256 _tokenId)
        external
        payable
        isLive
        isLandAvailableMod(_tokenId)
        canPurchase
        isWhiteListed
    {
        require(NFT_MAX > _tokenId, "TokenID not within range");
        // require(
        //     PRICE <= msg.value,
        //     "ETH amount is not sufficient"
        // );
        MAGIC.transferFrom(msg.sender,withdrawalWallet,landPrice[_tokenId]);
        soldTokens.push(_tokenId);
        _safeMint(msg.sender, _tokenId);
        emit Purchase(msg.sender, _tokenId);
    }
    
    function soldTokensAll() public view returns( uint256 [] memory) {
        uint256[] memory tokenAll = new uint256[](soldTokens.length);
        for (uint i = 0; i < soldTokens.length; i++) {
          tokenAll[i] = soldTokens[i];
        }
        return tokenAll;
    }
    function setLandPriceArr(uint256 price,uint256[] memory _arr) external onlyOwner {
        for(uint i = 0 ; i < _arr.length;i++){
            landPrice[_arr[i]] = price;
        }
    }
    function setWhiteListArr(uint tier,address[] memory _arr) external onlyOwner {
        for(uint i = 0 ; i < _arr.length;i++){
            // whitelistUser.push(_arr[i]);
            whitelistUser[_arr[i]] = tier;
        }
    }
    function setStartTime(uint256 newTime) external onlyOwner {
        _startTime = newTime;
    }
    function withdraw() external {
        require(msg.sender == withdrawalWallet, "Only withdrawal wallet can access");
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
    function setBaseURI(string calldata URI) external onlyOwner {
        _tokenBaseURI = URI;
    }
    function setRevealedBaseURI(string calldata _revealedBaseURI)
        external
        onlyOwner
    {
        _tokenRevealedBaseURI = _revealedBaseURI;
    }
    function tokenURI(uint256 _tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        require(_exists(_tokenId), "Token does not exist");
        /// @dev Convert string to bytes so we can check if it's empty or not.
        return
            bytes(_tokenRevealedBaseURI).length > 0
                ? string(
                    abi.encodePacked(_tokenRevealedBaseURI, _tokenId.toString())
                )
                : _tokenBaseURI;
    }
}
