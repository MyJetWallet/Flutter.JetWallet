import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

String? isTXIDExist(OperationHistoryItem transactionListItem) {
  if (transactionListItem.operationType == OperationType.withdraw ||
      transactionListItem.operationType == OperationType.jarWithdrawal) {
    if (!transactionListItem.withdrawalInfo!.isInternal) {
      if (transactionListItem.withdrawalInfo?.txId != null && transactionListItem.withdrawalInfo!.txId!.isNotEmpty) {
        return transactionListItem.withdrawalInfo!.txId;
      }
    }
  } else if (transactionListItem.operationType == OperationType.deposit ||
      transactionListItem.operationType == OperationType.jarDeposit) {
    if (transactionListItem.depositInfo?.txId != null && transactionListItem.depositInfo!.txId!.isNotEmpty) {
      return transactionListItem.depositInfo!.txId;
    }
  }

  return null;
}

String? getNetworkFromItem(OperationHistoryItem transactionListItem) {
  if (transactionListItem.operationType == OperationType.withdraw ||
      transactionListItem.operationType == OperationType.jarWithdrawal) {
    if (!transactionListItem.withdrawalInfo!.isInternal) {
      if (transactionListItem.withdrawalInfo?.network != null &&
          transactionListItem.withdrawalInfo!.network!.isNotEmpty) {
        return transactionListItem.withdrawalInfo?.network;
      }
    }
  } else if (transactionListItem.operationType == OperationType.deposit ||
      transactionListItem.operationType == OperationType.jarDeposit) {
    if (transactionListItem.depositInfo?.network != null && transactionListItem.depositInfo!.network!.isNotEmpty) {
      return transactionListItem.depositInfo?.network;
    }
  }

  return null;
}

bool checkTransactionIsInternal(OperationHistoryItem transactionListItem) {
  if (transactionListItem.operationType == OperationType.withdraw) {
    return transactionListItem.withdrawalInfo!.isInternal;
  } else if (transactionListItem.operationType == OperationType.deposit) {
    return transactionListItem.depositInfo!.isInternal;
  } else if (transactionListItem.operationType == OperationType.jarDeposit) {
    return transactionListItem.depositInfo!.isInternal;
  } else if (transactionListItem.operationType == OperationType.jarWithdrawal) {
    return transactionListItem.depositInfo!.isInternal;
  }

  return false;
}

bool showBlockchainButton(String network) {
  final block = findBlockchaonByDescription(network);

  return block != null && block.blockchainExplorerUrlTemplate.isNotEmpty;
}

BlockchainModel? findBlockchaonByDescription(String value) {
  final index = sSignalRModules.blockchainsModel!.blockchains.indexWhere((element) => element.description == value);

  return index != -1 ? sSignalRModules.blockchainsModel!.blockchains[index] : null;
}

String getBlockChainURL(OperationHistoryItem transactionListItem) {
  final g = getNetworkFromItem(transactionListItem);

  if (g != null) {
    final block = findBlockchaonByDescription(g);

    if (block == null) return '';

    final id = isTXIDExist(transactionListItem);

    return block.blockchainExplorerUrlTemplate.replaceAll('{txHash}', id!);
  }

  return '';

  //https://goerli.etherscan.io/tx/{txHash}
}
