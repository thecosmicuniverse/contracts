import "@nomicfoundation/hardhat-toolbox";
import '@openzeppelin/hardhat-upgrades';
import { GetDefaultConfig } from "@dirtycajunrice/hardhat-tasks";
import "@dirtycajunrice/hardhat-tasks/tasks";

import "dotenv/config";

const config = GetDefaultConfig()
//@ts-ignore
config.networks.avalanche.url = "https://nd-878-841-440.p2pify.com/09c9f30d4ade5974b6b344c5115bf861/ext/bc/C/rpc"

//@ts-ignore
config.etherscan?.apiKey.avalanche = process.env.SNOWTRACE_API_KEY
export default config;
