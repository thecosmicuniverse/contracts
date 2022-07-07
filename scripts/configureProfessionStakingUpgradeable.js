const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")
require("dotenv").config()

async function configure() {
    const accounts = await ethers.getSigners()

    const contract = await ethers.getContractAt("ProfessionStakingUpgradeable", "0x71e9e186dcfb6fd1ba018df46d21e7aa10969ad1", accounts[0])
    const tx = await contract.setTrainingLevelConfig(
      "0xBF20c23D25Fca8Aa4e7946496250D67872691Af2",
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
      [0,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79].map(t => t*60*60),
      [20, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90].map(c => ethers.utils.parseEther(`${c}.0`))
    )
    //const tx = await contract.createStakingConfig(
    //  "0xBF20c23D25Fca8Aa4e7946496250D67872691Af2",
    //  "0x9A8E0217cD870783c3f2317985C57Bf570969153",
    //  Math.round(Date.now() / 1000) + 30,
    //  20,
    //  1,
    //  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    //)
    await tx.wait(1)
    console.log(tx)
}

configure()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })