/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  Blacklistable,
  BlacklistableInterface,
} from "../../../../contracts/upgradeable/utils/Blacklistable";

const _abi = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint8",
        name: "version",
        type: "uint8",
      },
    ],
    name: "Initialized",
    type: "event",
  },
  {
    inputs: [],
    name: "getBlacklisted",
    outputs: [
      {
        internalType: "address[]",
        name: "",
        type: "address[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "user",
        type: "address",
      },
    ],
    name: "isBlacklisted",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

export class Blacklistable__factory {
  static readonly abi = _abi;
  static createInterface(): BlacklistableInterface {
    return new utils.Interface(_abi) as BlacklistableInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): Blacklistable {
    return new Contract(address, _abi, signerOrProvider) as Blacklistable;
  }
}
