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

main("GameStorageUpgradeable", "0xdc0B143afD1c806d142617f99c5eE037Df4bA28f")
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })