import "@nomicfoundation/hardhat-toolbox";
import '@openzeppelin/hardhat-upgrades';
import "@dirtycajunrice/hardhat-tasks/tasks";

import "dotenv/config";


module.exports = {
  solidity: {
    compilers: ["0.8.16", "0.8.9", "0.8.2", "0.6.0"].map(version => ({
      version,
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    })),
  },
  networks: {
    harmony: {
      url: 'https://api.harmony.one',
      chainId: 1666600000,
      accounts: [process.env.PRIVATE_KEY]
    },
    avalanche: {
      url: process.env.AVALANCHE_RPC || 'https://ava-mainnet.public.blastapi.io/ext/bc/C/rpc',
      chainId: 43114,
      accounts: [process.env.PRIVATE_KEY]
    },

    boba: {
      url: 'https://avax.boba.network',
      chainId: 43288,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: {
      harmony: 'not needed',
      avalanche: process.env.SNOWTRACE_API_KEY,
      boba: 'not needed'
    },
    customChains: [
      {
        network: "boba",
        chainId: 43288,
        urls: {
          apiURL: "https://blockexplorer.avax.boba.network/api",
          browserURL: "https://blockexplorer.avax.boba.network",
        },
      }
    ]
  }
};
