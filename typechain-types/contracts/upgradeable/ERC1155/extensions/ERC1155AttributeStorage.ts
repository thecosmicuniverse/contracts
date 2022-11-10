/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type {
  FunctionFragment,
  Result,
  EventFragment,
} from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "../../../../common";

export interface ERC1155AttributeStorageInterface extends utils.Interface {
  functions: {
    "CONTRACT_ROLE()": FunctionFragment;
    "DEFAULT_ADMIN_ROLE()": FunctionFragment;
    "batchGetAttribute(uint256,uint256[])": FunctionFragment;
    "batchSetAttribute(uint256,uint256[],uint256[])": FunctionFragment;
    "batchSetAttributeName(uint256,uint256[],string[])": FunctionFragment;
    "batchSetAttributeNames(uint256[],uint256[],string[])": FunctionFragment;
    "getAttribute(uint256,uint256)": FunctionFragment;
    "getRoleAdmin(bytes32)": FunctionFragment;
    "getRoleMember(bytes32,uint256)": FunctionFragment;
    "getRoleMemberCount(bytes32)": FunctionFragment;
    "grantRole(bytes32,address)": FunctionFragment;
    "hasRole(bytes32,address)": FunctionFragment;
    "renounceRole(bytes32,address)": FunctionFragment;
    "revokeRole(bytes32,address)": FunctionFragment;
    "setAttribute(uint256,uint256,uint256)": FunctionFragment;
    "setAttributeName(uint256,uint256,string)": FunctionFragment;
    "supportsInterface(bytes4)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "CONTRACT_ROLE"
      | "DEFAULT_ADMIN_ROLE"
      | "batchGetAttribute"
      | "batchSetAttribute"
      | "batchSetAttributeName"
      | "batchSetAttributeNames"
      | "getAttribute"
      | "getRoleAdmin"
      | "getRoleMember"
      | "getRoleMemberCount"
      | "grantRole"
      | "hasRole"
      | "renounceRole"
      | "revokeRole"
      | "setAttribute"
      | "setAttributeName"
      | "supportsInterface"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "CONTRACT_ROLE",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "DEFAULT_ADMIN_ROLE",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "batchGetAttribute",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "batchSetAttribute",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>[],
      PromiseOrValue<BigNumberish>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "batchSetAttributeName",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>[],
      PromiseOrValue<string>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "batchSetAttributeNames",
    values: [
      PromiseOrValue<BigNumberish>[],
      PromiseOrValue<BigNumberish>[],
      PromiseOrValue<string>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "getAttribute",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getRoleAdmin",
    values: [PromiseOrValue<BytesLike>]
  ): string;
  encodeFunctionData(
    functionFragment: "getRoleMember",
    values: [PromiseOrValue<BytesLike>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getRoleMemberCount",
    values: [PromiseOrValue<BytesLike>]
  ): string;
  encodeFunctionData(
    functionFragment: "grantRole",
    values: [PromiseOrValue<BytesLike>, PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "hasRole",
    values: [PromiseOrValue<BytesLike>, PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "renounceRole",
    values: [PromiseOrValue<BytesLike>, PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "revokeRole",
    values: [PromiseOrValue<BytesLike>, PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "setAttribute",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "setAttributeName",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "supportsInterface",
    values: [PromiseOrValue<BytesLike>]
  ): string;

  decodeFunctionResult(
    functionFragment: "CONTRACT_ROLE",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "DEFAULT_ADMIN_ROLE",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "batchGetAttribute",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "batchSetAttribute",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "batchSetAttributeName",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "batchSetAttributeNames",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAttribute",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getRoleAdmin",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getRoleMember",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getRoleMemberCount",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "grantRole", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "hasRole", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "renounceRole",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "revokeRole", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "setAttribute",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setAttributeName",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "supportsInterface",
    data: BytesLike
  ): Result;

  events: {
    "Initialized(uint8)": EventFragment;
    "NameUpdated(uint256,uint256,string)": EventFragment;
    "NamesUpdated(uint256,uint256[],string[])": EventFragment;
    "RoleAdminChanged(bytes32,bytes32,bytes32)": EventFragment;
    "RoleGranted(bytes32,address,address)": EventFragment;
    "RoleRevoked(bytes32,address,address)": EventFragment;
    "ValueUpdated(uint256,uint256,uint256)": EventFragment;
    "ValuesUpdated(uint256,uint256[],uint256[])": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "Initialized"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "NameUpdated"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "NamesUpdated"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "RoleAdminChanged"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "RoleGranted"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "RoleRevoked"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "ValueUpdated"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "ValuesUpdated"): EventFragment;
}

export interface InitializedEventObject {
  version: number;
}
export type InitializedEvent = TypedEvent<[number], InitializedEventObject>;

export type InitializedEventFilter = TypedEventFilter<InitializedEvent>;

export interface NameUpdatedEventObject {
  tokenId: BigNumber;
  attributeId: BigNumber;
  name: string;
}
export type NameUpdatedEvent = TypedEvent<
  [BigNumber, BigNumber, string],
  NameUpdatedEventObject
>;

export type NameUpdatedEventFilter = TypedEventFilter<NameUpdatedEvent>;

export interface NamesUpdatedEventObject {
  tokenId: BigNumber;
  attributeIds: BigNumber[];
  names: string[];
}
export type NamesUpdatedEvent = TypedEvent<
  [BigNumber, BigNumber[], string[]],
  NamesUpdatedEventObject
>;

export type NamesUpdatedEventFilter = TypedEventFilter<NamesUpdatedEvent>;

export interface RoleAdminChangedEventObject {
  role: string;
  previousAdminRole: string;
  newAdminRole: string;
}
export type RoleAdminChangedEvent = TypedEvent<
  [string, string, string],
  RoleAdminChangedEventObject
>;

export type RoleAdminChangedEventFilter =
  TypedEventFilter<RoleAdminChangedEvent>;

export interface RoleGrantedEventObject {
  role: string;
  account: string;
  sender: string;
}
export type RoleGrantedEvent = TypedEvent<
  [string, string, string],
  RoleGrantedEventObject
>;

export type RoleGrantedEventFilter = TypedEventFilter<RoleGrantedEvent>;

export interface RoleRevokedEventObject {
  role: string;
  account: string;
  sender: string;
}
export type RoleRevokedEvent = TypedEvent<
  [string, string, string],
  RoleRevokedEventObject
>;

export type RoleRevokedEventFilter = TypedEventFilter<RoleRevokedEvent>;

export interface ValueUpdatedEventObject {
  tokenId: BigNumber;
  attributeId: BigNumber;
  value: BigNumber;
}
export type ValueUpdatedEvent = TypedEvent<
  [BigNumber, BigNumber, BigNumber],
  ValueUpdatedEventObject
>;

export type ValueUpdatedEventFilter = TypedEventFilter<ValueUpdatedEvent>;

export interface ValuesUpdatedEventObject {
  tokenId: BigNumber;
  attributeIds: BigNumber[];
  values: BigNumber[];
}
export type ValuesUpdatedEvent = TypedEvent<
  [BigNumber, BigNumber[], BigNumber[]],
  ValuesUpdatedEventObject
>;

export type ValuesUpdatedEventFilter = TypedEventFilter<ValuesUpdatedEvent>;

export interface ERC1155AttributeStorage extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: ERC1155AttributeStorageInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    CONTRACT_ROLE(overrides?: CallOverrides): Promise<[string]>;

    DEFAULT_ADMIN_ROLE(overrides?: CallOverrides): Promise<[string]>;

    batchGetAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    batchSetAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      values: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    batchSetAttributeName(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      names: PromiseOrValue<string>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    batchSetAttributeNames(
      tokenIds: PromiseOrValue<BigNumberish>[],
      attributeIds: PromiseOrValue<BigNumberish>[],
      names: PromiseOrValue<string>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    getAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    getRoleAdmin(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<[string]>;

    getRoleMember(
      role: PromiseOrValue<BytesLike>,
      index: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[string]>;

    getRoleMemberCount(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    grantRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    hasRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[boolean]>;

    renounceRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    revokeRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setAttributeName(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      name: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    supportsInterface(
      interfaceId: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<[boolean]>;
  };

  CONTRACT_ROLE(overrides?: CallOverrides): Promise<string>;

  DEFAULT_ADMIN_ROLE(overrides?: CallOverrides): Promise<string>;

  batchGetAttribute(
    tokenId: PromiseOrValue<BigNumberish>,
    attributeIds: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  batchSetAttribute(
    tokenId: PromiseOrValue<BigNumberish>,
    attributeIds: PromiseOrValue<BigNumberish>[],
    values: PromiseOrValue<BigNumberish>[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  batchSetAttributeName(
    tokenId: PromiseOrValue<BigNumberish>,
    attributeIds: PromiseOrValue<BigNumberish>[],
    names: PromiseOrValue<string>[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  batchSetAttributeNames(
    tokenIds: PromiseOrValue<BigNumberish>[],
    attributeIds: PromiseOrValue<BigNumberish>[],
    names: PromiseOrValue<string>[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  getAttribute(
    tokenId: PromiseOrValue<BigNumberish>,
    attributeId: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  getRoleAdmin(
    role: PromiseOrValue<BytesLike>,
    overrides?: CallOverrides
  ): Promise<string>;

  getRoleMember(
    role: PromiseOrValue<BytesLike>,
    index: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<string>;

  getRoleMemberCount(
    role: PromiseOrValue<BytesLike>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  grantRole(
    role: PromiseOrValue<BytesLike>,
    account: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  hasRole(
    role: PromiseOrValue<BytesLike>,
    account: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<boolean>;

  renounceRole(
    role: PromiseOrValue<BytesLike>,
    account: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  revokeRole(
    role: PromiseOrValue<BytesLike>,
    account: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setAttribute(
    tokenId: PromiseOrValue<BigNumberish>,
    attributeId: PromiseOrValue<BigNumberish>,
    value: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setAttributeName(
    tokenId: PromiseOrValue<BigNumberish>,
    attributeId: PromiseOrValue<BigNumberish>,
    name: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  supportsInterface(
    interfaceId: PromiseOrValue<BytesLike>,
    overrides?: CallOverrides
  ): Promise<boolean>;

  callStatic: {
    CONTRACT_ROLE(overrides?: CallOverrides): Promise<string>;

    DEFAULT_ADMIN_ROLE(overrides?: CallOverrides): Promise<string>;

    batchGetAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    batchSetAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      values: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<void>;

    batchSetAttributeName(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      names: PromiseOrValue<string>[],
      overrides?: CallOverrides
    ): Promise<void>;

    batchSetAttributeNames(
      tokenIds: PromiseOrValue<BigNumberish>[],
      attributeIds: PromiseOrValue<BigNumberish>[],
      names: PromiseOrValue<string>[],
      overrides?: CallOverrides
    ): Promise<void>;

    getAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getRoleAdmin(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<string>;

    getRoleMember(
      role: PromiseOrValue<BytesLike>,
      index: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<string>;

    getRoleMemberCount(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    grantRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    hasRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<boolean>;

    renounceRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    revokeRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    setAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    setAttributeName(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      name: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    supportsInterface(
      interfaceId: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<boolean>;
  };

  filters: {
    "Initialized(uint8)"(version?: null): InitializedEventFilter;
    Initialized(version?: null): InitializedEventFilter;

    "NameUpdated(uint256,uint256,string)"(
      tokenId?: PromiseOrValue<BigNumberish> | null,
      attributeId?: null,
      name?: null
    ): NameUpdatedEventFilter;
    NameUpdated(
      tokenId?: PromiseOrValue<BigNumberish> | null,
      attributeId?: null,
      name?: null
    ): NameUpdatedEventFilter;

    "NamesUpdated(uint256,uint256[],string[])"(
      tokenId?: PromiseOrValue<BigNumberish> | null,
      attributeIds?: null,
      names?: null
    ): NamesUpdatedEventFilter;
    NamesUpdated(
      tokenId?: PromiseOrValue<BigNumberish> | null,
      attributeIds?: null,
      names?: null
    ): NamesUpdatedEventFilter;

    "RoleAdminChanged(bytes32,bytes32,bytes32)"(
      role?: PromiseOrValue<BytesLike> | null,
      previousAdminRole?: PromiseOrValue<BytesLike> | null,
      newAdminRole?: PromiseOrValue<BytesLike> | null
    ): RoleAdminChangedEventFilter;
    RoleAdminChanged(
      role?: PromiseOrValue<BytesLike> | null,
      previousAdminRole?: PromiseOrValue<BytesLike> | null,
      newAdminRole?: PromiseOrValue<BytesLike> | null
    ): RoleAdminChangedEventFilter;

    "RoleGranted(bytes32,address,address)"(
      role?: PromiseOrValue<BytesLike> | null,
      account?: PromiseOrValue<string> | null,
      sender?: PromiseOrValue<string> | null
    ): RoleGrantedEventFilter;
    RoleGranted(
      role?: PromiseOrValue<BytesLike> | null,
      account?: PromiseOrValue<string> | null,
      sender?: PromiseOrValue<string> | null
    ): RoleGrantedEventFilter;

    "RoleRevoked(bytes32,address,address)"(
      role?: PromiseOrValue<BytesLike> | null,
      account?: PromiseOrValue<string> | null,
      sender?: PromiseOrValue<string> | null
    ): RoleRevokedEventFilter;
    RoleRevoked(
      role?: PromiseOrValue<BytesLike> | null,
      account?: PromiseOrValue<string> | null,
      sender?: PromiseOrValue<string> | null
    ): RoleRevokedEventFilter;

    "ValueUpdated(uint256,uint256,uint256)"(
      tokenId?: PromiseOrValue<BigNumberish> | null,
      attributeId?: null,
      value?: null
    ): ValueUpdatedEventFilter;
    ValueUpdated(
      tokenId?: PromiseOrValue<BigNumberish> | null,
      attributeId?: null,
      value?: null
    ): ValueUpdatedEventFilter;

    "ValuesUpdated(uint256,uint256[],uint256[])"(
      tokenId?: PromiseOrValue<BigNumberish> | null,
      attributeIds?: null,
      values?: null
    ): ValuesUpdatedEventFilter;
    ValuesUpdated(
      tokenId?: PromiseOrValue<BigNumberish> | null,
      attributeIds?: null,
      values?: null
    ): ValuesUpdatedEventFilter;
  };

  estimateGas: {
    CONTRACT_ROLE(overrides?: CallOverrides): Promise<BigNumber>;

    DEFAULT_ADMIN_ROLE(overrides?: CallOverrides): Promise<BigNumber>;

    batchGetAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    batchSetAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      values: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    batchSetAttributeName(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      names: PromiseOrValue<string>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    batchSetAttributeNames(
      tokenIds: PromiseOrValue<BigNumberish>[],
      attributeIds: PromiseOrValue<BigNumberish>[],
      names: PromiseOrValue<string>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    getAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getRoleAdmin(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getRoleMember(
      role: PromiseOrValue<BytesLike>,
      index: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getRoleMemberCount(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    grantRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    hasRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    renounceRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    revokeRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setAttributeName(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      name: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    supportsInterface(
      interfaceId: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    CONTRACT_ROLE(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    DEFAULT_ADMIN_ROLE(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    batchGetAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    batchSetAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      values: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    batchSetAttributeName(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeIds: PromiseOrValue<BigNumberish>[],
      names: PromiseOrValue<string>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    batchSetAttributeNames(
      tokenIds: PromiseOrValue<BigNumberish>[],
      attributeIds: PromiseOrValue<BigNumberish>[],
      names: PromiseOrValue<string>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    getAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getRoleAdmin(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getRoleMember(
      role: PromiseOrValue<BytesLike>,
      index: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getRoleMemberCount(
      role: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    grantRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    hasRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    renounceRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    revokeRole(
      role: PromiseOrValue<BytesLike>,
      account: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setAttribute(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setAttributeName(
      tokenId: PromiseOrValue<BigNumberish>,
      attributeId: PromiseOrValue<BigNumberish>,
      name: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    supportsInterface(
      interfaceId: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}
