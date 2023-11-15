// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


import "../../../ERC1155/interfaces/ICosmicBundles.sol";
import "../../../ERC721/interfaces/ICosmicWizards.sol";
import "../../../utils/ContractConstants.sol";
import "./IProfessionStakingAvalanche.sol";

/**
* @title Staking Rewards Claim Avalanche v1.0.0
* @author @DirtyCajunRice
*/
contract StakingRewardsClaimAvalanche is Initializable, PausableUpgradeable, AccessControlEnumerableUpgradeable,
ContractConstants {
    // constants
    ICosmicWizards public constant WIZARDS = ICosmicWizards(0xBF20c23D25Fca8Aa4e7946496250D67872691Af2);
    ICosmicBundles public constant BUNDLES = ICosmicBundles(0x04AB0F76De2D5ba63082193C66E8ce571A32454E);

    address private constant MARKETPLACE = 0x5202e45EbA7F58E350AA58B59dEB64a668654007;
    address private constant STAKING = 0x71e9e186DcFb6fd1BA018DF46d21e7aA10969aD1;

    event ChestClaimed(address indexed from, uint256 tokenID, uint256 chestId);
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Pausable_init();
        __AccessControlEnumerable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(CONTRACT_ROLE, _msgSender());

    }

    function claim(uint256 tokenId) public whenNotPaused {
        (address owner, uint256 points, uint256 claimed) = checkEligibility(tokenId);

        require(points >= 20, "Rewards Claim: Insufficient level");
        require(claimed < 2, "Rewards Claim: All rewards claimed");
        require(claimed == 0 || (claimed == 1 && points == 40), "Rewards Claim: Eligible rewards already claimed");
        require(owner != MARKETPLACE, "Rewards Claim: Cannot be on sale");
        require(owner != STAKING, "Rewards Claim: Cannot be in staking contract");
        if (points >= 20 && claimed == 0) {
            // claim level 20 chest
            BUNDLES.mint(owner, 0, 1, "");
            WIZARDS.updateSkill(tokenId, 2, 0, 1);
            emit ChestClaimed(owner, tokenId, 0);
        }
        if (points == 40 && claimed <= 1) {
            BUNDLES.mint(owner, 1, 1, "");
            WIZARDS.updateSkill(tokenId, 2, 0, 2);
            emit ChestClaimed(owner, tokenId, 1);
        }
    }

    function batchClaim(uint256[] memory tokenIds) public whenNotPaused {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            claim(tokenIds[i]);
        }
    }

    function stakedClaim(uint256 tokenId, address owner) public whenNotPaused {
        (, uint256 points, uint256 claimed) = checkEligibility(tokenId);
        IProfessionStakingAvalanche staking = IProfessionStakingAvalanche(STAKING);
        require(staking.isOwner(tokenId, owner), "Rewards Claim: Not staking Owner");
        require(points >= 20, "Rewards Claim: Insufficient level");
        require(claimed < 2, "Rewards Claim: All rewards claimed");
        require(claimed == 0 || (claimed == 1 && points == 40), "Rewards Claim: Eligible rewards already claimed");
        require(owner != MARKETPLACE, "Rewards Claim: Cannot be on sale");
        if (points >= 20 && claimed == 0) {
            // claim level 20 chest
            BUNDLES.mint(owner, 0, 1, "");
            WIZARDS.updateSkill(tokenId, 2, 0, 1);
            emit ChestClaimed(owner, tokenId, 0);
        }
        if (points == 40 && claimed <= 1) {
            BUNDLES.mint(owner, 1, 1, "");
            WIZARDS.updateSkill(tokenId, 2, 0, 2);
            emit ChestClaimed(owner, tokenId, 1);
        }
    }

    function batchStakedClaim(uint256[] memory tokenIds, address[] memory owners) public whenNotPaused {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            stakedClaim(tokenIds[i], owners[i]);
        }
    }

    function checkEligibility(uint256 tokenId) public view returns(address owner, uint256 points, uint256 claimed) {
        points = getTotalProfessionSkillPoints(tokenId);
        claimed = WIZARDS.getSkill(tokenId, 2, 0);
        owner = WIZARDS.ownerOf(tokenId);
    }

    function getTotalProfessionSkillPoints(uint256 tokenId) internal view returns(uint256) {
        uint256 totalSkillPoints = 0;
        for (uint256 i = 0; i < 12; i++) {
            uint256 points = WIZARDS.getSkill(tokenId, 1, i);
            totalSkillPoints += points;
        }
        return totalSkillPoints;
    }

    function pause() public onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(ADMIN_ROLE) {
        _unpause();
    }
}