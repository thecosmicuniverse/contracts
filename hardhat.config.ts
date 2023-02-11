import "@nomicfoundation/hardhat-toolbox";
import '@openzeppelin/hardhat-upgrades';
import {
  GetEtherscanCustomChains,
  GetNetworks,
  GetSolidityCompilers
} from "@dirtycajunrice/hardhat-tasks";
import "@dirtycajunrice/hardhat-tasks/tasks";
import 'solidity-docgen';
import "dotenv/config";
import "./tasks/sourcify";
const config = {
  solidity: {
    compilers: GetSolidityCompilers(["0.8.17", "0.8.16", "0.8.9", "0.8.2", "0.6.0"]),
  },
  networks: {
    ...GetNetworks([process.env.PRIVATE_KEY || '']),
    dfk: {
      url: "https://avax-dfk.gateway.pokt.network/v1/lb/6244818c00b9f0003ad1b619//ext/bc/q2aTwKuyzgs8pynF7UXBZCU7DejbZbZ6EUyHr3JQzYgwNPUPi/rpc",
      chainId: 53935,
      accounts: [process.env.PRIVATE_KEY, process.env.PRIVATE_KEY_3],
    }
  },
  etherscan: {
    apiKey: {
      avalanche: process.env.SNOWTRACE_API_KEY,
      bobaAvax: 'not needed'
    },
    customChains: GetEtherscanCustomChains(),
  },
  docgen: {
    pages: 'files'
  }
}

export default config;
