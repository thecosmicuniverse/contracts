import { getContract, getContractAndData } from "@dirtycajunrice/hardhat-tasks";
import { BigNumber, BigNumberish, utils } from "ethers";
import hre, { ethers } from 'hardhat';
import ElvesAttributes from '../metadata/elves'
import "dotenv/config"

const professions = ["Alchemy", "Architecture", "Carpentry", "Cooking", "Crystal Extraction", "Farming", "Fishing", "Gem Cutting", "Herbalism", "Mining", "Tailoring", "Woodcutting"];
const tools = ["Cauldron", "Drawing Set", "Woodworking Tools", "Cooking Utensils", "Extraction Wand", "Rope & Sickle", "Fishing Rod", "Grinding Stone", "Herbalism Kit", "Pickaxe", "Sewing Kit", "Axe"]
const rarities = ["Common", "Uncommon", "Rare", "Mythical", "Legendary"]

const BUNDLES = "0x69938433cB243721978986a5B3c981A681970212";
const MAGIC = "0x245B4C64271e91C9FB6bE1971A0208dD92EFeBDe";
const POTIONS = "0x146D129F1aeBae23422D1f4613C75fFE4087329C";

const MINTER_ROLE = "0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6";

enum TokenType { ERC20, ERC1155, ERC721 }
enum Location { Treasury, Burn, Mint, Local }

type Token = {
  tokenType: TokenType;
  location: Location;
  _address: `0x${string}`;
  id: number;
  quantity: BigNumberish;
}

type Item = {
  cost: Token;
  details: Token;
}

const ITEMS: Item[] = [
  {
    cost: {
      tokenType: TokenType.ERC1155,
      location: Location.Burn,
      _address: BUNDLES,
      id: 2, // Mysterious Relic
      quantity: 20
    },
    details: {
      tokenType: TokenType.ERC1155,
      location: Location.Mint,
      _address: BUNDLES,
      id: 3, // Contribution Token
      quantity: 1
    }
  },
  {
    cost: {
      tokenType: TokenType.ERC20,
      location: Location.Treasury,
      _address: MAGIC,
      id: 0,
      quantity: utils.parseEther("150.0"),
    },
    details: {
      tokenType: TokenType.ERC1155,
      location: Location.Mint,
      _address: POTIONS,
      id: 0, // Aptitude
      quantity: 1
    }
  },
  {
    cost: {
      tokenType: TokenType.ERC20,
      location: Location.Treasury,
      _address: MAGIC,
      id: 0,
      quantity: utils.parseEther("250.0"),
    },
    details: {
      tokenType: TokenType.ERC1155,
      location: Location.Mint,
      _address: POTIONS,
      id: 1, // Swiftness
      quantity: 1
    }
  },
  {
    cost: {
      tokenType: TokenType.ERC1155,
      location: Location.Burn,
      _address: BUNDLES,
      id: 3, // Contribution Token
      quantity: 1,
    },
    details: {
      tokenType: TokenType.ERC1155,
      location: Location.Mint,
      _address: POTIONS,
      id: 2, // Luck
      quantity: 6
    }
  },
  {
    cost: {
      tokenType: TokenType.ERC1155,
      location: Location.Burn,
      _address: BUNDLES,
      id: 3, // Contribution Token
      quantity: 1,
    },
    details: {
      tokenType: TokenType.ERC1155,
      location: Location.Mint,
      _address: POTIONS,
      id: 3, // Focus
      quantity: 4
    }
  }
]
const AddTraderItem = async () => {
  const accounts = await ethers.getSigners()
  if (hre.network.config.chainId !== 43288) {
    throw "Not using Boba network!";
  }
  const c = await getContract("DoCTrader", hre)
  const contract = await ethers.getContractAt("DoCTrader", c.address, accounts[0])

  for (let i = 0; i < ITEMS.length; i++) {
    console.log(i)
    const tx = await contract.addShopItem(ITEMS[i]);
    await tx.wait();
  }
}

const AddRoles = async () => {
  const accounts = await ethers.getSigners()
  if (hre.network.config.chainId !== 43288) {
    throw "Not using Boba network!";
  }
  const trader = await getContract("DoCTrader", hre)

  const contracts = ["CosmicBundles", "CosmicPotions", "CosmicRawResources", "CosmicRefinedResources", "CosmicTools"]
  for (let i = 0; i < contracts.length; i++) {
    const c = await getContract(contracts[i], hre);
    const hasRole = await c.hasRole(MINTER_ROLE, trader.address);
    if (hasRole) {
      console.log("DoC Trader already has the minter role for", contracts[i]);
    } else {
      const tx = await c.grantRole(MINTER_ROLE, trader.address);
      await tx.wait();
      console.log("Granted DoC Trader the minter role for", contracts[i]);
    }
  }

}
AddRoles()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })