/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type { BaseContract, BigNumber, Signer, utils } from "ethers";
import type { EventFragment } from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "../../../../../common";

export interface IElvenAdventuresInterface extends utils.Interface {
  functions: {};

  events: {
    "BeganAdventure(address,uint256)": EventFragment;
    "BeganQuest(address,uint256,uint256,uint256,uint256)": EventFragment;
    "CancelledQuest(address,uint256,uint256)": EventFragment;
    "FinishedAdventure(address,uint256)": EventFragment;
    "FinishedQuest(address,uint256,uint256,uint256)": EventFragment;
    "UnlockedAdventures(address,uint256)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "BeganAdventure"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "BeganQuest"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "CancelledQuest"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "FinishedAdventure"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "FinishedQuest"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "UnlockedAdventures"): EventFragment;
}

export interface BeganAdventureEventObject {
  from: string;
  tokenId: BigNumber;
}
export type BeganAdventureEvent = TypedEvent<
  [string, BigNumber],
  BeganAdventureEventObject
>;

export type BeganAdventureEventFilter = TypedEventFilter<BeganAdventureEvent>;

export interface BeganQuestEventObject {
  from: string;
  tokenId: BigNumber;
  skillId: BigNumber;
  level: BigNumber;
  completeAt: BigNumber;
}
export type BeganQuestEvent = TypedEvent<
  [string, BigNumber, BigNumber, BigNumber, BigNumber],
  BeganQuestEventObject
>;

export type BeganQuestEventFilter = TypedEventFilter<BeganQuestEvent>;

export interface CancelledQuestEventObject {
  from: string;
  tokenId: BigNumber;
  skillId: BigNumber;
}
export type CancelledQuestEvent = TypedEvent<
  [string, BigNumber, BigNumber],
  CancelledQuestEventObject
>;

export type CancelledQuestEventFilter = TypedEventFilter<CancelledQuestEvent>;

export interface FinishedAdventureEventObject {
  from: string;
  tokenId: BigNumber;
}
export type FinishedAdventureEvent = TypedEvent<
  [string, BigNumber],
  FinishedAdventureEventObject
>;

export type FinishedAdventureEventFilter =
  TypedEventFilter<FinishedAdventureEvent>;

export interface FinishedQuestEventObject {
  from: string;
  tokenId: BigNumber;
  skillId: BigNumber;
  level: BigNumber;
}
export type FinishedQuestEvent = TypedEvent<
  [string, BigNumber, BigNumber, BigNumber],
  FinishedQuestEventObject
>;

export type FinishedQuestEventFilter = TypedEventFilter<FinishedQuestEvent>;

export interface UnlockedAdventuresEventObject {
  from: string;
  tokenId: BigNumber;
}
export type UnlockedAdventuresEvent = TypedEvent<
  [string, BigNumber],
  UnlockedAdventuresEventObject
>;

export type UnlockedAdventuresEventFilter =
  TypedEventFilter<UnlockedAdventuresEvent>;

export interface IElvenAdventures extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IElvenAdventuresInterface;

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

  functions: {};

  callStatic: {};

  filters: {
    "BeganAdventure(address,uint256)"(
      from?: PromiseOrValue<string> | null,
      tokenId?: null
    ): BeganAdventureEventFilter;
    BeganAdventure(
      from?: PromiseOrValue<string> | null,
      tokenId?: null
    ): BeganAdventureEventFilter;

    "BeganQuest(address,uint256,uint256,uint256,uint256)"(
      from?: PromiseOrValue<string> | null,
      tokenId?: null,
      skillId?: null,
      level?: null,
      completeAt?: null
    ): BeganQuestEventFilter;
    BeganQuest(
      from?: PromiseOrValue<string> | null,
      tokenId?: null,
      skillId?: null,
      level?: null,
      completeAt?: null
    ): BeganQuestEventFilter;

    "CancelledQuest(address,uint256,uint256)"(
      from?: PromiseOrValue<string> | null,
      tokenId?: null,
      skillId?: null
    ): CancelledQuestEventFilter;
    CancelledQuest(
      from?: PromiseOrValue<string> | null,
      tokenId?: null,
      skillId?: null
    ): CancelledQuestEventFilter;

    "FinishedAdventure(address,uint256)"(
      from?: PromiseOrValue<string> | null,
      tokenId?: null
    ): FinishedAdventureEventFilter;
    FinishedAdventure(
      from?: PromiseOrValue<string> | null,
      tokenId?: null
    ): FinishedAdventureEventFilter;

    "FinishedQuest(address,uint256,uint256,uint256)"(
      from?: PromiseOrValue<string> | null,
      tokenId?: null,
      skillId?: null,
      level?: null
    ): FinishedQuestEventFilter;
    FinishedQuest(
      from?: PromiseOrValue<string> | null,
      tokenId?: null,
      skillId?: null,
      level?: null
    ): FinishedQuestEventFilter;

    "UnlockedAdventures(address,uint256)"(
      from?: PromiseOrValue<string> | null,
      tokenId?: null
    ): UnlockedAdventuresEventFilter;
    UnlockedAdventures(
      from?: PromiseOrValue<string> | null,
      tokenId?: null
    ): UnlockedAdventuresEventFilter;
  };

  estimateGas: {};

  populateTransaction: {};
}
