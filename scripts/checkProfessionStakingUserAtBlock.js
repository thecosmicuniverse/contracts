const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")
const {BigNumber} = require('ethers');

require("dotenv").config()

async function main(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])
  const [addresses, nfts, rewards] = await contract.getAllParticipantData();
  console.log(`${addresses.length} wallets`)
  console.log(`${nfts.flat().length} wizards`)
  let batchSize = 1;
  let finished = 0;
  for (const address of addresses) {
    console.log(`Unstaking for ${address}`)
    try {
      const tx = await contract.claimAndUnstakeForUser(address);
      await tx.wait(1)
    } catch (e) {
      console.log(`${address} has active training`)
    }
    finished += batchSize
  }

  //let totalRewards = BigNumber.from(0)
  //let counted = 1;
  //for (const address of addresses) {
  //  console.log(`Getting rewards for ${address} (${counted}/${addresses.length})`)
  //  const pending = await contract.pendingRewardsOf(address);
  //  totalRewards = totalRewards.add(pending)
  //  counted++;
  //}
  //console.log(`${addresses.length} wallets`)
  //console.log(`${nfts.flat().length} wizards`)
  //console.log(`${ethers.utils.formatEther(setRewards)} MAGIC pre-claimed`)
  //console.log(`${ethers.utils.formatEther(totalRewards)} MAGIC total to claim`)
}


main("ProfessionStakingHarmonyUpgradeable", "0x8Dfc57c1c1032e08f3DF6C71A6d8b8EF88a7aC21")
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
