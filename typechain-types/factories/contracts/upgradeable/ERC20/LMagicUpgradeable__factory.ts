/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../common";
import type {
  LMagicUpgradeable,
  LMagicUpgradeableInterface,
} from "../../../../contracts/upgradeable/ERC20/LMagicUpgradeable";

const _abi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
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
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "Paused",
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
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "Unpaused",
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
    inputs: [],
    name: "DOMAIN_SEPARATOR",
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
    name: "MINTER_ROLE",
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
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "addGlobalWhitelist",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "addWhitelist",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
    ],
    name: "allowance",
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
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "approve",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "balanceOf",
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
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "burn",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "burnFrom",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "claimPending",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "decimals",
    outputs: [
      {
        internalType: "uint8",
        name: "",
        type: "uint8",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "subtractedValue",
        type: "uint256",
      },
    ],
    name: "decreaseAllowance",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
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
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "addedValue",
        type: "uint256",
      },
    ],
    name: "increaseAllowance",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
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
        internalType: "address",
        name: "_address",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "mint",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "name",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
    ],
    name: "nonces",
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
    inputs: [],
    name: "pause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "paused",
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
        name: "_address",
        type: "address",
      },
    ],
    name: "pendingOf",
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
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "deadline",
        type: "uint256",
      },
      {
        internalType: "uint8",
        name: "v",
        type: "uint8",
      },
      {
        internalType: "bytes32",
        name: "r",
        type: "bytes32",
      },
      {
        internalType: "bytes32",
        name: "s",
        type: "bytes32",
      },
    ],
    name: "permit",
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
    inputs: [],
    name: "symbol",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "totalBurned",
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
        internalType: "address",
        name: "_address",
        type: "address",
      },
    ],
    name: "totalOf",
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
    inputs: [],
    name: "totalSupply",
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
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transfer",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transferFrom",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "unpause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const _bytecode =
  "0x60806040523480156200001157600080fd5b506200001c62000022565b620000e4565b600054610100900460ff16156200008f5760405162461bcd60e51b815260206004820152602760248201527f496e697469616c697a61626c653a20636f6e747261637420697320696e697469604482015266616c697a696e6760c81b606482015260840160405180910390fd5b60005460ff9081161015620000e2576000805460ff191660ff9081179091556040519081527f7f26b83ff96e1f2b6a682f133852f6798a09c465da95921460cefb38474024989060200160405180910390a15b565b6124ea80620000f46000396000f3fe608060405234801561001057600080fd5b506004361061021c5760003560e01c806379cc679011610125578063a73d633c116100ad578063d53913931161007c578063d53913931461046c578063d547741f14610493578063d89135cd146104a6578063dd62ed3e146104af578063f44136a1146104c257600080fd5b8063a73d633c14610420578063a9059cbb14610433578063b45cc84514610446578063d505accf1461045957600080fd5b8063912c2673116100f4578063912c2673146103c057806391d14854146103ea57806395d89b41146103fd578063a217fddf14610405578063a457c2d71461040d57600080fd5b806379cc67901461038a5780637ecebe001461039d5780638129fc1c146103b05780638456cb59146103b857600080fd5b80633644e515116101a857806340c10f191161017757806340c10f191461031b57806342966c681461032e5780635c975abb1461034157806370a082311461034c57806375b238fc1461037557600080fd5b80633644e515146102e557806336568abe146102ed57806339509351146103005780633f4ba83a1461031357600080fd5b806318160ddd116101ef57806318160ddd1461027b57806323b872dd1461028d578063248a9ca3146102a05780632f2ff15d146102c3578063313ce567146102d657600080fd5b806301ffc9a71461022157806303a9f06e1461024957806306fdde0314610253578063095ea7b314610268575b600080fd5b61023461022f366004611fa2565b6104d5565b60405190151581526020015b60405180910390f35b61025161050c565b005b61025b6105c0565b6040516102409190611ff0565b61023461027636600461203f565b610652565b6035545b604051908152602001610240565b61023461029b366004612069565b61066a565b61027f6102ae3660046120a5565b600090815260c9602052604090206001015490565b6102516102d13660046120be565b61068e565b60405160128152602001610240565b61027f6106b8565b6102516102fb3660046120be565b6106c7565b61023461030e36600461203f565b610746565b610251610768565b61025161032936600461203f565b61078b565b61025161033c3660046120a5565b610857565b60655460ff16610234565b61027f61035a3660046120ea565b6001600160a01b031660009081526033602052604090205490565b61027f60008051602061249583398151915281565b61025161039836600461203f565b6108c2565b61027f6103ab3660046120ea565b61092f565b61025161094e565b610251610b6d565b61027f6103ce3660046120ea565b6001600160a01b031660009081526101c8602052604090205490565b6102346103f83660046120be565b610b8d565b61025b610bb8565b61027f600081565b61023461041b36600461203f565b610bc7565b61025161042e366004612105565b610c42565b61023461044136600461203f565b610c76565b6102516104543660046120ea565b610c84565b61025161046736600461212f565b610c9b565b61027f7f9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a681565b6102516104a13660046120be565b610dff565b6101625461027f565b61027f6104bd366004612105565b610e24565b61027f6104d03660046120ea565b610e4f565b60006001600160e01b03198216637965db0b60e01b148061050657506301ffc9a760e01b6001600160e01b03198316145b92915050565b610514610f03565b600061051f33610e4f565b90508060000361052c5750565b610537335b82610f49565b6101c5546001600160a01b031663a9059cbb336040516001600160e01b031960e084901b1681526001600160a01b039091166004820152602481018490526044016020604051808303816000875af1158015610597573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906105bb91906121a2565b50505b565b6060603680546105cf906121c4565b80601f01602080910402602001604051908101604052809291908181526020018280546105fb906121c4565b80156106485780601f1061061d57610100808354040283529160200191610648565b820191906000526020600020905b81548152906001019060200180831161062b57829003601f168201915b5050505050905090565b6000336106608185856110a3565b5060019392505050565b6000336106788582856111c7565b61068385858561123b565b506001949350505050565b600082815260c960205260409020600101546106a981611414565b6106b3838361141e565b505050565b60006106c26114a4565b905090565b6001600160a01b038116331461073c5760405162461bcd60e51b815260206004820152602f60248201527f416363657373436f6e74726f6c3a2063616e206f6e6c792072656e6f756e636560448201526e103937b632b9903337b91039b2b63360891b60648201526084015b60405180910390fd5b6105bb828261151f565b6000336106608185856107598383610e24565b610763919061220e565b6110a3565b60008051602061249583398151915261078081611414565b610788611586565b50565b7f9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a66107b581611414565b6101c5546040516340c10f1960e01b8152306004820152602481018490526001600160a01b03909116906340c10f1990604401600060405180830381600087803b15801561080257600080fd5b505af1158015610816573d6000803e3d6000fd5b5050505061082483836115d8565b6001600160a01b03831660009081526101c860205260408120805484929061084d90849061220e565b9091555050505050565b610860816116c4565b6101c554604051630852cd8d60e31b8152600481018390526001600160a01b03909116906342966c6890602401600060405180830381600087803b1580156108a757600080fd5b505af11580156108bb573d6000803e3d6000fd5b5050505050565b6108cc82826116e6565b6101c554604051630852cd8d60e31b8152600481018390526001600160a01b03909116906342966c6890602401600060405180830381600087803b15801561091357600080fd5b505af1158015610927573d6000803e3d6000fd5b505050505050565b6001600160a01b038116600090815261012f6020526040812054610506565b600054610100900460ff161580801561096e5750600054600160ff909116105b806109885750303b158015610988575060005460ff166001145b6109eb5760405162461bcd60e51b815260206004820152602e60248201527f496e697469616c697a61626c653a20636f6e747261637420697320616c72656160448201526d191e481a5b9a5d1a585b1a5e995960921b6064820152608401610733565b6000805460ff191660011790558015610a0e576000805461ff0019166101001790555b610a54604051806040016040528060068152602001656c4d4147494360d01b815250604051806040016040528060068152602001656c4d4147494360d01b815250611714565b610a5c611745565b610a64611774565b610a8b604051806040016040528060068152602001656c4d4147494360d01b81525061179b565b610a93611774565b610a9e60003361141e565b610ab66000805160206124958339815191523361141e565b610ae07f9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a63361141e565b6101c580546001600160a01b031916739a8e0217cd870783c3f2317985c57bf5709691531790556363bea4c06101c7819055610b21906301e1338090612221565b6101c6558015610788576000805461ff0019169055604051600181527f7f26b83ff96e1f2b6a682f133852f6798a09c465da95921460cefb38474024989060200160405180910390a150565b600080516020612495833981519152610b8581611414565b6107886117e5565b600091825260c9602090815260408084206001600160a01b0393909316845291905290205460ff1690565b6060603780546105cf906121c4565b60003381610bd58286610e24565b905083811015610c355760405162461bcd60e51b815260206004820152602560248201527f45524332303a2064656372656173656420616c6c6f77616e63652062656c6f77604482015264207a65726f60d81b6064820152608401610733565b61068382868684036110a3565b6000610c4d81611414565b6001600160a01b03831660009081526101cb60205260409020610c709083611822565b50505050565b60003361066081858561123b565b6000610c8f81611414565b6106b36101c983611822565b83421115610ceb5760405162461bcd60e51b815260206004820152601d60248201527f45524332305065726d69743a206578706972656420646561646c696e650000006044820152606401610733565b60007f6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9888888610d1a8c61183e565b6040805160208101969096526001600160a01b0394851690860152929091166060840152608083015260a082015260c0810186905260e0016040516020818303038152906040528051906020012090506000610d7582611867565b90506000610d85828787876118b5565b9050896001600160a01b0316816001600160a01b031614610de85760405162461bcd60e51b815260206004820152601e60248201527f45524332305065726d69743a20696e76616c6964207369676e617475726500006044820152606401610733565b610df38a8a8a6110a3565b50505050505050505050565b600082815260c96020526040902060010154610e1a81611414565b6106b3838361151f565b6001600160a01b03918216600090815260346020908152604080832093909416825291909152205490565b6001600160a01b0381166000908152603360209081526040808320546101c89092528220548290610e81908390612221565b905060006101c6546101c754610e979190612221565b6001600160a01b03861660009081526101c86020526040902054610ebb9190612234565b90506000816101c65442610ecf9190612221565b610ed99190612256565b905080831015610ef757610eed8382612221565b9695505050505050565b50600095945050505050565b60655460ff16156105be5760405162461bcd60e51b815260206004820152601060248201526f14185d5cd8589b194e881c185d5cd95960821b6044820152606401610733565b6001600160a01b038216610fa95760405162461bcd60e51b815260206004820152602160248201527f45524332303a206275726e2066726f6d20746865207a65726f206164647265736044820152607360f81b6064820152608401610733565b610fb5826000836118dd565b6001600160a01b038216600090815260336020526040902054818110156110295760405162461bcd60e51b815260206004820152602260248201527f45524332303a206275726e20616d6f756e7420657863656564732062616c616e604482015261636560f01b6064820152608401610733565b6001600160a01b0383166000908152603360205260408120838303905560358054849290611058908490612221565b90915550506040518281526000906001600160a01b038516907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9060200160405180910390a3505050565b6001600160a01b0383166111055760405162461bcd60e51b8152602060048201526024808201527f45524332303a20617070726f76652066726f6d20746865207a65726f206164646044820152637265737360e01b6064820152608401610733565b6001600160a01b0382166111665760405162461bcd60e51b815260206004820152602260248201527f45524332303a20617070726f766520746f20746865207a65726f206164647265604482015261737360f01b6064820152608401610733565b6001600160a01b0383811660008181526034602090815260408083209487168084529482529182902085905590518481527f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925910160405180910390a3505050565b60006111d38484610e24565b90506000198114610c70578181101561122e5760405162461bcd60e51b815260206004820152601d60248201527f45524332303a20696e73756666696369656e7420616c6c6f77616e63650000006044820152606401610733565b610c7084848484036110a3565b6001600160a01b03831661129f5760405162461bcd60e51b815260206004820152602560248201527f45524332303a207472616e736665722066726f6d20746865207a65726f206164604482015264647265737360d81b6064820152608401610733565b6001600160a01b0382166113015760405162461bcd60e51b815260206004820152602360248201527f45524332303a207472616e7366657220746f20746865207a65726f206164647260448201526265737360e81b6064820152608401610733565b61130c8383836118dd565b6001600160a01b038316600090815260336020526040902054818110156113845760405162461bcd60e51b815260206004820152602660248201527f45524332303a207472616e7366657220616d6f756e7420657863656564732062604482015265616c616e636560d01b6064820152608401610733565b6001600160a01b038085166000908152603360205260408082208585039055918516815290812080548492906113bb90849061220e565b92505081905550826001600160a01b0316846001600160a01b03167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef8460405161140791815260200190565b60405180910390a3610c70565b6107888133611991565b6114288282610b8d565b6105bb57600082815260c9602090815260408083206001600160a01b03851684529091529020805460ff191660011790556114603390565b6001600160a01b0316816001600160a01b0316837f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d60405160405180910390a45050565b60006106c27f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f6114d360fb5490565b60fc546040805160208101859052908101839052606081018290524660808201523060a082015260009060c0016040516020818303038152906040528051906020012090509392505050565b6115298282610b8d565b156105bb57600082815260c9602090815260408083206001600160a01b0385168085529252808320805460ff1916905551339285917ff6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b9190a45050565b61158e6119f5565b6065805460ff191690557f5db9ee0a495bf2e6ff9c91a7834c1ba4fdd244a5e8aa4e537bd38aeae4b073aa335b6040516001600160a01b03909116815260200160405180910390a1565b6001600160a01b03821661162e5760405162461bcd60e51b815260206004820152601f60248201527f45524332303a206d696e7420746f20746865207a65726f2061646472657373006044820152606401610733565b61163a600083836118dd565b806035600082825461164c919061220e565b90915550506001600160a01b0382166000908152603360205260408120805483929061167990849061220e565b90915550506040518181526001600160a01b038316906000907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9060200160405180910390a36105bb565b8061016260008282546116d7919061220e565b90915550610788905033610531565b6116f18233836111c7565b806101626000828254611704919061220e565b909155506105bb90508282610f49565b600054610100900460ff1661173b5760405162461bcd60e51b815260040161073390612275565b6105bb8282611a3e565b600054610100900460ff1661176c5760405162461bcd60e51b815260040161073390612275565b6105be611a7e565b600054610100900460ff166105be5760405162461bcd60e51b815260040161073390612275565b600054610100900460ff166117c25760405162461bcd60e51b815260040161073390612275565b61078881604051806040016040528060018152602001603160f81b815250611ab1565b6117ed610f03565b6065805460ff191660011790557f62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a2586115bb3390565b6000611837836001600160a01b038416611af2565b9392505050565b6001600160a01b038116600090815261012f602052604090208054600181018255905b50919050565b60006105066118746114a4565b8360405161190160f01b6020820152602281018390526042810182905260009060620160405160208183030381529060405280519060200120905092915050565b60008060006118c687878787611b41565b915091506118d381611c2e565b5095945050505050565b6118e5610f03565b82826118f36101c982611de4565b8061191c57506001600160a01b03821660009081526101cb6020526040902061191c9082611de4565b8061192e57506001600160a01b038216155b8061194057506001600160a01b038116155b61198c5760405162461bcd60e51b815260206004820152601860248201527f6345564f206973206e6f6e2d7472616e7366657261626c6500000000000000006044820152606401610733565b6108bb565b61199b8282610b8d565b6105bb576119b3816001600160a01b03166014611e06565b6119be836020611e06565b6040516020016119cf9291906122c0565b60408051601f198184030181529082905262461bcd60e51b825261073391600401611ff0565b60655460ff166105be5760405162461bcd60e51b815260206004820152601460248201527314185d5cd8589b194e881b9bdd081c185d5cd95960621b6044820152606401610733565b600054610100900460ff16611a655760405162461bcd60e51b815260040161073390612275565b6036611a718382612391565b5060376106b38282612391565b600054610100900460ff16611aa55760405162461bcd60e51b815260040161073390612275565b6065805460ff19169055565b600054610100900460ff16611ad85760405162461bcd60e51b815260040161073390612275565b81516020928301208151919092012060fb9190915560fc55565b6000818152600183016020526040812054611b3957508154600181810184556000848152602080822090930184905584548482528286019093526040902091909155610506565b506000610506565b6000807f7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0831115611b785750600090506003611c25565b8460ff16601b14158015611b9057508460ff16601c14155b15611ba15750600090506004611c25565b6040805160008082526020820180845289905260ff881692820192909252606081018690526080810185905260019060a0016020604051602081039080840390855afa158015611bf5573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b038116611c1e57600060019250925050611c25565b9150600090505b94509492505050565b6000816004811115611c4257611c42612451565b03611c4a5750565b6001816004811115611c5e57611c5e612451565b03611cab5760405162461bcd60e51b815260206004820152601860248201527f45434453413a20696e76616c6964207369676e617475726500000000000000006044820152606401610733565b6002816004811115611cbf57611cbf612451565b03611d0c5760405162461bcd60e51b815260206004820152601f60248201527f45434453413a20696e76616c6964207369676e6174757265206c656e677468006044820152606401610733565b6003816004811115611d2057611d20612451565b03611d785760405162461bcd60e51b815260206004820152602260248201527f45434453413a20696e76616c6964207369676e6174757265202773272076616c604482015261756560f01b6064820152608401610733565b6004816004811115611d8c57611d8c612451565b036107885760405162461bcd60e51b815260206004820152602260248201527f45434453413a20696e76616c6964207369676e6174757265202776272076616c604482015261756560f01b6064820152608401610733565b6001600160a01b03811660009081526001830160205260408120541515611837565b60606000611e15836002612256565b611e2090600261220e565b67ffffffffffffffff811115611e3857611e38612335565b6040519080825280601f01601f191660200182016040528015611e62576020820181803683370190505b509050600360fc1b81600081518110611e7d57611e7d612467565b60200101906001600160f81b031916908160001a905350600f60fb1b81600181518110611eac57611eac612467565b60200101906001600160f81b031916908160001a9053506000611ed0846002612256565b611edb90600161220e565b90505b6001811115611f53576f181899199a1a9b1b9c1cb0b131b232b360811b85600f1660108110611f0f57611f0f612467565b1a60f81b828281518110611f2557611f25612467565b60200101906001600160f81b031916908160001a90535060049490941c93611f4c8161247d565b9050611ede565b5083156118375760405162461bcd60e51b815260206004820181905260248201527f537472696e67733a20686578206c656e67746820696e73756666696369656e746044820152606401610733565b600060208284031215611fb457600080fd5b81356001600160e01b03198116811461183757600080fd5b60005b83811015611fe7578181015183820152602001611fcf565b50506000910152565b602081526000825180602084015261200f816040850160208701611fcc565b601f01601f19169190910160400192915050565b80356001600160a01b038116811461203a57600080fd5b919050565b6000806040838503121561205257600080fd5b61205b83612023565b946020939093013593505050565b60008060006060848603121561207e57600080fd5b61208784612023565b925061209560208501612023565b9150604084013590509250925092565b6000602082840312156120b757600080fd5b5035919050565b600080604083850312156120d157600080fd5b823591506120e160208401612023565b90509250929050565b6000602082840312156120fc57600080fd5b61183782612023565b6000806040838503121561211857600080fd5b61212183612023565b91506120e160208401612023565b600080600080600080600060e0888a03121561214a57600080fd5b61215388612023565b965061216160208901612023565b95506040880135945060608801359350608088013560ff8116811461218557600080fd5b9699959850939692959460a0840135945060c09093013592915050565b6000602082840312156121b457600080fd5b8151801515811461183757600080fd5b600181811c908216806121d857607f821691505b60208210810361186157634e487b7160e01b600052602260045260246000fd5b634e487b7160e01b600052601160045260246000fd5b80820180821115610506576105066121f8565b81810381811115610506576105066121f8565b60008261225157634e487b7160e01b600052601260045260246000fd5b500490565b6000816000190483118215151615612270576122706121f8565b500290565b6020808252602b908201527f496e697469616c697a61626c653a20636f6e7472616374206973206e6f74206960408201526a6e697469616c697a696e6760a81b606082015260800190565b7f416363657373436f6e74726f6c3a206163636f756e74200000000000000000008152600083516122f8816017850160208801611fcc565b7001034b99036b4b9b9b4b733903937b6329607d1b6017918401918201528351612329816028840160208801611fcc565b01602801949350505050565b634e487b7160e01b600052604160045260246000fd5b601f8211156106b357600081815260208120601f850160051c810160208610156123725750805b601f850160051c820191505b818110156109275782815560010161237e565b815167ffffffffffffffff8111156123ab576123ab612335565b6123bf816123b984546121c4565b8461234b565b602080601f8311600181146123f457600084156123dc5750858301515b600019600386901b1c1916600185901b178555610927565b600085815260208120601f198616915b8281101561242357888601518255948401946001909101908401612404565b50858210156124415787850151600019600388901b60f8161c191681555b5050505050600190811b01905550565b634e487b7160e01b600052602160045260246000fd5b634e487b7160e01b600052603260045260246000fd5b60008161248c5761248c6121f8565b50600019019056fea49807205ce4d355092ef5a8a18f56e8913cf4a201fbe287825b095693c21775a2646970667358221220847fe788fc16b532975855c945c866df69eb4c9a659d3966603e01b891c4610f64736f6c63430008100033";

type LMagicUpgradeableConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: LMagicUpgradeableConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class LMagicUpgradeable__factory extends ContractFactory {
  constructor(...args: LMagicUpgradeableConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<LMagicUpgradeable> {
    return super.deploy(overrides || {}) as Promise<LMagicUpgradeable>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): LMagicUpgradeable {
    return super.attach(address) as LMagicUpgradeable;
  }
  override connect(signer: Signer): LMagicUpgradeable__factory {
    return super.connect(signer) as LMagicUpgradeable__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): LMagicUpgradeableInterface {
    return new utils.Interface(_abi) as LMagicUpgradeableInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): LMagicUpgradeable {
    return new Contract(address, _abi, signerOrProvider) as LMagicUpgradeable;
  }
}
