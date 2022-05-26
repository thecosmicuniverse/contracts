import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import '@openzeppelin/hardhat-upgrades';
import "@nomiclabs/hardhat-etherscan";

import "dotenv/config";

import "./tasks/deployUpgradeable";
import "./tasks/upgrade";
import "./tasks/getUpgradeDetails";

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.11",
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
      url: "https://rpc.cosmicuniverse.one/",
      chainId: 1666600000,
      accounts: [process.env.PRIVATE_KEY]
    },
    harmonyTest: {
      url: 'https://api.s0.b.hmny.io',
      chainId: 1666700000,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: {
      harmony: 'not needed',
      harmonyTest: 'not needed'
    }
  }
};
