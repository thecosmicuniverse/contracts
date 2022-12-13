import "@nomicfoundation/hardhat-toolbox";
import { Manifest } from '@openzeppelin/upgrades-core';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import fs from 'fs';
import { setTimeout } from 'timers/promises';

export type ContractType = 'static' | 'transparent' | 'uups' | 'beacon'

export const isTypeOfContractType = (key: string): key is ContractType => {
  return ['static', 'transparent', 'uups'].includes(key)
}

export const validateContractType = (key: string) => {
  if (!isTypeOfContractType(key)) {
    throw Error(`"${key}" is not a valid contract type. Valid options are static, transparent, and uups`)
  }
}

type ContractData = {
  name: string,
  type: ContractType,
  impl?: string,
  admin?: string
}

type ContractsData = {
  [chainId: string]: {
    [address: string]: ContractData
  }
}

export const loadContractData = (): ContractsData => {
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

export const getContractData = (name: string, hre: HardhatRuntimeEnvironment): { address: string, data: ContractData } => {
  const chainId = hre.network.config.chainId;
  if (!chainId) {
    throw "No chain ID found!";
  }
  const contractData = loadContractData();
  if (!(chainId.toString() in contractData)) {
    throw `No contracts found for chainId ${chainId}`;
  }
  const data = Object.entries(contractData[chainId.toString()]).find(([address, data]) => data.name === name)
  if (!data) {
    throw `No contract address found for ${name}`;
  }
  return { address: data[0], data: data[1] }
}

export const getContract = async (name: string, hre: HardhatRuntimeEnvironment) => {
  const { address } = getContractData(name, hre);
  const accounts = await hre.ethers.getSigners();
  return await hre.ethers.getContractAt(name, address, accounts[0]);
}

export const getContractAndData = async (name: string, hre: HardhatRuntimeEnvironment) => {
  const { address, data } = getContractData(name, hre);
  const accounts = await hre.ethers.getSigners();
  const contract = await hre.ethers.getContractAt(name, address, accounts[0]);
  const factory = await hre.ethers.getContractFactory(name);
  return { contract, factory, data }
}
// getProxyData Gets the implementation/admin addresses for a proxy contract based on kind
export const getProxyData = async (address: string, hre: HardhatRuntimeEnvironment) => {
  const manifest = await Manifest.forNetwork(hre.network.provider);
  const data: { type: ContractType, impl?: string, admin?: string } = {
    type: 'static',
    impl: undefined,
    admin: undefined
  }
  try {
    const proxy = await manifest.getProxyFromAddress(address);
    data.type = proxy.kind;
    data.impl = await hre.upgrades.erc1967.getImplementationAddress(address)
    if (proxy.kind === 'transparent') {
      data.admin = await hre.upgrades.erc1967.getAdminAddress(address)
    }
  } catch (e) {
    console.error(e)
  }
  return data
}

export const waitSeconds = async (seconds: number) => {
  console.log("Waiting 5s...")
  await setTimeout(seconds * 1000);
}