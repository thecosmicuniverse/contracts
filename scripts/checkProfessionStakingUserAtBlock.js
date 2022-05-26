const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")

require("dotenv").config()

async function main(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])
  const wallet = '0x91ea3D97076c2e231A518Aa4ff8161b0d567559E';
  const block = 26750917
  const nftAddress = '0xdC59f32a58Ba536f639ba39C47cE9a12106b232B'
  const sales = []
  for (let i = lastSaleId; i > 0; i--) {
    console.log(`Checking sale #${i}`)
    const sale = await contract.saleIdToSale(i);
    if (sale.contractAddress === nftAddress && sale.seller === owner) {
      sales.push(sale)
      console.log(`Potentially matching sale #${i}:`, sale)
    }
  }
  console.log("All Potentials:", sales)
}

async function getAllPD(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])
  const [addresses, nfts, rewards] = await contract.getAllParticipantData();

  const data = addresses.map((address, i) => ({
    address,
    nfts: nfts[i],
    rewards: rewards[i]
  })).filter(d => d.rewards.gt(0)).sort((p, c) => p.rewards.sub(c.rewards).gt(0) ? -1 : 1)
  console.log('------------------------------------------------------------------')
  data.map(d => {
    console.log(`| ${d.address} | ${d.nfts.length.toString().padStart(3, " ")} | ${ethers.utils.formatEther(d.rewards).split('.')[0]}`)
  })
  console.log('------------------------------------------------------------------')
}

async function getAll(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])
  const [allAddresses, allNfts] = await contract.getParticipatingNftsGroupedByAddress();

  console.log("Total Participating Wallets:", allAddresses.length)
  console.log("Total Participating NFTs:", allNfts.flat().length)
  const affectedAddresses = []
  const affectedNfts = []
  const affectedTotals = []
  const allMap = {}

  allAddresses.map((a, i) => {
    const nfts = allNfts[i].map((n, j) => ({
      address: n._address,
      tokenId: n.tokenId.toNumber(),
      rewardFrom: n.rewardFrom.toNumber(),
      index: j,
    }))
    const badNfts = nfts.filter(n => n.tokenId === 0)
    if (badNfts.length > 0) {
      affectedAddresses.push(a)
      affectedNfts.push(badNfts)
      affectedTotals.push(nfts)
    }
    allMap[a] = { nfts, badNfts }
  })
  console.log("Affected wallets:", affectedAddresses.length)
  console.log("Affected NFTs", affectedNfts.flat().length)
  affectedAddresses.map((a, i) => {
    console.log("Wallet:", a, "| Affected:", affectedNfts[i].length, "| Total:", affectedTotals[i].length)
  })
  return
  const wallet = ""
  const nftIdList = []
  console.log("Addressing:", wallet)
  console.log("Total NFTs:", allMap[wallet].nfts.length)
  console.log("Affected NFTs:", allMap[wallet].badNfts.length)
  if (nftIdList.length !== allMap[wallet].nfts.length) {
    console.error("INCORRECT ID LIST")
    return
  }
  if (allMap[wallet].badNfts.length === 0) {
    console.log("None affected")
    return
  }
  const correctIds =  allMap[wallet].nfts.map(n => n.tokenId).filter(t => t !== 0)
  const toFix = nftIdList.filter(t => !correctIds.includes(Number(t)))
  const addresses = Array(toFix.length).fill(wallet)
  const indexes = allMap[wallet].badNfts.map(n => n.index)
  const nftAddresses = Array(toFix.length).fill("0xdC59f32a58Ba536f639ba39C47cE9a12106b232B")
  const tokenIds = toFix
  const rewardFrom = allMap[wallet].badNfts.map(n => n.rewardFrom === 0 ? Number((Date.now() / 1000).toFixed(0)) : 0)
  await contract.adminBatchUpdateNftData(addresses, indexes, nftAddresses, tokenIds, rewardFrom);
}


getAllPD("ProfessionStakingUpgradeable", "0x8Dfc57c1c1032e08f3DF6C71A6d8b8EF88a7aC21")
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })