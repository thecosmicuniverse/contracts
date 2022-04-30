const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")
require("dotenv").config()

async function deploy(name, address) {
    // Deploying
    console.log("Starting deployment...")
    const Contract = await ethers.getContractFactory(name)
    console.log("Deploying " + name)
    const contract = await upgrades.upgradeProxy(address, Contract)
    await contract.deployed()
    console.log(name + " deployed! Address:", contract.address)
    return {name, address: contract.address}
}

async function main(name, address) {
    await deploy(name, address)
}

main("GameStorageUpgradeableV2", "0x53f0E805bDFa8418213aC7e306e1C0B6c9e44714")
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })