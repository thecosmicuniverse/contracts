const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")

require("dotenv").config()

async function main(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])
  const trainingFinishedFilter = contract.filters.TrainingFinished();
  let startBlock = 26853942
  let finishBlock = await contract.provider.getBlockNumber()
  const queryFilter = {
    address: contract.address,
    topics: contract.filters.ClaimBlocked().topics
  }
  let from = startBlock
  let to = finishBlock - startBlock > 500 ? startBlock + 499 : finishBlock;
  while (from < finishBlock) {
    console.log(`Getting events from block ${from} to block ${to}`)
    const events = await contract.queryFilter(queryFilter, from, to);
    console.log(`processing ${events.length} events`)
    from = to + 1
    to = finishBlock - from > 500 ? from + 499 : finishBlock;
    for (const event of events) {
      console.log(`---------------------------------------`)
      console.log(`Address: ${event.args.from}`)
      console.log(`Wizards staked: ${event.args.stakedCount.toNumber()}`)
      console.log(`Claim attempt amount: ${ethers.utils.formatEther(event.args.amount)}`)
      console.log(`Block: ${event.blockNumber}`)
      console.log(`Block: ${event.transactionHash}`)
    }
  }
}

async function main2(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])
  const trainingFinishedFilter = contract.filters.TrainingFinished();
  let startBlock = 26853942
  let finishBlock = await contract.provider.getBlockNumber()
  const queryFilter = {
    address: contract.address,
    topics: contract.filters.TrainingStarted().topics
  }
  const queryFilter2 = {
    address: contract.address,
    topics: contract.filters.TrainingFinished().topics
  }
  const queryFilter3 = {
    address: contract.address,
    topics: contract.filters.TrainingCanceled().topics
  }
  const queryFilter4 = {
    address: contract.address,
    topics: contract.filters.Unstaked().topics
  }
  let from = startBlock
  let to = finishBlock - startBlock > 1000 ? startBlock + 999 : finishBlock;
  while (from < finishBlock) {
    console.log(`Getting events from block ${from} to block ${to}`)
    const events = await contract.queryFilter(queryFilter, from, to);
    const events2 = await contract.queryFilter(queryFilter2, from, to);
    const events3 = await contract.queryFilter(queryFilter3, from, to);
    const events4 = await contract.queryFilter(queryFilter4, from, to);
    console.log(`processing ${events.length} events`)
    from = to + 1
    to = finishBlock - from > 1000 ? from + 999 : finishBlock;
    const Events = Array.prototype.concat(events, events2, events3, events4).filter(e => e !== undefined)
    for (const event of Events) {
      const who = event.args.from || event.args.by
      if (who !== "0x34E32bD8c570FDa2F11edE2C49bC68B0D0B3877B" || !event.args.tokenId.eq(1533)) {
        continue;
      }
      console.log(event)
    }
  }
}


main2("ProfessionStakingUpgradeable", "0x8Dfc57c1c1032e08f3DF6C71A6d8b8EF88a7aC21")
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })