import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

String operationName(
  OperationType type,
  BuildContext context, {
  bool? isToppedUp,
  String? asset,
  required TransactionItemSource source,
}) {
  switch (type) {
    case OperationType.deposit:
      return intl.operationName_received;
    case OperationType.ibanDeposit:
      return '${intl.operationName_received} $asset';
    case OperationType.withdraw:
      return intl.operationName_sent;
    case OperationType.transferByPhone:
      return intl.operationName_transferByPhone;
    case OperationType.receiveByPhone:
      return intl.operationName_receiveByPhone;
    case OperationType.swapBuy:
      return intl.operationName_buy;
    case OperationType.swapSell:
      return intl.operationName_sell;
    case OperationType.paidInterestRate:
      return intl.operationName_interestRate;
    case OperationType.feeSharePayment:
      return intl.operationName_feeSharePayment;
    case OperationType.withdrawalFee:
      return intl.operationName_withdrawalFee;
    case OperationType.rewardPayment:
      return intl.operationName_rewardReferral;
    case OperationType.simplexBuy:
      return intl.operationName_simplex;
    case OperationType.recurringBuy:
      return intl.account_recurringBuy;
    case OperationType.earningDeposit:
      return isToppedUp != null ? intl.operationName_topped_up : intl.operationName_subscribed_to_earn;
    case OperationType.cryptoBuy:
      return intl.operationName_bought;
    case OperationType.p2pBuy:
      return intl.operationName_bought;
    case OperationType.buyGooglePay:
      return intl.operationName_buyGooglePay;
    case OperationType.buyApplePay:
      return intl.operationName_buyApplePay;
    case OperationType.earningWithdrawal:
      return intl.operationName_return_from_earn;
    case OperationType.unknown:
      return 'Unknown';
    case OperationType.ibanSend:
      return intl.withdrawal_withdrawn;
    case OperationType.sendGlobally:
      return intl.history_sent_globally;
    case OperationType.giftSend:
      return intl.history_sent_gift;
    case OperationType.giftReceive:
      return intl.history_received_gift;
    case OperationType.bankingBuy:
      return intl.operationName_bought;
    case OperationType.bankingSell:
    case OperationType.cardBankingSell:
      return intl.operationName_sold;
    case OperationType.swap:
      return intl.operationName_converted;
    case OperationType.bankingAccountWithdrawal:
      return intl.history_withdrawn;
    case OperationType.bankingAccountDeposit:
      return intl.history_added_cash;
    case OperationType.cardPurchase:
      return intl.operationName_purchase;
    case OperationType.cardRefund:
      return intl.operationName_refund;
    case OperationType.cardWithdrawal:
      return intl.operationName_cash_withdrawal;
    case OperationType.earnSend:
      return intl.earn_sent;
    case OperationType.earnReserve:
      return intl.earn_received;
    case OperationType.buyPrepaidCard:
      return intl.prepaid_card_buy_voucher;
    case OperationType.jarDeposit:
      return intl.operationName_received;
    case OperationType.jarWithdrawal:
      return intl.operationName_sent;
    case OperationType.bankingSellWithWithdrawal:
      return intl.history_withdrawn;
    case OperationType.cryptoCardDeposit:
      return source != TransactionItemSource.cryptoCard
          ? intl.crypto_card_history_deposit
          : intl.crypto_card_history_details;
    case OperationType.cryptoCardPurchase:
      return source != TransactionItemSource.cryptoCard
          ? intl.crypto_card_history_card_purchase
          : intl.crypto_card_history_details;
    case OperationType.cryptoCardRefund:
      return source != TransactionItemSource.cryptoCard
          ? intl.crypto_card_history_refund
          : intl.crypto_card_history_details;
    case OperationType.cryptoCardOrder:
      return source != TransactionItemSource.cryptoCard
          ? intl.crypto_card_history_card_issue
          : intl.crypto_card_history_details;
    default:
      return 'Unknown';
  }
}
