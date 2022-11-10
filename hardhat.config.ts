import "@nomicfoundation/hardhat-toolbox";
import '@openzeppelin/hardhat-upgrades';

import "dotenv/config";

import "./tasks/deployUpgradeable";
import "./tasks/upgrade";
import "./tasks/getUpgradeDetails";
import "./tasks/queries";
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.16",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
      {
        version: "0.8.9",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
      {
        version: "0.8.2",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      },
      {
        version: "0.6.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      }
    ],
    overrides: {
      "contracts/proxy/AdminUpgradeabilityProxy.sol": {
        version: "0.8.2",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      }
    }
  },
  networks: {
    harmony: {
      url: 'https://api.harmony.one',
      chainId: 1666600000,
      accounts: [process.env.PRIVATE_KEY]
    },
    harmonyTest: {
      url: 'https://api.s0.b.hmny.io',
      chainId: 1666700000,
      accounts: [process.env.PRIVATE_KEY]
    },
    optimisticEthereum: {
      url: 'https://mainnet.optimism.io',
      chainId: 10,
      accounts: [process.env.PRIVATE_KEY]
    },
    polygon: {
      url: 'https://polygon-mainnet.public.blastapi.io',
      chainId: 137,
      accounts: [process.env.PRIVATE_KEY]
    },
    arbitrumOne: {
      url: 'https://arb1.arbitrum.io/rpc',
      chainId: 42161,
      accounts: [process.env.PRIVATE_KEY]
    },
    opera: {
      url: 'https://fantom-mainnet.public.blastapi.io',
      chainId: 250,
      accounts: [process.env.PRIVATE_KEY]
    },
    avalanche: {
      url: process.env.AVALANCHE_RPC || 'https://ava-mainnet.public.blastapi.io/ext/bc/C/rpc',
      chainId: 43114,
      accounts: [process.env.PRIVATE_KEY]
    },
    cronos: {
      url: 'https://evm.cronos.org',
      chainId: 25,
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
      harmonyTest: 'not needed',
      optimisticEthereum: process.env.OPTIMISTIC_API_KEY,
      polygon: process.env.POLYGONSCAN_API_KEY,
      arbitrumOne: process.env.ARBISCAN_API_KEY,
      opera: process.env.FTMSCAN_API_KEY,
      avalanche: process.env.SNOWTRACE_API_KEY,
      cronos: process.env.CRONOSCAN_API_KEY,
      boba: 'not needed'
    },
    customChains: [
      {
        network: "cronos",
        chainId: 25,
        urls: {
          apiURL: "https://api.cronoscan.com/api",
          browserURL: "https://cronoscan.com/",
        },
      },
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
