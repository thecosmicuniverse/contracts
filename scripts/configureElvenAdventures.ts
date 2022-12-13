import { BigNumberish } from 'ethers';
import hre, { ethers } from "hardhat";
const { getContractAt } = ethers
import { getContract } from '../tasks'
import "dotenv/config"

enum TokenType { ERC20, ERC1155, ERC721 }

type Reward = {
  _address: string;
  id: BigNumberish;
  amount: BigNumberish;
  tokenType: TokenType;
}

const potions = "0x146D129F1aeBae23422D1f4613C75fFE4087329C";
const bundles = "0x69938433cB243721978986a5B3c981A681970212";
const magic = "0x245B4C64271e91C9FB6bE1971A0208dD92EFeBDe";
const rawResources = "0xCE953D1A6be7331EEf06ec9Ac8a4a22a4f2BDfB0";
const rewards: Reward[] = [
  { _address: bundles, id: 2, amount: 1, tokenType: TokenType.ERC1155 }, // 1
  { _address: potions, id: 0, amount: 1, tokenType: TokenType.ERC1155 }, // 2
  { _address: bundles, id: 2, amount: 1, tokenType: TokenType.ERC1155 }, // 3
  { _address: bundles, id: 2, amount: 3, tokenType: TokenType.ERC1155 }, // 4
  { _address: potions, id: 1, amount: 1, tokenType: TokenType.ERC1155 }, // 5
  { _address: bundles, id: 2, amount: 3, tokenType: TokenType.ERC1155 }, // 6
  { _address: magic, id: 0, amount: ethers.utils.parseEther("100.0"), tokenType: TokenType.ERC20 }, // 7
  { _address: potions, id: 0, amount: 2, tokenType: TokenType.ERC1155 }, // 8
  { _address: bundles, id: 2, amount: 3, tokenType: TokenType.ERC1155 }, // 9
  { _address: "0x0458b679C30AA4B8622742eA9fb2A44660c4a2a1", id: 0, amount: 1, tokenType: TokenType.ERC721 }, // 10
  { _address: potions, id: 2, amount: 1, tokenType: TokenType.ERC1155 }, // 11
  { _address: bundles, id: 2, amount: 4, tokenType: TokenType.ERC1155 }, // 12
  { _address: bundles, id: 2, amount: 2, tokenType: TokenType.ERC1155 }, // 13
  { _address: potions, id: 1, amount: 2, tokenType: TokenType.ERC1155 }, // 14
  { _address: bundles, id: 2, amount: 4, tokenType: TokenType.ERC1155 }, // 15
  { _address: bundles, id: 2, amount: 4, tokenType: TokenType.ERC1155 }, // 16
  { _address: rawResources, id: 0, amount: 1, tokenType: TokenType.ERC1155 }, // 17
  { _address: magic, id: 0, amount: ethers.utils.parseEther("200.0"), tokenType: TokenType.ERC20 }, // 18
  { _address: rawResources, id: 0, amount: 1, tokenType: TokenType.ERC1155 }, // 19
  { _address: "0x9402aDCfb075155c245862a23F713C15E9CD71c7", id: 0, amount: 1, tokenType: TokenType.ERC1155 }, // 20
]
const configure = async () => {
  const accounts = await ethers.getSigners()
  if (hre.network.config.chainId !== 43288) {
    throw "Not using Boba network!";
  }
  const c = await getContract("ElvenAdventures", hre)
  const contract = await getContractAt("ElvenAdventures", c.address, accounts[0])

  const levels = Array.from(Array(20)).fill(1).map((v, i) => v + i)
  const tx1 = await contract.setRewards(levels, rewards)
  await tx1.wait()
  const time = [5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79].map(h => h * 3600)
  const tx2 = await contract.batchSetQuestTime(levels, time)
  await tx2.wait()
}

configure()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })