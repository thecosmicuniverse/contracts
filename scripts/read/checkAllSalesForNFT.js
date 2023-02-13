const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")

require("dotenv").config()
const saleIds = [112,  163,  170,  241,  396,  445,  491,  494,  528,  530, 531,  549,  553,  556,  783,  784,  870,  905, 1070, 1307, 1397, 1398, 1564, 1705, 1980, 2179, 2360, 2424, 2425, 2985, 2986, 2987, 2989, 3053, 3059, 3147, 3148, 3407, 3428, 3553, 3554, 3619, 3687, 3688, 3689, 3744, 3786, 3787, 3853, 3920, 4023, 4140, 4141, 4142, 4391, 4458, 4694, 4695, 4696, 4698, 4731, 4821, 5009, 5025, 5038, 5042, 5043, 5044, 5045, 5047, 5048, 5049, 5051, 5064, 5089, 5090, 5091, 5092, 5213, 5215, 5257, 5284, 5292, 5306, 5309, 5315, 5340, 5395, 5408, 5460, 5461, 5462, 5463, 5464, 5465, 5466, 5510, 5539, 5600, 5636, 5656, 5673, 5691, 5692, 5693, 5694, 5696, 5731, 5782, 5783, 5813, 5814, 5815, 5826, 5827, 5828, 5875, 5914, 5981, 5984, 5986, 5988, 5989, 5990, 5991, 5992, 5993, 5994, 5995, 5996, 6012, 6013, 6085, 6086, 6087, 6093, 6123, 6179, 6193, 6215, 6274, 6275, 6343, 6347, 6372, 6373, 6374, 6405, 6424, 6425, 6426, 6427, 6434, 6441, 6443, 6452, 6454, 6460, 6461, 6467, 6472, 6477, 6486, 6487, 6492, 6493, 6497, 6499, 6500, 6503, 6506, 6510, 6511, 6512, 6513, 6514, 6515, 6516, 6517, 6518, 6519, 6520]
async function main(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])
  const lastSaleId = 5192;
  const blockNumber = 26865426;
  const sales = []
  for (let i = 100; i < saleIds.length; i++) {
    console.log(i+1, "out of", saleIds.length)
    const sale = await contract.saleIdToSale(saleIds[i]);
    sales.push({
      saleId: saleIds[i],
      saleType: sale.saleType,
      seller: sale.seller,
      contractAddress: sale.contractAddress,
      tokenType: sale.tokenType,
      bidToken: sale.bidToken,
      startTime: sale.startTime.toNumber(),
      duration: sale.duration.toNumber(),
      extensionDuration: sale.extensionDuration.toNumber(),
      endTime: sale.endTime.toNumber(),
      bidder: sale.bidder,
      bidAmount: sale.bidAmount.toString()
    })
  }
  console.log(sales)
}

main("MarketUpgradeable", "0xC8cEdDf1b1592B3ef5646aF733F14d8fF51a2656")
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })