import "@nomiclabs/hardhat-ethers";
import '@openzeppelin/hardhat-upgrades';
import { task, types } from 'hardhat/config';
import { getContractAndData, waitSeconds } from './helpers';

task("upgrade", "Upgrade a proxy contract")
  .addParam("name")
  .addOptionalParam("address", "Address of proxy (Deprecated)", '', types.string)
  .setAction(async ({ name, address }, hre) => {
    await hre.run('compile')
    try {
      const { contract, factory, data } = await getContractAndData(name, hre)
      console.log(contract, factory, data);

      if (address) {
        console.error("ERROR: Address still set in package.json. Remove first")
        return;
      }
      console.log("Upgrading", name, data.type, "proxy", contract.address)
      console.log("Current impl address:", data.impl)

      const upgrade = await hre.upgrades.upgradeProxy(contract.address, factory)
      await upgrade.deployed()
      console.log(name, "upgraded!")
      await hre.run( 'saveContractDetails', {
        name,
        address: contract.address,
        chainId: hre.network.config.chainId,
        type: data.type
      })
    } catch (e) {
      console.log(e)
      console.log("Address not stored in contracts.json. Importing...")
      await hre.run("saveContractDetails", { name, address })
      console.log("Success. Please remove address from package.json before running again")
      return;
    }
    await waitSeconds(5);
    console.log("Verifying implementation contract...")
    await hre.run("verify", { name })
  });