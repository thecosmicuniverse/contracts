import "@nomiclabs/hardhat-ethers";
import '@openzeppelin/hardhat-upgrades';
import { ContractFactory } from 'ethers';
import { subtask, task, types } from 'hardhat/config';
import { Manifest } from '@openzeppelin/upgrades-core';
import { ContractType, validateContractType, waitSeconds } from './helpers';

task("deploy", "Deploy a contract")
  .addParam("name")
  .addOptionalParam("type", "Contract deployment type - static | transparent | uups", "transparent", types.string)
  .setAction(async ({ name, type }, hre) => {
    validateContractType(type);
    await hre.run('compile')
    if ((type as ContractType) === 'static') {
      await hre.run(`deploy:static`, { name });
    } else {
      await hre.run(`deploy:upgradeable`, { name });
    }
  });

subtask("deploy:static", "Deploy a static contract")
  .addParam("name")
  .setAction(async ({ name }, hre) => {
    await hre.run('compile')
    // @ts-ignore
    const contractFactory: ContractFactory = await hre.ethers.getContractFactory(name)
    console.log("Deploying", name, "as a static contract")
    const contract = await contractFactory.deploy()
    await contract.deployed()
    console.log(name, "deployed!")
    await hre.run('saveContractDetails:subtask', {
      name,
      address: contract.address,
      chainId: hre.network.config.chainId,
      type: 'static'
    })
    await waitSeconds(5);
    console.log("Verifying contract...")
    await hre.run("verify", { address: contract.address })
  });

subtask("deploy:upgradeable", "Deploy a transparent proxy contract")
  .addParam("name")
  .setAction(async ({ name, type }, hre) => {


    const contractFactory = await hre.ethers.getContractFactory(name) as ContractFactory
    console.log("Deploying", name, "as a transparent upgradeable contract")
    const contract = await hre.upgrades.deployProxy(contractFactory as any, { kind: type })
    const manifest = await Manifest.forNetwork(hre.network.provider);
    const proxy = await manifest.getProxyFromAddress(contract.address);

    await contract.deployed();
    console.log(name, "deployed!")
    await hre.run('saveContractDetails:subtask', {
      name,
      address: contract.address,
      chainId: hre.network.config.chainId,
      type: proxy.kind
    })
    await waitSeconds(5);
    await hre.run('verify', { name })
  });
