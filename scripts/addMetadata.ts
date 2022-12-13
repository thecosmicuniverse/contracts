import hre, { ethers } from 'hardhat';
import { getContract } from '../tasks'
import ElvesAttributes from './metadata/elves'
import "dotenv/config"

const professions = ["Alchemy", "Architecture", "Carpentry", "Cooking", "Crystal Extraction", "Farming", "Fishing", "Gem Cutting", "Herbalism", "Mining", "Tailoring", "Woodcutting"];
const tools = ["Cauldron", "Drawing Set", "Woodworking Tools", "Cooking Utensils", "Extraction Wand", "Rope & Sickle", "Fishing Rod", "Grinding Stone", "Herbalism Kit", "Pickaxe", "Sewing Kit", "Axe"]
//async function main(name, address) {
//  const accounts = await ethers.getSigners()
//  const contract = await ethers.getContractAt(name, address, accounts[0])
//
//  const tokenIds = await contract.getAllTokenIds();
//  console.log(`${tokenIds.length} Wizards minted`);
//  const tokenURIs = await contract.batchTokenURI(tokenIds.slice(0, 100));
//  console.log(tokenURIs.length);
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
//}

//async function mainHmy(name, address) {
//  const accounts = await ethers.getSigners()
//  const contract = await ethers.getContractAt(name, address, accounts[0])
//  const skillIds = Array.from(Array(12).fill(0)).map((n,i) => i)
//  const allSkills = {};
//  const allTokens = Array.from(Array(9999).fill(1)).map((n, i) => n + i)
//  const unlocked = await contract.getSkillOfTokens("0xdC59f32a58Ba536f639ba39C47cE9a12106b232B", allTokens, 0, 0);
//  const allSkillsArrays = []
//  for (const skillId of skillIds) {
//    console.log("Getting skills for ", skillId)
//    const skills = await contract.getSkillOfTokens("0xdC59f32a58Ba536f639ba39C47cE9a12106b232B", allTokens, 1,
//    skillId);
//    allSkillsArrays.push(skills)
//  }
//
//  for (let i = 0; i < 9999; i++) {
//    const tokenId = i+1;
//    allSkills[tokenId] = {
//      profession: skillIds.map(s => allSkillsArrays[s][i].toString()),
//      unlocked: unlocked[i].toString()
//    }
//  }
//  fs.writeFileSync("./scripts/metadata/wizards3d/allSkills.json", JSON.stringify(allSkills), {
//    encoding: "utf8",
//    flag: "w",
//    mode: 0o666
//  })
//  console.log();
//}

// const condenseLand = async () => {
//   const failed = []
//   const allMetadata: any = {}
//   for (let i = 1; i < 11665; i++) {
//     const raw = fs.readFileSync(`./scripts/metadata/land/${i}.json`, { encoding:'utf8', flag:'r' })
//     try {
//       allMetadata[i] = JSON.parse(raw)
//     } catch (e) {
//       failed.push(i)
//     }
//   }
//   if (failed.length > 0) {
//     console.log("failed...", failed);
//     return;
//   }
//   fs.writeFileSync("./scripts/metadata/land.json", JSON.stringify(allMetadata), {
//     encoding: "utf8",
//     flag: "w",
//     mode: 0o666
//   })
// }

// const updateLandPlotMetadata = async () => {
//   const accounts = await ethers.getSigners()
//   const contract = await ethers.getContractAt("CosmicIslandLandUpgradeable",
//  "0x2fa83f2Fa89F275863B9491b1802dFeA5A130024", accounts[0])
//   const raw = fs.readFileSync("./scripts/metadata/land.json", { encoding:'utf8', flag:'r' })
//   const allMetadata = JSON.parse(raw);
//
//   const regions = ["road", "water", "elysian fields", "enchanted forest", "mystic alpines", "forest of whimsy"]
//
//   const tokenIds = [];
//   const attrIds = [];
//   const values = [];
//   for (const tokenIdStr of Object.keys(allMetadata)) {
//     const tokenId = Number(tokenIdStr)
//     if (tokenId < 10000) {
//       console.log("Skipping", tokenId)
//       continue;
//     }
//
//     const [latStr, longStr] = allMetadata[tokenIdStr].attributes[0].value.split(", ")
//     let lat = Number(latStr);
//     let long = Number(longStr);
//     const region = allMetadata[tokenIdStr].attributes[1].value.toLowerCase()
//     const regionEnum = regions.indexOf(region)
//     if (regionEnum < 0) {
//       console.log("Could not find region for", region)
//       return;
//     }
//     if (regionEnum < 2) {
//       console.log("Skipping NPC land", tokenId)
//       continue
//     }
//     for (let i = 0; i < 3; i++) {
//       tokenIds.push(tokenId)
//       attrIds.push(i)
//     }
//     if (lat < 0) {
//       lat = (lat * -1) + 100
//     }
//     if (long < 0) {
//       long = (long * -1) + 100
//     }
//     values.push(lat)
//     values.push(long)
//     values.push(regionEnum)
//     console.log("Added values for", tokenId)
//   }
//   console.log("Total updates needed:", tokenIds.length, tokenIds.length / 3)
//   let batchSize = 250;
//   let finished = 0;
//   while (finished < tokenIds.length) {
//     console.log(`Updating ${finished} to ${finished+batchSize}`)
//     const batchTokens = tokenIds.slice(finished, finished+batchSize)
//     const batchAttrs = attrIds.slice(finished, finished+batchSize)
//     const batchValues = values.slice(finished, finished+batchSize)
//     const tx = await contract.setTokenURIs(batchTokens, batchAttrs, batchValues);
//     await tx.wait(1)
//     finished += batchSize
//   }
// }

//const setMetadata = async () => {
//  const accounts = await ethers.getSigners()
//  const contract1 = await ethers.getContractAt("CosmicRawResources", "0xF31dC5F3A6D0af979FC3D8ad7A216E2eA49a1Cb1",
//  accounts[0])
//  const contract2 = await ethers.getContractAt("CosmicRefinedResources",
//  "0xEacF75f43674a85eae7679E4A67C7FEF004CC7CB", accounts[0])
//  const professions = ["Alchemy", "Architecture", "Carpentry", "Cooking", "Crystal Extraction", "Farming",
//  "Fishing", "Gem Cutting", "Herbalism", "Mining", "Tailoring", "Woodcutting"]
const names = ("Cauldron", "Drawing Set", "Woodworking Tools", "Cooking Utensils", "Extraction Wand", "Rope & Sickle", "Fishing Rod", "Grinding Stone", "Herbalism Kit", "Pickaxe", "Sewing Kit", "Axe")
//  const componentNames = ["Empty Vial", "Parchment", "Nails", "Seasoning", "Te Kore Salt", "Compost", "Fish
//  Bones", "Polish", "Bugs", "Flint", "Thread", "Sticks"]
//  const componentSources = ["Vendor", "Vendor", "Vendor", "Vendor", "Byproduct", "Byproduct", "Byproduct",
//  "Vendor", "Byproduct", "Byproduct", "Vendor", "Byproduct"]
//  const resources = ["Hemp Paste", "Aloe Vera Paste", "Cosmic Poppy Paste", "Sandstone Bricks", "Copper Ingots",
//  "Limestone Bricks", "Pine Planks", "Birch Planks", "Bamboo Planks", "Forest Fish Fillet", "Chopped Potatoes", "Sliced Onions", "Raw Citrine", "Raw Amethyst", "Raw Tourmaline", "Carrots", "Potatoes", "Onions", "Forest Fish", "Zebra Tang", "Hermit Lionfish", "Pure Citrine", "Pure Amethyst", "Pure Tourmaline", "Hemp Leaves", "Aloe Vera", "Cosmic Poppy", "Sandstone Chunk", "Copper Ore", "Limestone Chunk", "Hemp Fibre", "Coconut Husk", "Flax", "Pine Log", "Birch Log", "Bamboo Log"]
//  const types = ['Potion', 'Potion', 'Elixir', 'Elixir']
//  const modifiers = ['Aptitude', 'Swiftness', 'Luck', 'Focus']
//  const rarity = ["Common", "Uncommon", "Rare", "Mythical", "Legendary"]
//  const descriptions = [
//    'increases the success chance of a Profession Expedition by 10%',
//    'decreases the time taken for a Profession Expedition by 20%',
//    `increases the rewards found during a successful Profession Expedition by 50%`,
//    `guarantees a rare item or above during a successful Profession Expedition of medium+ length`
//  ]
//  const boostNames = ["Success Chance", "Completion Speed", "Rewards", "Minimum Rarity"]
//
//  const rawIds = [];
//  const refinedIds = [];
//  // set strings
//  const attributeIds = [1000, 1001, 0, 1, 2];
//  let allTokenIds = [];
//  let allAttributeIds = [];
//  let allAttributeNames = [];
//
//  for (let i = 0; i < resources.length; i++) {
//    const professionId = Math.floor(i / 3)
//    const type = [0, 1, 2, 3, 7, 10].includes(professionId) ? 'Refined' : 'Raw';
//    const contract = type === 'Refined' ? contract2 : contract1;
//    const startingId = i * 5;
//    for (let j = 0; j < 4; j++) {
//      const tokenId = startingId + j;
//
//      if (type === 'Raw') {
//        allTokenIds = allTokenIds.concat([tokenId, tokenId, tokenId, tokenId, tokenId]);
//        allAttributeIds = allAttributeIds.concat(attributeIds)
//        allAttributeNames = allAttributeNames.concat([`${rarity[j]} ${resources[i]}`, `Cosmic Universe
//        ${type.toLowerCase()} resource used in ${professions[professionId]}`, professions[professionId], type, rarity[j]])
//      }
//      //const attributeNames = [`${rarity[j]} ${resources[i]}`, `Cosmic Universe ${type.toLowerCase()} resource
//      used in ${professions[professionId]}`, professions[professionId], type]
//      //console.log(attributeIds, attributeNames);
//      //const tx = await contract.batchSetAttributeName(tokenId, attributeIds, attributeNames);
//      //await tx.wait();
//    }
//  }
//  //let finished = 0;
//  //const batch = 150;
//  //const batches = Math.ceil((allTokenIds.length - finished) / batch);
//  //for (let i = 0; i < batches; i++) {
//  //  const begin = finished + (i * batch);
//  //  const end = begin + batch;
//  //  console.log("Sending ", begin, "to", end );
//  //  console.log(allTokenIds.slice(begin, end).length, allAttributeIds.slice(begin, end).length,
//  allAttributeNames.slice(begin, end).length)
//  //  const tx = await contract2.batchSetAttributeNames(allTokenIds.slice(begin, end),
//  allAttributeIds.slice(begin, end), allAttributeNames.slice(begin, end));
//  //  await tx.wait();
//  //}
//
//
//  //const boosts = [10, 20, 50, 2]
//  //// set attributes
//  //for (let i = 0; i < professions.length; i++) {
//  //  const attributeIds = [2]
//  //  const attributeValues = [boosts[i]]
//  //  console.log(attributeIds, attributeValues);
//  //  const tx = await contract.setAttribute(i, 2, boosts[i])
//  //  //const tx = await contract.batchSetAttribute(i, attributeIds, attributeValues)
//  //  await tx.wait();
//  //}
//
//  // mint
//  //const tokenIds = Array.from(Array(professions.length).fill(0)).map((v, i) => v + i);
//  const amounts = Array.from(Array(allTokenIds.slice(180, 400).length).fill(1))
//  //console.log("Minting", tokenIds, amounts);
//  const mintTx = await contract1.mintBatch(accounts[0].address, allTokenIds.slice(180, 400), amounts, []);
//  await mintTx.wait();
//  //const amounts = Array.from(Array(resources.length / 2).fill(1))
//  //console.log("Minting", rawIds, amounts);
//  //const mintTx = await contract.mintBatch(accounts[0].address, tokenIds, amounts, []);
//  //await mintTx.wait();
//}

const setToolsMetadata = async () => {
  console.log('asdf')
  const accounts = await ethers.getSigners()
  if (hre.network.config.chainId !== 43288) {
    throw "Not using Boba network!";
  }
  const c = await getContract("CosmicTools", hre)
  const contract = await ethers.getContractAt("CosmicTools", c.address, accounts[0])
  const professionIds = professions.map((v, i) => i);
  const txProfessions = await contract.batchSetSkillName(1, professionIds, professions);
  await txProfessions.wait();
  console.log(txProfessions)
  const toolsIds = tools.map((v, i) => i);
  const txNames = await contract.batchSetSkillName(100, toolsIds, tools);
  await txNames.wait();
  console.log(txNames)
}

const setElvesMetadata = async () => {
  const contract = await getContract("CosmicElves", hre)

  // Set Attribute Type Strings
  const attributeTypeStrings = ["Gender", "Skin Tone", "Headwear", "Hair", "Eyebrows", "Eyes", "Ears", "Mouth", "Attire", "Jewelry", "Staff"]
  // const ids = attributeTypeStrings.map((v, i) => i)
  // const tx = await contract.batchSetSkillName(0, ids, attributeTypeStrings)
  // await tx.wait();

  // Set Attribute Value Strings
  const genders = ["Male", "Female"]
  for (let genderId = 0; genderId < genders.length; genderId ++) {
    const gender = genders[genderId];
    const baseSkillNameId = genderId === 0 ? 0 : 11;
    for (let attrId = 0; attrId < attributeTypeStrings.length; attrId++) {
      if (attrId === 0) {
        const attributes = ["Male", "Female"]
        const ids = attributes.map((v, i) => i + baseSkillNameId);
        const tx = await contract.batchSetSkillName(1000 + attrId, ids, attributes);
        await tx.wait();
      } else {
        const attrType = attributeTypeStrings[attrId];
        const attributes = Object.keys(ElvesAttributes[gender][attrType.toLowerCase()])
        const ids = attributes.map((v, i) => i + baseSkillNameId);
        console.log("Setting", gender, "attributes for", attrType, "-", JSON.stringify(ids), JSON.stringify(attributes))
        const tx = await contract.batchSetSkillName(1000 + attrId, ids, attributes)
        await tx.wait();
      }
    }

  }
  // Set Professions Skill Names
  // const professions = ["Alchemy", "Architecture", "Carpentry", "Cooking", "Crystal Extraction", "Farming",
  // "Fishing", "Gem Cutting", "Herbalism", "Mining", "Tailoring", "Woodcutting"]
  // const ids = professions.map((v, i) => i)
  // const tx = await contract.batchSetSkillName(1, ids, professions)
  // await tx.wait();

  // Set Adventures skill names
  // const tx = await contract.batchSetSkillName(3, [0, 1, 2], ['Adventures Unlocked', 'On Adventure', 'On Expedition'])
  // await tx.wait();

  //return;
  //for (let i = 0; i < professions.length; i++) {
  //  for (let j = 0; j < 4; j++) {
  //    const tool = {
  //      skillId: i,
  //      durability: 0,
  //      rarity: j,
  //    }
  //    console.log(i, j);
  //    if ([0, 1, 2].includes(i) || (i === 3 && j !== 0) || i === 4 && j === 1) {
  //      console.log("skipping");
  //      continue;
  //    }
  //    const bytes = ethers.utils.AbiCoder.prototype.encode(['uint256', 'uint256', 'uint8'], [i, 0, j]);
  //    const tx = await contract['mint(address,bytes)'](accounts[0].address, bytes);
  //    await tx.wait();
  //  }
  //}
}

const MakeUEMetadata = async () => {

  // Set Attribute Type Strings
  const attributeTypeStrings = ["Skin Tone", "Headwear", "Hair", "Eyebrows", "Eyes", "Ears", "Mouth", "Attire", "Jewelry", "Staff"]
  // const ids = attributeTypeStrings.map((v, i) => i)
  // const tx = await contract.batchSetSkillName(0, ids, attributeTypeStrings)
  // await tx.wait();

  // Set Attribute Value Strings
  const genders = ["Male", "Female"]
  for (const gender of genders) {
    for (const attrType of attributeTypeStrings) {
      const attributes = Object.keys(ElvesAttributes[gender][attrType.toLowerCase()])
      console.log(gender, attrType, JSON.stringify(attributes).replace("[", "(").replace("]", ")"))
    }

  }
}
MakeUEMetadata()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })