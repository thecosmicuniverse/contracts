import { task } from 'hardhat/config';
import { getContractAndData } from './helpers';

task("verify", "Verify a contract's source code")
  .addOptionalParam("name", "Contract name")
  .setAction(async ({ name, address }, hre) => {
    let resolvedAddress = address;
    if (!address) {
      const { contract } = await getContractAndData(name, hre);
      resolvedAddress = contract.address;
    }
    console.log("Verifying contract...")
    await hre.run("verify:verify", { address: resolvedAddress })
  });

