import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_withdrawal_fee_model.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';

part 'currency_model.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    String? prefixSymbol,
    RecurringBuysModel? recurringBuy,
    @Default('unknown') String symbol,
    @Default('unknown') String description,
    @Default(0) int accuracy,
    @Default(0) int depositMode,
    @Default(0) int withdrawalMode,
    @Default(TagType.none) TagType tagType,
    @Default(AssetType.crypto) AssetType type,
    @Default(AssetFeesModel()) AssetFeesModel fees,
    @Default([]) List<PaymentMethod> buyMethods,
    @Default([]) List<DepositMethods> depositMethods,
    @Default([]) List<WithdrawalMethods> withdrawalMethods,
    @Default([]) List<BlockchainModel> depositBlockchains,
    @Default([]) List<BlockchainModel> withdrawalBlockchains,
    @Default([]) List<AssetFeeModel> assetWithdrawalFees,
    @Default(0.0) double reserve,
    @Default('unknown') String lastUpdate,
    @Default(0.0) double sequenceId,
    @Default('') String iconUrl,
    @Default('') String selectedIndexIconUrl,
    @Default('') String nextPaymentDate,
    @Default(0.0) double dayPercentChange,
    @Default(0) int weight,
    required Decimal cardReserve,
    required Decimal assetBalance,
    required Decimal baseBalance,
    required Decimal currentPrice,
    required Decimal dayPriceChange,
    required Decimal assetTotalEarnAmount,
    required Decimal baseTotalEarnAmount,
    required Decimal assetCurrentEarnAmount,
    required Decimal baseCurrentEarnAmount,
    required Decimal apy,
    required Decimal apr,
    required Decimal depositInProcess,
    required Decimal buysInProcessTotal,
    required Decimal transfersInProcessTotal,
    required Decimal earnInProcessTotal,
    required int buysInProcessCount,
    required int transfersInProcessCount,
    required int earnInProcessCount,
    @Default(false) bool earnProgramEnabled,
  }) = _CurrencyModel;

  const CurrencyModel._();

  bool get isDepositMode => depositMode == 0;

  bool get isWithdrawalMode => withdrawalMode == 0;

  bool get noPendingDeposit =>
      buysInProcessTotal == Decimal.zero &&
      transfersInProcessTotal == Decimal.zero &&
      earnInProcessTotal == Decimal.zero;

  bool get isPendingDeposit =>
      buysInProcessTotal != Decimal.zero ||
      transfersInProcessTotal != Decimal.zero ||
      earnInProcessTotal != Decimal.zero;

  bool get isSingleTypeInProgress =>
      buysInProcessTotal != Decimal.zero &&
          (transfersInProcessTotal == Decimal.zero &&
              earnInProcessTotal == Decimal.zero) ||
      transfersInProcessTotal != Decimal.zero &&
          (buysInProcessTotal == Decimal.zero &&
              earnInProcessTotal == Decimal.zero) ||
      earnInProcessTotal != Decimal.zero &&
          (buysInProcessTotal == Decimal.zero &&
              transfersInProcessTotal == Decimal.zero);

  Decimal get totalAmountInProcess =>
      transfersInProcessTotal + earnInProcessTotal + buysInProcessTotal;

  bool get isAssetBalanceEmpty => assetBalance == Decimal.zero;

  bool get isAssetBalanceNotEmpty => assetBalance != Decimal.zero;

  Decimal withdrawalFeeSize(String network) {
    var feeCollection = assetWithdrawalFees;
    feeCollection =
        feeCollection.where((element) => element.network == network).toList();

    return feeCollection.isNotEmpty ? feeCollection[0].size : Decimal.zero;
  }

  bool get isGrowing => dayPercentChange > 0;

  String withdrawalFeeWithSymbol(String network) {
    return '${withdrawalFeeSize(network)} $symbol';
  }

  String get emptyWithdrawalFee => '0 $symbol';

  bool get isFeeInOtherCurrency => symbol != fees.withdrawalFee?.assetSymbol;

  bool get hasTag => tagType != TagType.none;

  String volumeBaseBalance(BaseCurrencyModel baseCurrency) {
    return baseBalance.toVolumeFormat(
      prefix: baseCurrency.prefix,
      accuracy: baseCurrency.accuracy,
      symbol: baseCurrency.symbol,
    );
  }

  String get volumeAssetBalance {
    return assetBalance.toVolumeFormat(
      prefix: prefixSymbol,
      accuracy: accuracy,
      symbol: symbol,
    );
  }

  bool get supportsAtLeastOneBuyMethod {
    return buyMethods.isNotEmpty;
  }

  bool get supportsCircle {
    for (final method in buyMethods) {
      if (method.type == PaymentMethodType.circleCard) {
        return true;
      }
    }

    return false;
  }

  bool get supportsAtLeastOneFiatDepositMethod {
    return supportsCardDeposit || supportsSepaDeposit || supportsSwiftDeposit;
  }

  bool get supportsCryptoDeposit {
    return depositMethods.contains(DepositMethods.cryptoDeposit);
  }

  bool get supportsCardDeposit {
    return depositMethods.contains(DepositMethods.cardDeposit);
  }

  bool get supportsSepaDeposit {
    return depositMethods.contains(DepositMethods.sepaDeposit);
  }

  bool get supportsSwiftDeposit {
    return depositMethods.contains(DepositMethods.swiftDeposit);
  }

  bool get supportsAtLeastOneWithdrawalMethod {
    return supportsCryptoWithdrawal ||
        supportsSepaWithdrawal ||
        supportsSwiftWithdrawal;
  }

  bool get supportsCryptoWithdrawal {
    return withdrawalMethods.contains(WithdrawalMethods.cryptoWithdrawal);
  }

  bool get supportsSepaWithdrawal {
    return withdrawalMethods.contains(WithdrawalMethods.sepaWithdrawal);
  }

  bool get supportsSwiftWithdrawal {
    return withdrawalMethods.contains(WithdrawalMethods.swiftWithdrawal);
  }

  bool get isSingleNetwork => depositBlockchains.length == 1;
}
