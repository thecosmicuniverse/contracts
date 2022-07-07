const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")
const fs = require('fs');
require("dotenv").config()

async function main(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])

  let raw = fs.readFileSync(`./scripts/metadata/wizards3d/allSkills.json`);
  let parsedSkills = JSON.parse(raw);
  const tokenIds = [];
  const treeIds = [];
  const skillIds = [];
  const values = [];
  for (const sid of Object.keys(parsedSkills)) {
    const skills = parsedSkills[sid];
    tokenIds.push(sid);
    treeIds.push(0);
    skillIds.push(9);
    values.push(Number(skills.unlocked))
    skills.profession.map((p, i) => {
      const val = Number(p);
      if (val > 0) {
        tokenIds.push(sid);
        treeIds.push(1);
        skillIds.push(i);
        values.push(val)
      }
    })
  }
  let batchSize = 250;
  let finished = 0;
  while (finished < tokenIds.length) {
    console.log(`Updating ${finished} to ${finished+batchSize}`)
    const batchTokens = tokenIds.slice(finished, finished+batchSize)
    const batchTrees = treeIds.slice(finished, finished+batchSize)
    const batchSkills = skillIds.slice(finished, finished+batchSize)
    const batchValues = values.slice(finished, finished+batchSize)
    const tx = await contract.batchUpdateSkills(batchTokens, batchTrees, batchSkills, batchValues);
    await tx.wait(1)
    finished += batchSize
  }
}

async function mainHmy(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])
  const skillIds = Array.from(Array(12).fill(0)).map((n,i) => i)
  const allSkills = {};
  const allTokens = Array.from(Array(9999).fill(1)).map((n, i) => n + i)
  const unlocked = await contract.getSkillOfTokens("0xdC59f32a58Ba536f639ba39C47cE9a12106b232B", allTokens, 0, 0);
  const allSkillsArrays = []
  for (const skillId of skillIds) {
    console.log("Getting skills for ", skillId)
    const skills = await contract.getSkillOfTokens("0xdC59f32a58Ba536f639ba39C47cE9a12106b232B", allTokens, 1, skillId);
    allSkillsArrays.push(skills)
  }

  for (let i = 0; i < 9999; i++) {
    const tokenId = i+1;
    allSkills[tokenId] = {
      profession: skillIds.map(s => allSkillsArrays[s][i].toString()),
      unlocked: unlocked[i].toString()
    }
  }
  fs.writeFileSync("./scripts/metadata/wizards3d/allSkills.json", JSON.stringify(allSkills), {
    encoding: "utf8",
    flag: "w",
    mode: 0o666
  })
  console.log();
}

//mainHmy("GameStorageUpgradeable", "0xdc0B143afD1c806d142617f99c5eE037Df4bA28f")
//  .then(() => process.exit(0))
//  .catch((error) => {
//    console.error(error)
//    process.exit(1)
//  })
main("CosmicWizardsUpgradeable", "0xBF20c23D25Fca8Aa4e7946496250D67872691Af2")
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })