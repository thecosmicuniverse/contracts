import { ActionFn, Context, Event, TransactionEvent } from "@tenderly/actions";
import { BigNumber, ethers } from "ethers";
import { BobaTeleportL1__factory, BobaTeleportL2__factory } from "./types";

const BOBA_TELEPORT_L1_ADDRESS = "0xb8cdEf330A2530229D107140188Be909A506B503";
const BOBA_TELEPORT_L2_ADDRESS = "0x5581b3831DBAA9a60BC6f7CD9a1d917eFe57C190";

const PointOneEther = ethers.utils.parseUnits("0.1", "ether");

export const teleport: ActionFn = async (context: Context, event: Event) => {
  const transactionEvent = event as TransactionEvent;

  let wallet: string = "";
  const addresses: string[] = [];
  const ids: BigNumber[] = [];
  const amounts: BigNumber[] = [];
  const { tcAvax, tcBoba } = await teleportContracts(context);

  const teleportedTopic = tcBoba.interface.getEventTopic("AssetTeleported");
  const teleportedLogs = transactionEvent.logs.filter(log =>
    log.topics.find(topic => topic === teleportedTopic) !== undefined
  );

  for (const log of teleportedLogs) {
    const { data, topics } = log;
    const result = tcBoba.interface.decodeEventLog("AssetTeleported", data, topics);
    if (result.length !== 4) {
      console.log("Error decoding event log:", result);
      return;
    }
    const [fromWallet, address, id, amount] = result;
    wallet = fromWallet;
    addresses.push(address);
    ids.push(id);
    amounts.push(amount);
  }
  console.log(`Teleporting ${ addresses.length } assets for ${ wallet }`);
  const baseFee = await tcAvax.estimateGas.addTeleportedAssets(wallet, addresses, ids, amounts, BigNumber.from(1));
  console.log("Estimated base fee:", baseFee.toString());
  const gasPrice = await tcAvax.provider.getGasPrice();
  console.log("Gas price:", ethers.utils.formatUnits(gasPrice, "gwei"));
  const estimatedFee = baseFee.mul(gasPrice).mul(2);
  const fee = estimatedFee.lt(PointOneEther) ? PointOneEther : estimatedFee
  console.log("Total Fee:", ethers.utils.formatUnits(fee, "ether"));

  const tx = await tcAvax.addTeleportedAssets(wallet, addresses, ids, amounts, fee);
  await tx.wait();
  console.log(`Added ${ addresses.length } assets to teleport contract for ${ wallet }`);
};

const teleportContracts = async (context: Context) => {
  const avaxProvider = new ethers.providers.JsonRpcProvider("https://api.avax.network/ext/bc/C/rpc", 43_114);
  const bobaProvider = new ethers.providers.JsonRpcProvider("https://avax.boba.network", 43_288);
  const pk = await context.secrets.get("teleport.addressPrivateKey");
  const avaxWallet = new ethers.Wallet(pk, avaxProvider);
  return {
    tcBoba: BobaTeleportL2__factory.connect(BOBA_TELEPORT_L2_ADDRESS, bobaProvider),
    tcAvax: BobaTeleportL1__factory.connect(BOBA_TELEPORT_L1_ADDRESS, avaxWallet)
  }
};
