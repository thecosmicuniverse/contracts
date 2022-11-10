/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../common";
import type {
  TreasuryUpgradeable,
  TreasuryUpgradeableInterface,
} from "../../../contracts/marketplace/TreasuryUpgradeable";

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
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "bytes32",
        name: "previousAdminRole",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "bytes32",
        name: "newAdminRole",
        type: "bytes32",
      },
    ],
    name: "RoleAdminChanged",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "sender",
        type: "address",
      },
    ],
    name: "RoleGranted",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "sender",
        type: "address",
      },
    ],
    name: "RoleRevoked",
    type: "event",
  },
  {
    inputs: [],
    name: "ADMIN_ROLE",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "AUTHORIZED_ROLE",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "DEFAULT_ADMIN_ROLE",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
    ],
    name: "getRoleAdmin",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "uint256",
        name: "index",
        type: "uint256",
      },
    ],
    name: "getRoleMember",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
    ],
    name: "getRoleMemberCount",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "grantRole",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "hasRole",
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
  {
    inputs: [],
    name: "initialize",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "renounceRole",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "revokeRole",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes4",
        name: "interfaceId",
        type: "bytes4",
      },
    ],
    name: "supportsInterface",
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
  {
    inputs: [
      {
        internalType: "address",
        name: "tokenAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "balance",
        type: "uint256",
      },
    ],
    name: "withdraw",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const _bytecode =
  "0x608060405234801561001057600080fd5b50610de1806100206000396000f3fe608060405234801561001057600080fd5b50600436106100cf5760003560e01c80639010d07c1161008c578063ca15c87311610066578063ca15c873146101ca578063d547741f146101dd578063f3fef3a3146101f0578063f64682511461020357600080fd5b80639010d07c1461018457806391d14854146101af578063a217fddf146101c257600080fd5b806301ffc9a7146100d4578063248a9ca3146100fc5780632f2ff15d1461012d57806336568abe1461014257806375b238fc146101555780638129fc1c1461017c575b600080fd5b6100e76100e2366004610b32565b61022a565b60405190151581526020015b60405180910390f35b61011f61010a366004610b5c565b60009081526065602052604090206001015490565b6040519081526020016100f3565b61014061013b366004610b91565b610255565b005b610140610150366004610b91565b61027f565b61011f7fa49807205ce4d355092ef5a8a18f56e8913cf4a201fbe287825b095693c2177581565b610140610302565b610197610192366004610bbd565b610472565b6040516001600160a01b0390911681526020016100f3565b6100e76101bd366004610b91565b610491565b61011f600081565b61011f6101d8366004610b5c565b6104bc565b6101406101eb366004610b91565b6104d3565b6101406101fe366004610bdf565b6104f8565b61011f7f0393b4c1b6519e8b53ae0efa1ab522060a3b9f8d86d09c8a22ca6d6eea735cf781565b60006001600160e01b03198216635a05180f60e01b148061024f575061024f826105a9565b92915050565b600082815260656020526040902060010154610270816105de565b61027a83836105e8565b505050565b6001600160a01b03811633146102f45760405162461bcd60e51b815260206004820152602f60248201527f416363657373436f6e74726f6c3a2063616e206f6e6c792072656e6f756e636560448201526e103937b632b9903337b91039b2b63360891b60648201526084015b60405180910390fd5b6102fe828261060a565b5050565b600054610100900460ff16158080156103225750600054600160ff909116105b8061033c5750303b15801561033c575060005460ff166001145b61039f5760405162461bcd60e51b815260206004820152602e60248201527f496e697469616c697a61626c653a20636f6e747261637420697320616c72656160448201526d191e481a5b9a5d1a585b1a5e995960921b60648201526084016102eb565b6000805460ff1916600117905580156103c2576000805461ff0019166101001790555b6103ca61062c565b6103d56000336105e8565b6103ff7fa49807205ce4d355092ef5a8a18f56e8913cf4a201fbe287825b095693c21775336105e8565b6104297f0393b4c1b6519e8b53ae0efa1ab522060a3b9f8d86d09c8a22ca6d6eea735cf7336105e8565b801561046f576000805461ff0019169055604051600181527f7f26b83ff96e1f2b6a682f133852f6798a09c465da95921460cefb38474024989060200160405180910390a15b50565b600082815260976020526040812061048a9083610699565b9392505050565b60009182526065602090815260408084206001600160a01b0393909316845291905290205460ff1690565b600081815260976020526040812061024f906106a5565b6000828152606560205260409020600101546104ee816105de565b61027a838361060a565b7fa49807205ce4d355092ef5a8a18f56e8913cf4a201fbe287825b095693c21775610522816105de565b6001600160a01b03831663a9059cbb336040516001600160e01b031960e084901b1681526001600160a01b039091166004820152602481018590526044016020604051808303816000875af115801561057f573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906105a39190610c09565b50505050565b60006001600160e01b03198216637965db0b60e01b148061024f57506301ffc9a760e01b6001600160e01b031983161461024f565b61046f81336106af565b6105f28282610713565b600082815260976020526040902061027a9082610799565b61061482826107ae565b600082815260976020526040902061027a9082610815565b600054610100900460ff166106975760405162461bcd60e51b815260206004820152602b60248201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960448201526a6e697469616c697a696e6760a81b60648201526084016102eb565b565b600061048a838361082a565b600061024f825490565b6106b98282610491565b6102fe576106d1816001600160a01b03166014610854565b6106dc836020610854565b6040516020016106ed929190610c4f565b60408051601f198184030181529082905262461bcd60e51b82526102eb91600401610cc4565b61071d8282610491565b6102fe5760008281526065602090815260408083206001600160a01b03851684529091529020805460ff191660011790556107553390565b6001600160a01b0316816001600160a01b0316837f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d60405160405180910390a45050565b600061048a836001600160a01b0384166109f0565b6107b88282610491565b156102fe5760008281526065602090815260408083206001600160a01b0385168085529252808320805460ff1916905551339285917ff6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b9190a45050565b600061048a836001600160a01b038416610a3f565b600082600001828154811061084157610841610cf7565b9060005260206000200154905092915050565b60606000610863836002610d23565b61086e906002610d42565b67ffffffffffffffff81111561088657610886610d55565b6040519080825280601f01601f1916602001820160405280156108b0576020820181803683370190505b509050600360fc1b816000815181106108cb576108cb610cf7565b60200101906001600160f81b031916908160001a905350600f60fb1b816001815181106108fa576108fa610cf7565b60200101906001600160f81b031916908160001a905350600061091e846002610d23565b610929906001610d42565b90505b60018111156109a1576f181899199a1a9b1b9c1cb0b131b232b360811b85600f166010811061095d5761095d610cf7565b1a60f81b82828151811061097357610973610cf7565b60200101906001600160f81b031916908160001a90535060049490941c9361099a81610d6b565b905061092c565b50831561048a5760405162461bcd60e51b815260206004820181905260248201527f537472696e67733a20686578206c656e67746820696e73756666696369656e7460448201526064016102eb565b6000818152600183016020526040812054610a375750815460018181018455600084815260208082209093018490558454848252828601909352604090209190915561024f565b50600061024f565b60008181526001830160205260408120548015610b28576000610a63600183610d82565b8554909150600090610a7790600190610d82565b9050818114610adc576000866000018281548110610a9757610a97610cf7565b9060005260206000200154905080876000018481548110610aba57610aba610cf7565b6000918252602080832090910192909255918252600188019052604090208390555b8554869080610aed57610aed610d95565b60019003818190600052602060002001600090559055856001016000868152602001908152602001600020600090556001935050505061024f565b600091505061024f565b600060208284031215610b4457600080fd5b81356001600160e01b03198116811461048a57600080fd5b600060208284031215610b6e57600080fd5b5035919050565b80356001600160a01b0381168114610b8c57600080fd5b919050565b60008060408385031215610ba457600080fd5b82359150610bb460208401610b75565b90509250929050565b60008060408385031215610bd057600080fd5b50508035926020909101359150565b60008060408385031215610bf257600080fd5b610bfb83610b75565b946020939093013593505050565b600060208284031215610c1b57600080fd5b8151801515811461048a57600080fd5b60005b83811015610c46578181015183820152602001610c2e565b50506000910152565b7f416363657373436f6e74726f6c3a206163636f756e7420000000000000000000815260008351610c87816017850160208801610c2b565b7001034b99036b4b9b9b4b733903937b6329607d1b6017918401918201528351610cb8816028840160208801610c2b565b01602801949350505050565b6020815260008251806020840152610ce3816040850160208701610c2b565b601f01601f19169190910160400192915050565b634e487b7160e01b600052603260045260246000fd5b634e487b7160e01b600052601160045260246000fd5b6000816000190483118215151615610d3d57610d3d610d0d565b500290565b8082018082111561024f5761024f610d0d565b634e487b7160e01b600052604160045260246000fd5b600081610d7a57610d7a610d0d565b506000190190565b8181038181111561024f5761024f610d0d565b634e487b7160e01b600052603160045260246000fdfea26469706673582212204927a2395696104a0e51d54a69e35bc63ec2eed9087bd152b20f64d1a40eede764736f6c63430008100033";

type TreasuryUpgradeableConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: TreasuryUpgradeableConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class TreasuryUpgradeable__factory extends ContractFactory {
  constructor(...args: TreasuryUpgradeableConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<TreasuryUpgradeable> {
    return super.deploy(overrides || {}) as Promise<TreasuryUpgradeable>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): TreasuryUpgradeable {
    return super.attach(address) as TreasuryUpgradeable;
  }
  override connect(signer: Signer): TreasuryUpgradeable__factory {
    return super.connect(signer) as TreasuryUpgradeable__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): TreasuryUpgradeableInterface {
    return new utils.Interface(_abi) as TreasuryUpgradeableInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): TreasuryUpgradeable {
    return new Contract(address, _abi, signerOrProvider) as TreasuryUpgradeable;
  }
}