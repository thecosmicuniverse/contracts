const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")

require("dotenv").config()

async function main(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])
  const lastSaleId = 5192;
  const blockNumber = 26865426;
  const filter = contract.filters.SaleCreated()
  const events = await contract.queryFilter({
    address: contract.address,
    topics: filter.topics
  }, blockNumber, blockNumber)
  console.log(events[0].args.saleId.toNumber())
}

main("MarketUpgradeable", "0xC8cEdDf1b1592B3ef5646aF733F14d8fF51a2656")
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })