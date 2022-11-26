import "@nomiclabs/hardhat-ethers";
import '@openzeppelin/hardhat-upgrades';
import { task } from 'hardhat/config';
import { getContractAndData, waitSeconds } from './helpers';

task("upgrade", "Upgrade a proxy contract")
  .addParam("name")
  .setAction(async ({ name }, hre) => {
    await hre.run('compile')
    const { contract, factory, data } = await getContractAndData(name, hre)
    console.log("Upgrading", name)

    const upgrade = await hre.upgrades.upgradeProxy(contract.address, factory)
    await upgrade.deployed()
    console.log(name, "upgraded!")
    await hre.run( 'saveContractDetails', {
      name,
      address: contract.address,
      chainId: hre.network.config.chainId,
      type: data.type
    })
    await waitSeconds(5);
    console.log("Verifying implementation contract...")
    await hre.run("verify", { name })
  });