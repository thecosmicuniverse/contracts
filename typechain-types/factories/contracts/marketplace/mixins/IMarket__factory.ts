/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  IMarket,
  IMarketInterface,
} from "../../../../contracts/marketplace/mixins/IMarket";

const _abi = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "saleIdToSale",
    outputs: [
      {
        components: [
          {
            internalType: "enum IMarket.SaleType",
            name: "saleType",
            type: "uint8",
          },
          {
            internalType: "address",
            name: "seller",
            type: "address",
          },
          {
            internalType: "address",
            name: "contractAddress",
            type: "address",
          },
          {
            internalType: "enum IMarket.TokenType",
            name: "tokenType",
            type: "uint8",
          },
          {
            internalType: "uint256[]",
            name: "tokenIds",
            type: "uint256[]",
          },
          {
            internalType: "uint256[]",
            name: "values",
            type: "uint256[]",
          },
          {
            internalType: "address",
            name: "bidToken",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "startTime",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "duration",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "extensionDuration",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "endTime",
            type: "uint256",
          },
          {
            internalType: "address",
            name: "bidder",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "bidAmount",
            type: "uint256",
          },
        ],
        internalType: "struct IMarket.Sale",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

export class IMarket__factory {
  static readonly abi = _abi;
  static createInterface(): IMarketInterface {
    return new utils.Interface(_abi) as IMarketInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IMarket {
    return new Contract(address, _abi, signerOrProvider) as IMarket;
  }
}
