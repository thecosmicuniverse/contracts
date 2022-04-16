const hre = require("hardhat");
const { ethers } = require("hardhat")
require("dotenv").config()

async function deploy(name) {
    // Deploying
    console.log("Starting deployment...")
    const contractFactory = await ethers.getContractFactory(name)
    console.log("Deploying " + name)
    const contract = await contractFactory.deploy()
    console.log(name + " deployed! Address:", contract.address)
    return {name, address: contract.address}
}

async function verify(contract) {
    console.log("Verifying " + contract.name)
    await hre.run("verify:verify", {
        address: contract.address
    })
}
async function main(name) {
    await deploy(name)
        .then(async (contract) => await verify(contract))
}

main("TestWizards2D")
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })