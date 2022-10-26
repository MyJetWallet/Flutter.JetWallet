import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

List<OperationType> nftTypes = [
  OperationType.nftBuy,
  OperationType.nftDeposit,
  OperationType.nftRelease,
  OperationType.nftReserve,
  OperationType.nftSell,
  OperationType.nftSwap,
  OperationType.nftWithdrawal,
];

List<OperationType> nftAllTypes = [
  OperationType.nftBuy,
  OperationType.nftBuyOpposite,
  OperationType.nftDeposit,
  OperationType.nftRelease,
  OperationType.nftReserve,
  OperationType.nftSell,
  OperationType.nftSellOpposite,
  OperationType.nftSwap,
  OperationType.nftWithdrawal,
];

enum TransactionType {
  none,
  crypto,
  nft,
}
