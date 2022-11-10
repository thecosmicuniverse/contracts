import "@nomiclabs/hardhat-ethers";
import '@openzeppelin/hardhat-upgrades';
import { task } from 'hardhat/config';
import { getContract } from './helpers';


task("token-uri", "Fetches the token metadata for the given token ID")
  .addParam("name", "The contract name to fetch metadata from")
  .addParam("tokenId", "The tokenID to fetch metadata for")
  .setAction(async ({ name, tokenId }, hre) => {
    const contract = await getContract(name, hre);
    const metadata = await contract.tokenURI(tokenId, {
      gasLimit: 500_000,
    });
    console.log(JSON.stringify(metadata, null, 2))
  });