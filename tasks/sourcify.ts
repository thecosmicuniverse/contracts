import { getContractAndData } from "@dirtycajunrice/hardhat-tasks";
import axios from "axios";
//@ts-ignore
import FormData from "form-data";
import { task, types } from "hardhat/config";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { getFullyQualifiedName } from "hardhat/utils/contract-names";
import { Readable } from "stream";

function log(...args: any[]) {
  console.log(...args);
}

function logError(...args: any[]) {
  console.log(...args);
}

function logInfo(...args: any[]) {
  console.log(...args);
}

function logSuccess(...args: any[]) {
  console.log(...args);
}

function ensureTrailingSlash(s: string): string {
  const lastChar = s.substr(-1);
  if (lastChar !== "/") {
    s = s + "/";
  }
  return s;
}

const defaultEndpoint = "https://sourcify.dev/server/";

export async function submitSourcesToSourcify(
  hre: HardhatRuntimeEnvironment,
  config: {
    endpoint?: string;
    sourceName: string; // path ./contracts/Greeter.sol
    contractName: string; // name Greeter
    address: string;
    chainId: number;

    // address
    // writeFailingMetadata?: boolean;
  }
): Promise<void> {
  config = config || {} as any;
  //   get chainId
  const chainId = config.chainId;

  //   const chainId = await hre.getChainId();
  //   const all = await hre.deployments.all();
  const url = config.endpoint
    ? ensureTrailingSlash(config.endpoint)
    : defaultEndpoint;

  async function submit(name: string) {
    // get chosenContract index
    /// get chosenContract (contract index in hardhat metadata file)
    const fullyQualifiedName = getFullyQualifiedName(
      config.sourceName,
      config.contractName
    );
    const buildinfo = await hre.artifacts.getBuildInfo(fullyQualifiedName);
    /// get contract index from output of buildinfo
    let index;
    if (buildinfo) {
      // index = getObjectKeyIndex(buildinfo.output.contracts, config.sourceName)
      index = Object.keys(buildinfo.output.contracts).indexOf(
        config.sourceName
      );
      console.log("chosen contract", index);
    } else {
      // throw error
    }
    const address = config.address;
    const metadataString = JSON.stringify(buildinfo);

    try {
      const checkResponse = await axios.get(
        `${url}checkByAddresses?addresses=${address.toLowerCase()}&chainIds=${chainId}`
      );
      const { data: checkData } = checkResponse;
      console.log(checkData[0].status);
      if (checkData[0].status === "perfect") {
        log(`already verified: ${name} (${address}), skipping.`);
        return;
      }
    } catch (e) {
      logError(
        ((e as any).response && JSON.stringify((e as any).response.data)) || e
      );
    }

    if (!metadataString) {
      logError(
        `Contract ${name} was deployed without saving metadata. Cannot submit to sourcify, skipping.`
      );
      return;
    }

    logInfo(`verifying ${name} (${address} on chain ${chainId}) ...`);

    const formData = new FormData();
    formData.append("address", address);
    formData.append("chain", chainId);
    formData.append("chosenContract", index);

    const fileStream = new Readable();
    fileStream.push(metadataString);
    fileStream.push(null);
    formData.append("files", fileStream, "metadata.json");

    try {
      const submissionResponse = await axios.post(url, formData, {
        headers: formData.getHeaders(),
      });
      if (submissionResponse.data.result[0].status === "perfect") {
        logSuccess(` => contract ${name} is now verified`);
      } else {
        logError(` => contract ${name} is not verified`);
      }
    } catch (e) {
      //   if (config && config.writeFailingMetadata) {
      //     const failingMetadataFolder = path.join('failing_metadata', "3");
      //     fs.ensureDirSync(failingMetadataFolder);
      //     fs.writeFileSync(
      //       path.join(failingMetadataFolder, `${name}_at_${address}.json`),
      //       metadataString
      //     );
      //   }
      logError(
        ((e as any).response && JSON.stringify((e as any).response.data)) || e
      );
    }
  }

  if (config.contractName) {
    await submit(config.contractName);
  } else {
    // todo:
  }
}
// submitSourcesToSourcify(hre, {

//     sourceName: "contracts/Greeter.sol", //path ./contracts/Greeter.sol
//     address: "0x122345454646456546654",
//     contractName: "Greeter",
//     chainId: 3
// }).catch((error) => {
//     console.error(error);
//     process.exitCode = 1;
// });

task("sourcify", "verify contract using sourcify")
  .addParam("name", "Name of the contract you want to verify", undefined, types.string)
  .setAction(async ({ name }, hre) => {
    // compile contract first
    const { contract, factory, data } = await getContractAndData(name, hre)
    await submitSourcesToSourcify(hre, {
      sourceName: name,
      contractName: name,
      address: contract.address,
      chainId: hre.network.config.chainId || 0,
    }).catch((error) => {
      console.error(error);
      process.exitCode = 1;
    });
  });