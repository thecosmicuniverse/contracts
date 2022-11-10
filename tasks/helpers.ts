import "@nomicfoundation/hardhat-toolbox";
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import fs from 'fs';

type ContractData = {
  [chainId: string]: {
    [address: string]: {
      name: string,
      impl?: string,
      admin?: string
    }
  }
}

export const loadContractData = (): ContractData => {
  try {
    const data = fs.readFileSync('contracts.json', 'utf-8');
    return JSON.parse(data);
  } catch (e) {
    console.log(e);
    console.log("Creating file");
    fs.writeFileSync('contracts.json', JSON.stringify({}), 'utf-8')
    return {};
  }
}

export const saveContract = (name: string, address: string, chainId: number, upgradeable?: boolean, impl?: string, admin?: string) => {
  const contracts = loadContractData();
  if (!(chainId in contracts)) {
    contracts[chainId] = {};
  }
  contracts[chainId][address] = { name };
  if (upgradeable) {
    contracts[chainId][address].impl = impl;
    contracts[chainId][address].admin = admin;
  }
  const data = JSON.stringify(contracts, null, 2);
  fs.writeFileSync('contracts.json', data, 'utf-8')
}


export const getContract = async (name: string, hre: HardhatRuntimeEnvironment) => {
  const accounts = await hre.ethers.getSigners();
  const chainId = hre.network.config.chainId;
  if (!chainId) {
    throw "No chain ID found!";
  }
  const contractData = loadContractData();
  console.log(chainId, contractData)
  const address = Object.entries(contractData[chainId.toString()]).find(([address, data]) => data.name === name)?.[0]
  if (!address) {
    throw `No contract address found for ${name}`;
  }
  return await hre.ethers.getContractAt(name, address, accounts[0]);
}