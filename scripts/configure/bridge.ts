import hre, { ethers } from "hardhat";
import "dotenv/config";
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { getContractAndData } from "@dirtycajunrice/hardhat-tasks"

enum NFTType {
  ERC1155,
  ERC721
}

const L1_NFT_BRIDGE_ABI = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"l1Token","type":"address"},{"indexed":true,"internalType":"address","name":"l2Token","type":"address"},{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"tokenId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"},{"indexed":false,"internalType":"bytes","name":"data","type":"bytes"}],"name":"BridgeFailed","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"l1Token","type":"address"},{"indexed":true,"internalType":"address","name":"l2Token","type":"address"},{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"tokenId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"},{"indexed":false,"internalType":"bytes","name":"data","type":"bytes"}],"name":"BridgeFinalized","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"l1Nft","type":"address"},{"indexed":true,"internalType":"address","name":"l2Nft","type":"address"},{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"tokenId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"},{"indexed":false,"internalType":"bytes","name":"data","type":"bytes"}],"name":"BridgeInitiated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint8","name":"version","type":"uint8"}],"name":"Initialized","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Paused","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"bytes32","name":"previousAdminRole","type":"bytes32"},{"indexed":true,"internalType":"bytes32","name":"newAdminRole","type":"bytes32"}],"name":"RoleAdminChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"address","name":"account","type":"address"},{"indexed":true,"internalType":"address","name":"sender","type":"address"}],"name":"RoleGranted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"address","name":"account","type":"address"},{"indexed":true,"internalType":"address","name":"sender","type":"address"}],"name":"RoleRevoked","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Unpaused","type":"event"},{"inputs":[],"name":"DEFAULT_ADMIN_ROLE","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"NFTBridge","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"nft","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"},{"internalType":"uint32","name":"gas","type":"uint32"}],"name":"bridge","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"exitGas","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"extraGasRelay","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"l1Nft","type":"address"},{"internalType":"address","name":"l2Nft","type":"address"},{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"},{"internalType":"bytes","name":"data","type":"bytes"}],"name":"finalize","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"}],"name":"getRoleAdmin","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"uint256","name":"index","type":"uint256"}],"name":"getRoleMember","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"}],"name":"getRoleMemberCount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"grantRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"hasRole","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"initialize","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"nft","type":"address"},{"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"}],"name":"isBridgeCompliant","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"messenger","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"pairNFTInfo","outputs":[{"internalType":"address","name":"l1Nft","type":"address"},{"internalType":"address","name":"l2Nft","type":"address"},{"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pause","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"paused","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"l1Nft","type":"address"},{"internalType":"address","name":"l2Nft","type":"address"},{"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"}],"name":"registerNFTPair","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"renounceRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"revokeRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"unpause","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint32","name":"_exitGas","type":"uint32"}],"name":"updateGas","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_nftBridge","type":"address"}],"name":"updateNFTBridge","outputs":[],"stateMutability":"nonpayable","type":"function"}]
const L2_NFT_BRIDGE_ABI = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"l1Token","type":"address"},{"indexed":true,"internalType":"address","name":"l2Token","type":"address"},{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"tokenId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"},{"indexed":false,"internalType":"bytes","name":"data","type":"bytes"}],"name":"BridgeFailed","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"l1Token","type":"address"},{"indexed":true,"internalType":"address","name":"l2Token","type":"address"},{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"tokenId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"},{"indexed":false,"internalType":"bytes","name":"data","type":"bytes"}],"name":"BridgeFinalized","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"l1Nft","type":"address"},{"indexed":true,"internalType":"address","name":"l2Nft","type":"address"},{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":false,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"tokenId","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"},{"indexed":false,"internalType":"bytes","name":"data","type":"bytes"}],"name":"BridgeInitiated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint8","name":"version","type":"uint8"}],"name":"Initialized","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Paused","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"bytes32","name":"previousAdminRole","type":"bytes32"},{"indexed":true,"internalType":"bytes32","name":"newAdminRole","type":"bytes32"}],"name":"RoleAdminChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"address","name":"account","type":"address"},{"indexed":true,"internalType":"address","name":"sender","type":"address"}],"name":"RoleGranted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"role","type":"bytes32"},{"indexed":true,"internalType":"address","name":"account","type":"address"},{"indexed":true,"internalType":"address","name":"sender","type":"address"}],"name":"RoleRevoked","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Unpaused","type":"event"},{"inputs":[],"name":"DEFAULT_ADMIN_ROLE","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"NFTBridge","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"billingContract","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"nft","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"},{"internalType":"uint32","name":"gas","type":"uint32"}],"name":"bridge","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"exitGas","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"extraGasRelay","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"l1Nft","type":"address"},{"internalType":"address","name":"l2Nft","type":"address"},{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"},{"internalType":"bytes","name":"data","type":"bytes"}],"name":"finalize","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"}],"name":"getRoleAdmin","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"uint256","name":"index","type":"uint256"}],"name":"getRoleMember","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"}],"name":"getRoleMemberCount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"grantRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"hasRole","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"initialize","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"nft","type":"address"},{"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"}],"name":"isBridgeCompliant","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"messenger","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"pairNFTInfo","outputs":[{"internalType":"address","name":"l1Nft","type":"address"},{"internalType":"address","name":"l2Nft","type":"address"},{"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"pause","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"paused","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"l1Nft","type":"address"},{"internalType":"address","name":"l2Nft","type":"address"},{"internalType":"enum INFTBridge.NFTType","name":"nftType","type":"uint8"}],"name":"registerNFTPair","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"renounceRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"role","type":"bytes32"},{"internalType":"address","name":"account","type":"address"}],"name":"revokeRole","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"unpause","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_billingContract","type":"address"}],"name":"updateBillingContract","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint32","name":"_exitGas","type":"uint32"}],"name":"updateGas","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_nftBridge","type":"address"}],"name":"updateNFTBridge","outputs":[],"stateMutability":"nonpayable","type":"function"}]

const MINTER_ROLE = "0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6";
const CONTRACT_ROLE = "0x364d3d7565c7a8300c96fd53e065d19b65848d7b23b3191adcd55621c744223c";

const PROXY_L1_NFT_BRIDGE = "0x18505CeC943EcB79999262c2dEb5127157c104CC";
const PROXY_L2_NFT_BRIDGE = "0x0e1455d86920b399369a7c871be8d26f585af440";

const NFT_NAME = "CosmicTools"
const NFT_L1 = "0x39Ad4AAfa177f59ed7356fFDBbF36A840075b7A6";
const NFT_L2 = "0x0458b679C30AA4B8622742eA9fb2A44660c4a2a1";
const NFT_TYPE = NFTType.ERC721;

const single = false;

const setBridgeReqs = async (hre: HardhatRuntimeEnvironment) => {
  const chainId = hre.network.config.chainId;
  if (chainId === 43114) {
    await setL1BridgeReqs(hre);
  } else if (chainId === 43288) {
    await setL2BridgeReqs(hre);
  } else {
    console.error("Wrong chain! use --network avalanche or boba")
    return;
  }
}

const setBridgePermissions = async (contractName: string) => {
  console.log("Setting Bridge permissions for", contractName)
  const { contract } = await getContractAndData(contractName, hre as any)
  const bridge = hre.network.config.chainId === 43288 ? PROXY_L2_NFT_BRIDGE : PROXY_L1_NFT_BRIDGE;
  const hasRole = await contract.hasRole(MINTER_ROLE, bridge);
  if (!hasRole) {
    console.log("Granting bridge the Minter role", MINTER_ROLE);
    const tx = await contract.grantRole(MINTER_ROLE, bridge);
    await tx.wait();
  } else {
    console.log("Bridge already has minter role")
  }

  if (NFT_TYPE === NFTType.ERC721) {
    const hasRole = await contract.hasRole(CONTRACT_ROLE, bridge);
    if (!hasRole) {
      console.log("Granting bridge the Contract role", CONTRACT_ROLE);
      const tx = await contract.grantRole(CONTRACT_ROLE, bridge);
      await tx.wait();
    } else {
      console.log("Bridge already has Contract role")
    }
  }
}

const setL1BridgeReqs = async (hre: HardhatRuntimeEnvironment) => {
  const accounts = await ethers.getSigners();
  const wallet = accounts[0];
  if (hre.network.config.chainId !== 43114) {
    console.error("Wrong chain! use --network avalanche")
    return;
  }
  const { contract: nft } = await getContractAndData(NFT_NAME, hre as any)
  const bridge = await ethers.getContractAt(L1_NFT_BRIDGE_ABI, PROXY_L1_NFT_BRIDGE, wallet);

  const bridgeContract = await nft.bridgeContract();
  if (bridgeContract !== NFT_L2) {
    console.log("Setting L2 address to", NFT_L2);
    const tx = await nft.setBridgeContract(NFT_L2);
    await tx.wait();
  } else {
    console.log("L2 address already configured");
  }
  await setBridgePermissions(NFT_NAME)
  const pairNFTInfo = await bridge.pairNFTInfo(NFT_L1);
  if (pairNFTInfo.l1Nft === ethers.constants.AddressZero) {
    console.log("Configuring Bridge L1 NFT pair", NFT_L1, "=>", NFT_L2);
    const tx = await bridge.registerNFTPair(NFT_L1, NFT_L2, NFT_TYPE);
    await tx.wait();
  } else {
    console.log("L1 Bridge pair already configured")
  }
}

const setL2BridgeReqs = async (hre: HardhatRuntimeEnvironment) => {
  const accounts = await ethers.getSigners();
  const wallet = accounts[0];
  if (hre.network.config.chainId !== 43288) {
    console.error("Wrong chain! use --network boba")
    return;
  }
  const nft = await ethers.getContractAt(NFT_NAME, NFT_L2, wallet)
  const bridge = await ethers.getContractAt(L2_NFT_BRIDGE_ABI, PROXY_L2_NFT_BRIDGE, wallet);

  const bridgeContract = await nft.bridgeContract();
  if (bridgeContract !== NFT_L1) {
    console.log("Setting L1 address to", NFT_L1);
    const tx = await nft.setBridgeContract(NFT_L1);
    await tx.wait();
  } else {
    console.log("L1 address already configured");
  }

  await setBridgePermissions(NFT_NAME)

  const pairNFTInfo = await bridge.pairNFTInfo(NFT_L2);
  if (pairNFTInfo.l1Nft === ethers.constants.AddressZero) {
    console.log("Configuring Bridge L2 NFT pair", NFT_L1, "=>", NFT_L2);
    const tx = await bridge.registerNFTPair(NFT_L1, NFT_L2, NFT_TYPE);
    await tx.wait();
  } else {
    console.log("L2 Bridge pair already configured")
  }
}

const bridgeFromAvalancheToBoba1155 = async (hre: HardhatRuntimeEnvironment) => {
  const accounts = await ethers.getSigners();
  const wallet = accounts[0];
  const { contract: nft } = await getContractAndData("CosmicBundles", hre as any);
  const bridge = await ethers.getContractAt(L1_NFT_BRIDGE_ABI, PROXY_L1_NFT_BRIDGE, wallet);

  console.log("Checking for NFT approval for bridge")
  const approvedForAll = await nft.isApprovedForAll(wallet.address, bridge.address);
  if (!approvedForAll) {
    console.log("Giving bridge approval");
    const approvalTx = await nft.setApprovalForAll(bridge.address, true);
    await approvalTx.wait();
  } else {
    console.log("Bridge has approval")
  }
  const balances = await nft.balanceOfAll();
  const gasCost = await bridge.exitGas();
  console.log("Exit gas cost:", gasCost.toString());

  //await tx.wait();
  for (let i = 0; i < balances.tokenIds[0].length; i++) {
    const nftId = balances.tokenIds[0][i].toNumber();
    const quantity = balances.balances[0][i].toNumber();
    console.log(`Bridging TokenID #${nftId} Quantity ${quantity} using ${gasCost.toString()} gas`);
    const tx = await bridge.bridge(nft.address, wallet.address, nftId, quantity, NFTType.ERC1155, gasCost);
    await tx.wait();
  }
}

const bridgeFromAvalancheToBoba721 = async (hre: HardhatRuntimeEnvironment) => {
  const accounts = await ethers.getSigners();
  const wallet = accounts[0];
  const { contract: nft } = await getContractAndData("CosmicElves", hre as any)
  const bridge = await ethers.getContractAt(L1_NFT_BRIDGE_ABI, PROXY_L1_NFT_BRIDGE, wallet);

  console.log("Checking for NFT approval for bridge")
  const approvedForAll = await nft.isApprovedForAll(wallet.address, PROXY_L1_NFT_BRIDGE);
  if (!approvedForAll) {
    console.log("Giving bridge approval");
    const approvalTx = await nft.setApprovalForAll(PROXY_L1_NFT_BRIDGE, true);
    await approvalTx.wait();
  } else {
    console.log("Bridge has approval")
  }
  const tokens = await nft.tokensOfOwner(wallet.address);
  const gasCost = await bridge.exitGas();
  console.log("Exit gas cost:", gasCost.toString());

  for (let i = 0; i < tokens.length; i++) {
    const nftId = tokens[i].toNumber();
    console.log(`Bridging TokenID #${nftId} using ${gasCost.toString()} gas`);
    const tx = await bridge.bridge(nft.address, wallet.address, nftId, 1, NFTType.ERC721, gasCost);
    await tx.wait();
    if (single) {
      break;
    }
  }
}


const testMint = async (hre: HardhatRuntimeEnvironment) => {
  const accounts = await ethers.getSigners();
  const wallet = accounts[0];
  const tokenId = 35
  const nft = await ethers.getContractAt("CosmicElves", NFT_L1, wallet)
  const bridge = await ethers.getContractAt(L2_NFT_BRIDGE_ABI, PROXY_L2_NFT_BRIDGE, wallet);
  const baseValues = (await nft.getSkillsByTree(tokenId, 0, Array.from(Array(11).fill(0)).map((v, i) => v + i))).map(v => v.toString())
  const adventuresValues = (await nft.getSkillsByTree(tokenId, 3, Array.from(Array(3).fill(0)).map((v, i) => v + i))).map(v => v.toString())
  const professionsValues = (await nft.getSkillsByTree(tokenId, 1, Array.from(Array(12).fill(0)).map((v, i) => v + i))).map(v => v.toString())
  console.log(baseValues, adventuresValues, professionsValues)
  const data = ethers.utils.defaultAbiCoder.encode(["tuple(uint256[], uint256[], uint256[])"], [[baseValues, adventuresValues, professionsValues]]);
  console.log(data);
  const tx = await nft['mint(address,uint256,bytes)'](wallet.address, tokenId, data);
  await tx.wait()
}

const massSend = async (hre: HardhatRuntimeEnvironment) => {
  const sendTo = "0x64DEBa23F3ec31c8e8dc88489589Bb9b26538DC6";
  const accounts = await ethers.getSigners();
  const wallet = accounts[0];

  const { contract: nft } = await getContractAndData("CosmicRefinedResources", hre as any)

  const balances = await nft.balanceOfAll();
  console.log(balances);
  const tokenIds = balances.tokenIds[0];
  const amounts = Array.from(Array(tokenIds.length)).fill(1)
  const quantity = 1;
  console.log(`Sending TokenIDs #${tokenIds.join(',')} Quantity ${quantity}`);
  const tx = await nft.safeBatchTransferFrom(wallet.address, sendTo, tokenIds, amounts, []);
  await tx.wait();
}

const setAllContractPerms = async () => {
  const contractNames = ['CosmicTools', 'CosmicElves', 'CosmicBundles']
  for (const name of contractNames) {
    await setBridgePermissions(name)
  }
}

setAllContractPerms()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })