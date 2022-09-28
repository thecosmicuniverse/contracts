const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")
const fs = require('fs');
require("dotenv").config()

async function main() {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt("CosmicWizardsUpgradeable", "0xBF20c23D25Fca8Aa4e7946496250D67872691Af2", accounts[0])

  const tokenIds = [1638, 1658];
  const tokenId = tokenIds[1];

  const skillTree = 1;
  const skillIds = Array.from(Array(12).fill(0).map((n, i) => n + i));

  const bnSkills = await contract.getSkillsByTree(tokenId, skillTree, skillIds);
  const skills = bnSkills.map(s => s.toNumber());

  const skillInProgress = skills.find(v => v > 0 && v !== 20);

  if (!skillInProgress) {
    console.log("Error: No skill in progress. Skill values:", JSON.stringify(skills))
  }
  const skillIdOfSkillInProgress = skills.indexOf(skillInProgress);

  const tx = await contract.updateSkill(tokenId, skillTree, skillIdOfSkillInProgress, skillInProgress + 1);
  await tx.wait();

  console.log(`Updated ${tokenId}'s skill ${skillTree}-${skillIdOfSkillInProgress} to ${skillInProgress + 1}`)

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })