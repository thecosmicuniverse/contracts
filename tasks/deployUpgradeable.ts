import "@nomiclabs/hardhat-ethers";
import '@openzeppelin/hardhat-upgrades';
import { task } from "hardhat/config";
import { setTimeout } from 'timers/promises';

task("deployUpgradeable", "Deploy an upgradeable contract with a transparent proxy")
  .addParam("name")
  .setAction(async ({ name }, hre) => {
    await hre.run('compile')
    const contractFactory = await hre.ethers.getContractFactory(name)
    console.log("Deploying", name)
    const contract = await hre.upgrades.deployProxy(contractFactory)
    console.log(name, "deployed!")
    const impl = await hre.upgrades.erc1967.getImplementationAddress(contract.address)
    const admin = await hre.upgrades.erc1967.getAdminAddress(contract.address)
    console.log("Proxy:", contract.address)
    console.log("Admin:", admin)
    console.log("Impl:", impl)
    console.log("Waiting 5s...")
    await setTimeout(5000);
    console.log("Verifying implementation contract...")
    await hre.run("verify:verify", { address: impl })
    console.log("Waiting 5s...")
    await setTimeout(5000);
    console.log("Verifying proxy contract...")
    await hre.run("verify:verify", {
      address: contract.address,
      constructorArgs: [admin, impl, '0x']
    })
  });