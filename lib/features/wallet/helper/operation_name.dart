import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

String operationName(
  OperationType type,
  BuildContext context, {
  bool? isToppedUp,
  String? asset,
}) {
  switch (type) {
    case OperationType.deposit:
      return '${intl.operationName_deposit} $asset';
    case OperationType.ibanDeposit:
      return '${intl.operationName_deposit} $asset';
    case OperationType.withdraw:
      return '${intl.operationName_withdrawal} $asset';
    case OperationType.transferByPhone:
      return intl.operationName_transferByPhone;
    case OperationType.receiveByPhone:
      return intl.operationName_receiveByPhone;
    case OperationType.buy:
      return intl.operationName_buy;
    case OperationType.sell:
      return intl.operationName_sell;
    case OperationType.paidInterestRate:
      return intl.operationName_interestRate;
    case OperationType.feeSharePayment:
      return intl.operationName_feeSharePayment;
    case OperationType.swap:
      return intl.operationName_exchange;
    case OperationType.withdrawalFee:
      return intl.operationName_withdrawalFee;
    case OperationType.rewardPayment:
      return intl.operationName_rewardReferral;
    case OperationType.simplexBuy:
      return intl.operationName_simplex;
    case OperationType.recurringBuy:
      return intl.account_recurringBuy;
    case OperationType.earningDeposit:
      return isToppedUp != null
          ? intl.operationName_topped_up
          : intl.operationName_subscribed_to_earn;
    case OperationType.cryptoInfo:
      return intl.operationName_buyWithCard;
    case OperationType.buyGooglePay:
      return intl.operationName_buyGooglePay;
    case OperationType.buyApplePay:
      return intl.operationName_buyApplePay;
    case OperationType.earningWithdrawal:
      return intl.operationName_return_from_earn;
    case OperationType.unknown:
      return 'Unknown';
    case OperationType.nftSwap:
      return intl.operationName_buyNFT;
    case OperationType.nftBuyOpposite:
      return intl.operationName_buyNFT;
    case OperationType.nftSell:
      return intl.operationName_sellNFT;
    case OperationType.nftSellOpposite:
      return intl.operationName_sellNFT;
    case OperationType.nftDeposit:
      return intl.operationName_receiveNFT;
    case OperationType.nftWithdrawal:
      return intl.operationName_sendNFT;
    case OperationType.nftWithdrawalFee:
      return intl.operationName_sendNFT;
    case OperationType.nftBuy:
      return intl.operationName_buyNFT;
    case OperationType.sendGlobally:
      return intl.send_globally;
    default:
      return 'Unknown';
  }
}
