const { ethers, upgrades } = require("hardhat")
require("dotenv").config()

const args = [1000, 100, "0xd2578a0b2631e591890f28499e9e8d73f21e5895", 1000]

async function main(name) {
  console.log("Starting deployment...")
  const contractFactory = await ethers.getContractFactory(name)
  console.log("Deploying", name)
  const contract = await upgrades.deployProxy(contractFactory, args)
  console.log(name, "deployed! Address:", contract.address)
}

module.exports = {
  args
}

main("MarketUpgradeable")
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })