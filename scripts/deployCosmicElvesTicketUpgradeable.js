const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")
require("dotenv").config()

// 0x2cD53F2cf71453A9Af89E8bD3285C2E2E730425E
async function deploy(name) {
    // Deploying
    console.log("Starting deployment...")
    const Contract = await ethers.getContractFactory(name)
    console.log("Deploying " + name)
    const contract = await upgrades.deployProxy(Contract)
    await contract.deployed()
    console.log(name + " deployed! Address:", contract.address)
    return {name, address: contract.address}
}

async function main(name) {
    await deploy(name)
}

main("CosmicElvesTicketUpgradeable")
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })