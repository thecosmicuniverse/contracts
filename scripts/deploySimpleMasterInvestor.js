const { ethers, upgrades } = require("hardhat")
require("dotenv").config()

const GOV_TOKEN = '0x9A8E0217cD870783c3f2317985C57Bf570969153'
const REWARD_PER_SECOND = ethers.utils.parseEther("0.5");
const START_TIME = 1656849600; // Sunday, July 3, 2022 12:00:00 GMT

const DEV_FEE_STAGES = [25, 8, 4, 2, 1, 5, 25, 1];
const USER_FEE_STAGES = [75, 92, 96, 98, 99, 995, 9975, 9999];
const USER_DEPOSIT_FEE = 1;
const DEV_DEPOSIT_FEE = 1;

const DEV_ADDRESS = '0xD2578A0b2631E591890f28499E9E8d73F21e5895';
const LP_ADDRESS = '0xD2578A0b2631E591890f28499E9E8d73F21e5895';
const COMMUNITY_FUND_ADDRESS = '0xD2578A0b2631E591890f28499E9E8d73F21e5895';
const FOUNDER_ADDRESS = '0xD2578A0b2631E591890f28499E9E8d73F21e5895';

const args = [{
  govToken: GOV_TOKEN,
  rewardPerSecond: REWARD_PER_SECOND,
  startTime: START_TIME,
  userDepositFee: USER_DEPOSIT_FEE,
  devDepositFee: DEV_DEPOSIT_FEE,
  devFundAddress: DEV_ADDRESS,
  feeShareFundAddress: LP_ADDRESS,
  marketingFundAddress: COMMUNITY_FUND_ADDRESS,
  foundersFundAddress: FOUNDER_ADDRESS,
  userFeeStages: USER_FEE_STAGES,
  devFeeStages: DEV_FEE_STAGES,
}]

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

main("SimpleMasterInvestor")
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })