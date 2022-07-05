const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat")
const fs = require('fs');
require("dotenv").config()

//const NewMetadata = (tokenId) => ({
//  "name": `Framed Wizard #${tokenId}`,
//  "description": "Framed picture of a 2D Cosmic Wizard",
//  "image": `https://images.cosmicuniverse.one/framed-wizards/${tokenId}`,
//  "attributes": []
//})

function getAllMetadata() {
  const allMetadata = {}
  for (let i = 1; i < 11523; i++) {
    try {
      console.log("Reading", i)
      let raw = fs.readFileSync(`./scripts/metadata/land/${i}.json`);
      let metadata = JSON.parse(raw);

      if ('Name' in metadata) {
        metadata.name = metadata.Name;
        delete metadata["Name"];
      }
      metadata.attributes.map(a => {
        if (a.trait_type === "COORDINATES") {
          const c = a.value.split(', ')
          metadata.latitude = c[0].substring(0, 1) === "-" ? Number(c[0].replace("-", '')) + 100 : Number(c[0])
          metadata.longitude = c[1].substring(0, 1) === "-" ? Number(c[1].replace("-", '')) + 100 : Number(c[1])
        } else if (a.trait_type === "REGION") {
          switch (a.value.toLowerCase()) {
            case 'road': {
              metadata.region = 0;
              break;
            }
            case 'water': {
              metadata.region = 1;
              break;
            }
            case 'elysian fields': {
              metadata.region = 2;
              break;
            }
            case 'enchanted forest': {
              metadata.region = 3;
              break;
            }
            case 'mystic alpines': {
              metadata.region = 4;
              break;
            }
            case 'forest of whimsy': {
              metadata.region = 5;
              break;
            }
            default: {
              metadata.region = 999;
            }
          }
        }
      })
      if (metadata.region < 2) {
        continue
      }
      allMetadata[Number(metadata.name.split('#')[1])] = metadata;
    } catch (e) {
      console.log("Error with", i)
    }
  }
  return allMetadata;
}

async function main2(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])
  const orig = Array.from(Array(871).fill(0)).map((n, i) => i+1)
  const discounts = ["5","5","5","5","10","5","10","5","5","5","5","5","10","5","10","5","5","5","5","10","5","5","5","5","5","10","5","5","10","10","5","10","5","5","5","5","5","5","5","10","5","5","5","10","5","5","10","5","15","5","15","5","10","5","5","5","10","5","10","5","5","5","5","10","5","5","5","10","5","5","10","10","5","5","5","5","5","5","5","5","5","5","5","10","5","5","10","10","5","5","5","5","10","5","5","10","5","5","5","10","5","5","5","10","10","5","10","5","5","10","10","5","10","5","10","5","10","5","5","5","10","10","5","10","5","10","5","5","10","5","5","5","5","5","5","10","5","5","5","5","5","5","5","5","10","5","5","10","5","5","5","5","10","5","10","10","5","5","5","5","5","5","5","10","5","15","5","5","5","10","5","5","5","5","5","5","5","5","5","5","5","5","10","15","5","5","5","10","5","5","5","5","10","5","5","5","5","5","5","5","5","5","5","5","5","5","5","10","5","5","5","10","5","5","5","5","5","5","5","10","5","10","5","5","10","5","10","5","5","5","5","10","5","5","5","10","5","5","5","5","5","10","5","5","5","5","5","5","10","10","5","5","10","5","5","10","5","10","5","5","5","10","10","5","10","5","5","5","5","5","5","10","5","5","5","5","5","5","5","5","5","15","5","5","5","5","5","5","5","15","5","5","5","5","5","10","5","10","5","10","5","10","5","10","5","5","5","10","5","5","5","5","5","10","5","5","10","5","5","5","5","5","5","5","5","10","15","5","10","5","5","5","5","5","10","10","5","5","10","10","5","5","5","5","5","5","10","5","10","15","5","10","5","5","10","15","5","5","10","5","5","5","5","5","5","10","15","5","5","10","10","5","5","5","5","5","10","10","10","5","5","5","5","10","5","10","5","10","5","5","5","10","5","5","5","15","10","10","5","5","5","5","5","5","10","10","5","10","10","5","5","5","5","5","5","10","5","5","5","10","5","5","5","10","5","5","5","5","5","5","10","10","5","5","10","5","10","5","5","5","5","5","5","5","5","5","10","5","5","5","5","10","5","5","5","5","5","5","5","5","5","5","5","10","5","10","5","10","5","10","5","10","5","5","5","5","10","5","5","5","10","5","5","10","5","10","10","5","10","5","10","10","5","10","5","5","5","5","10","5","5","10","5","5","5","5","5","5","5","5","5","5","5","5","5","5","10","5","5","5","5","10","5","10","5","5","5","5","5","10","5","5","5","5","5","5","5","5","5","10","5","15","5","5","5","5","5","10","5","10","5","5","5","5","5","5","5","5","5","5","5","5","5","10","5","5","10","5","5","5","5","5","5","10","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","10","5","5","10","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","10","5","5","5","5","10","5","10","5","5","5","5","5","5","5","5","5","10","5","5","5","10","5","10","5","10","5","5","10","10","10","5","10","5","10","15","5","5","5","5","5","5","5","5","5","5","10","5","10","5","10","5","5","5","5","5","5","5","5","5","5","5","10","5","5","5","5","10","5","5","5","5","5","10","5","5","5","5","5","5","10","5","5","5","5","5","5","5","15","5","5","5","5","5","5","5","5","5","5","10","10","10","5","5","15","5","5","10","5","5","10","10","10","5","5","15","10","5","5","10","5","5", "5","10","5","5","5","5","5","5","5","15","5","10","5","15","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","10","5","10","5","5","10","5","5","10","5","10","5","5","5","5","5","5","10","5","5","10","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","5","10","10","10","5","5","5","5","5","5","10","10","5","5","5","5","5","5","5","5","10","5","10","5","5","5","5","5","5","5","5","5","5","5","10","15","10","5","10","5","10","10","5","5","15","5","5","5","5","5","5","5","5","20","5","5","5"]
  const tx = await contract.setDiscountsOf(orig.slice(150, 300), discounts.slice(150, 300))
  await tx.wait(1)
  const tx1 = await contract.setDiscountsOf(orig.slice(300, 450), discounts.slice(300, 450))
  await tx1.wait(1)
  const tx2 = await contract.setDiscountsOf(orig.slice(450, 600), discounts.slice(450, 600))
  await tx2.wait(1)
  const tx3 = await contract.setDiscountsOf(orig.slice(600, 750), discounts.slice(600, 750))
  await tx3.wait(1)
  const tx4 = await contract.setDiscountsOf(orig.slice(750, 871), discounts.slice(750, 871))
  await tx4.wait(1)
}
async function main(name, address) {
  const accounts = await ethers.getSigners()
  const contract = await ethers.getContractAt(name, address, accounts[0])

  const allMetadata = getAllMetadata();
  const totalSize = allMetadata.length


  const tokenId = [];
  const tokenattr = [];
  const tokenvalue = [];
  for (const id of Object.keys(allMetadata)) {
    if (!('latitude' in allMetadata[id])) {
      console.log("Skipping", id);
      continue
    }
    tokenId.push(id)
    tokenattr.push(0)
    tokenvalue.push(allMetadata[id].latitude)
    tokenId.push(id)
    tokenattr.push(1)
    tokenvalue.push(allMetadata[id].longitude)
    tokenId.push(id)
    tokenattr.push(2)
    tokenvalue.push(allMetadata[id].region)
    //tokenattr.push(ethers.utils.hexlify(ethers.utils.toUtf8Bytes(JSON.stringify(allMetadata[i]))))
  }
  let batchSize = 200;
  let finished = 0;
  while (finished < tokenId.length) {
    console.log(`Updating ${finished} to ${finished+batchSize}`)
    console.log(tokenId.length, tokenattr.length, tokenvalue.length)
    const tx = await contract.setTokenURIs(tokenId.slice(finished, finished+batchSize), tokenattr.slice(finished, finished+batchSize), tokenvalue.slice(finished, finished+batchSize))
    await tx.wait(1)
    finished += batchSize
  }
}

main2("CosmicElvesTicketUpgradeable", "0x87D0F9ff4B51EEfe9f5f1578bc35e4ddA28bBd1e")
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })