import { getContract, getContractAndData } from "@dirtycajunrice/hardhat-tasks";
import { BigNumber } from "ethers";
import hre, { ethers } from 'hardhat';
import ElvesAttributes from '../metadata/elves'
import "dotenv/config"





const GetAffected = async () => {
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


GetAffected()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })