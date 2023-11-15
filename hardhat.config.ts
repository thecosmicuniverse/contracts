import * as tdly from "@tenderly/hardhat-tenderly";
import { NetworksUserConfig } from "hardhat/types";
import "@dirtycajunrice/hardhat-tasks/internal/type-extensions"
import "@dirtycajunrice/hardhat-tasks";
import '@openzeppelin/hardhat-upgrades';
import "@nomicfoundation/hardhat-ethers";
import "@nomicfoundation/hardhat-verify";
import './tasks';
import "dotenv/config";

tdly.setup();

const networkData = [
  {
    name: "avalanche",
    chainId: 43_114,
    urls: {
      rpc: `https://api.avax.network/ext/bc/C/rpc`,
      api: "https://api.snowtrace.io/api",
      browser: "https://snowtrace.io",
    },
  },
  {
    name: "boba",
    chainId: 43_288,
    urls: {
      rpc: `https://avax.boba.network`,
      api: "https://blockexplorer.avax.boba.network/api",
      browser: "https://blockexplorer.avax.boba.network/",
    },
  }
];

const config = {
  defaultNetwork: "avalanche",
  solidity: {
    compilers: [ "8.20", "8.19", "8.18", "8.17", "8.16", "8.9", "8.2", "6.0" ].map(v => (
      {
        version: `0.${ v }`,
        settings: {
          ...(
            v === "8.20" ? { evmVersion: "london" } : {}
          ), optimizer: { enabled: true, runs: 200 }
        },
      }
    )),
  },
  networks: networkData.reduce((o, network) => {
    o[network.name] = {
      url: network.urls.rpc,
      chainId: network.chainId,
      accounts: [ process.env.PRIVATE_KEY! ]
    }
    return o;
  }, {} as NetworksUserConfig),
  etherscan: {
    apiKey: {
      avalanche: process.env.SNOWTRACE_API_KEY,
    },
    customChains: networkData.map(network => (
      {
        network: network.name,
        chainId: network.chainId,
        urls: { apiURL: network.urls.api, browserURL: network.urls.browser },
      }
    ))
  },
  docgen: {
    pages: 'files'
  },
  tenderly: {
    project: "cosmic-universe",
    username: "DirtyCajunRIce",
    privateVerification: false
  }
}

export default config;
