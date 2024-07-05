import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

import 'nft_types.dart';

NftMarket getNftItem(
  OperationHistoryItem transactionListItem,
  List<NftMarket> nftList,
) {
  if (nftAllTypes.contains(transactionListItem.operationType)) {
    final checkId = (transactionListItem.operationType == OperationType.nftBuyOpposite ||
            transactionListItem.operationType == OperationType.nftBuy ||
            transactionListItem.operationType == OperationType.nftSwap)
        ? transactionListItem.swapInfo?.buyAssetId
        : (transactionListItem.operationType == OperationType.nftSellOpposite ||
                transactionListItem.operationType == OperationType.nftSell)
            ? transactionListItem.swapInfo?.sellAssetId
            : (transactionListItem.operationType == OperationType.nftWithdrawal ||
                    transactionListItem.operationType == OperationType.nftWithdrawalFee)
                ? transactionListItem.withdrawalInfo?.withdrawalAssetId
                : transactionListItem.operationType == OperationType.nftDeposit
                    ? transactionListItem.assetId
                    : '';
    final assetsList = nftList
        .where(
          (element) => element.symbol == checkId,
        )
        .toList();
    if (assetsList.isNotEmpty) {
      return assetsList[0];
    }
  }

  return NftMarket(
    name: 'NFT',
  );
}
