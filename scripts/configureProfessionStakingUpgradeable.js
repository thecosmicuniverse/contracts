const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")
require("dotenv").config()

const levels = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
const costs = [20, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90]
  .map(c => ethers.utils.parseEther(`${c}.0`))
const times = [0,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79].map(t => t*60*60)

const stakingConfigNftAddress = '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B' // Wizards 3D
const stakingConfigRewardToken = '0x892D81221484F690C0a97d3DD18B9144A3ECDFB7' // MAGIC
const stakingConfigStartTime = Math.round(Date.now() / 1000) + 30
const stakingConfigMaxPointsPerSkill = 20
const stakingConfigTreeIds = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
const stakingConfigSkillIds = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
async function configure() {
    const accounts = await ethers.getSigners()

    const contract = await ethers.getContractAt("ProfessionStakingUpgradeable", "0x8Dfc57c1c1032e08f3DF6C71A6d8b8EF88a7aC21", accounts[0])
    // const tx = await contract.batchSetTrainingCosts(levels, costs, times)
    const tx = await contract.createStakingConfig(stakingConfigNftAddress, stakingConfigRewardToken, stakingConfigStartTime, stakingConfigMaxPointsPerSkill, stakingConfigTreeIds, stakingConfigSkillIds)
    await tx.wait(1)
    console.log(tx)
}

configure()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })