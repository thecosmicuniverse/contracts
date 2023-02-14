import { getContract, getContractAndData } from "@dirtycajunrice/hardhat-tasks";
import { BigNumber } from "ethers";
import hre, { ethers } from 'hardhat';
import ElvesAttributes from '../metadata/elves'
import "dotenv/config"





const SetAffected = async () => {
  const accounts = await ethers.getSigners()
  if (hre.network.config.chainId !== 43288) {
    throw "Not using Boba network!";
  }
  const txHash = "0x1dd64c272b71c3b87a14ac03559426d818cc9580e10721b0b2fb893d755af35b";
  const cr = await getContract("ChestRedeemer", hre)
  const ct = await getContract("CosmicTools", hre)
  const cb = await getContract("CosmicBundles", hre)
  const chestRedeemer = await ethers.getContractAt("ChestRedeemer", cr.address, accounts[0])
  const cosmicTools = await ethers.getContractAt("CosmicTools", ct.address, accounts[0])
  const cosmicBundles = await ethers.getContractAt("CosmicBundles", cb.address, accounts[0])


  const START_BLOCK = 35480
  const TO_BLOCK = 36924

  const toolMintEvents = await cosmicTools.queryFilter({
    address: cosmicTools.address,
    topics: cosmicTools.filters.Transfer(hre.ethers.constants.AddressZero).topics
  }, START_BLOCK, TO_BLOCK)

  const bundleBurnEvents = await cosmicBundles.queryFilter({
    address: cosmicBundles.address,
    topics: cosmicBundles.filters.TransferSingle(chestRedeemer.address, undefined, hre.ethers.constants.AddressZero).topics
  }, START_BLOCK, TO_BLOCK)
  const mythicBundleBurnEvents = bundleBurnEvents.filter(e => e.args.id.eq(BigNumber.from(1)))

  const mythicToolMintEvents = toolMintEvents.filter(e => !!mythicBundleBurnEvents.find(fe => fe.transactionHash === e.transactionHash));
  const mythicToolIds = mythicToolMintEvents.map(e => e.args.tokenId.toNumber())
  console.log(mythicToolIds)

  const tx = await chestRedeemer.addReRollEligibleIds(mythicToolIds);
  await tx.wait()
}

const UpdateDurability = async () => {
  const accounts = await ethers.getSigners()
  if (hre.network.config.chainId !== 43288) {
    throw "Not using Boba network!";
  }

  const cr = await getContract("ChestRedeemer", hre)
  const ct = await getContract("CosmicTools", hre)
  const chestRedeemer = await ethers.getContractAt("ChestRedeemer", cr.address, accounts[0])
  const cosmicTools = await ethers.getContractAt("CosmicTools", ct.address, accounts[0])

  const rarity = (n: BigNumber) => {
    return n.toNumber() === 3 ? "Mythical" : n.toNumber() === 2 ? "Rare" : n.toNumber() === 1 ? "Uncommon" : "Common"
  }

  const START_BLOCK = 58567 // First Tool ReRoll
  const TO_BLOCK = 58778 // Fixed Upgrade

  const reRolledEvents = await chestRedeemer.queryFilter({
    address: chestRedeemer.address,
    topics: chestRedeemer.filters.ToolRarityReRolled().topics
  }, START_BLOCK, TO_BLOCK)

  const rerolled = reRolledEvents.reduce((o, a) => {
    const args = a.args!!
    o[args.tokenId.toNumber()] = {
      Before: rarity(args.oldRarity),
      After: rarity(args.newRarity),
      Change: args.oldRarity.lte(args.newRarity) ? args.newRarity.sub(args.oldRarity).toNumber() : args.oldRarity.toNumber() - args.newRarity.toNumber()
    }
    return o
  }, {} as any)

  const declinedEvents = await chestRedeemer.queryFilter({
    address: chestRedeemer.address,
    topics: chestRedeemer.filters.ToolRarityReRollDeclined().topics
  }, START_BLOCK, TO_BLOCK)

  const declined = declinedEvents.reduce((o, a) => {
    const args = a.args!!
    o[args.tokenId.toNumber()] = {
      Before: rarity(args.rarity),
      After: "Declined",
      Change: "-"
    }
    return o
  }, {} as any)

  const eligibleIds = await chestRedeemer.reRollEligible();

  const rarities = await Promise.all(eligibleIds.map(async (id) => await cosmicTools.getSkill(id, 0, 1)))
  const eligible = eligibleIds.reduce((o, a, i) => {
    o[a.toNumber()] = {
      Before: rarity(rarities[i]),
      After: "?",
      Change: "?"
    }
    return o
  }, {} as any)


  console.table({...eligible, ...declined, ...rerolled})
}

UpdateDurability()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })