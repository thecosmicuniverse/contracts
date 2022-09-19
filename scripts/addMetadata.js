const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")
const fs = require('fs');
require("dotenv").config()

async function main(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])

  const tokenIds = await contract.getAllTokenIds();
  console.log(`${tokenIds.length} Wizards minted`);
  const tokenURIs = await contract.batchTokenURI(tokenIds.slice(0, 100));
  console.log(tokenURIs.length);
  //let raw = fs.readFileSync(`./scripts/metadata/wizards3d/allSkills.json`);
  //let parsedSkills = JSON.parse(raw);
  //const tokenIds = [];
  //const treeIds = [];
  //const skillIds = [];
  //const values = [];
  //for (const sid of Object.keys(parsedSkills)) {
  //  const skills = parsedSkills[sid];
  //  tokenIds.push(sid);
  //  treeIds.push(0);
  //  skillIds.push(9);
  //  values.push(Number(skills.unlocked))
  //  skills.profession.map((p, i) => {
  //    const val = Number(p);
  //    if (val > 0) {
  //      tokenIds.push(sid);
  //      treeIds.push(1);
  //      skillIds.push(i);
  //      values.push(val)
  //    }
  //  })
  //}
  //let batchSize = 250;
  //let finished = 0;
  //while (finished < tokenIds.length) {
  //  console.log(`Updating ${finished} to ${finished+batchSize}`)
  //  const batchTokens = tokenIds.slice(finished, finished+batchSize)
  //  const batchTrees = treeIds.slice(finished, finished+batchSize)
  //  const batchSkills = skillIds.slice(finished, finished+batchSize)
  //  const batchValues = values.slice(finished, finished+batchSize)
  //  const tx = await contract.batchUpdateSkills(batchTokens, batchTrees, batchSkills, batchValues);
  //  await tx.wait(1)
  //  finished += batchSize
  //}
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

const condenseLand = async () => {
  const failed = []
  const allMetadata = {}
  for (let i = 1; i < 11665; i++) {
    const raw = fs.readFileSync(`./scripts/metadata/land/${i}.json`, { encoding:'utf8', flag:'r' })
    try {
      allMetadata[i] = JSON.parse(raw)
    } catch (e) {
      failed.push(i)
    }
  }
  if (failed.length > 0) {
    console.log("failed...", failed);
    return;
  }
  fs.writeFileSync("./scripts/metadata/land.json", JSON.stringify(allMetadata), {
    encoding: "utf8",
    flag: "w",
    mode: 0o666
  })
}

const updateLandPlotMetadata = async () => {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt("CosmicIslandLandUpgradeable", "0x2fa83f2Fa89F275863B9491b1802dFeA5A130024", accounts[0])
  const raw = fs.readFileSync("./scripts/metadata/land.json", { encoding:'utf8', flag:'r' })
  const allMetadata = JSON.parse(raw);

  const regions = ["road", "water", "elysian fields", "enchanted forest", "mystic alpines", "forest of whimsy"]

  const tokenIds = [];
  const attrIds = [];
  const values = [];
  for (const tokenIdStr of Object.keys(allMetadata)) {
    const tokenId = Number(tokenIdStr)
    if (tokenId < 10000) {
      console.log("Skipping", tokenId)
      continue;
    }

    const [latStr, longStr] = allMetadata[tokenIdStr].attributes[0].value.split(", ")
    let lat = Number(latStr);
    let long = Number(longStr);
    const region = allMetadata[tokenIdStr].attributes[1].value.toLowerCase()
    const regionEnum = regions.indexOf(region)
    if (regionEnum < 0) {
      console.log("Could not find region for", region)
      return;
    }
    if (regionEnum < 2) {
      console.log("Skipping NPC land", tokenId)
      continue
    }
    for (let i = 0; i < 3; i++) {
      tokenIds.push(tokenId)
      attrIds.push(i)
    }
    if (lat < 0) {
      lat = (lat * -1) + 100
    }
    if (long < 0) {
      long = (long * -1) + 100
    }
    values.push(lat)
    values.push(long)
    values.push(regionEnum)
    console.log("Added values for", tokenId)
  }
  console.log("Total updates needed:", tokenIds.length, tokenIds.length / 3)
  let batchSize = 250;
  let finished = 0;
  while (finished < tokenIds.length) {
    console.log(`Updating ${finished} to ${finished+batchSize}`)
    const batchTokens = tokenIds.slice(finished, finished+batchSize)
    const batchAttrs = attrIds.slice(finished, finished+batchSize)
    const batchValues = values.slice(finished, finished+batchSize)
    const tx = await contract.setTokenURIs(batchTokens, batchAttrs, batchValues);
    await tx.wait(1)
    finished += batchSize
  }
}
//mainHmy("GameStorageUpgradeable", "0xdc0B143afD1c806d142617f99c5eE037Df4bA28f")
//  .then(() => process.exit(0))
//  .catch((error) => {
//    console.error(error)
//    process.exit(1)
//  })
//main("CosmicWizardsUpgradeable", "0xbf20c23d25fca8aa4e7946496250d67872691af2")
updateLandPlotMetadata()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })