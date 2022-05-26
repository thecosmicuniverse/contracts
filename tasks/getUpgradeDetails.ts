import "@nomiclabs/hardhat-ethers";
import '@openzeppelin/hardhat-upgrades';
import { task } from 'hardhat/config';
import { setTimeout } from "timers/promises";

task("getUpgradeDetails", "Get the admin and implementation address of a deployed proxy")
  .addParam("address")
  .setAction(async ({ address }, hre) => {
    const impl = await hre.upgrades.erc1967.getImplementationAddress(address)
    const admin = await hre.upgrades.erc1967.getAdminAddress(address)
    console.log("Proxy:", address)
    console.log("Admin:", admin)
    console.log("Impl:", impl)
  });