import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/asset_withdrawal_fee_model.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';

part 'currency_model.freezed.dart';
part 'currency_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    String? prefixSymbol,
    RecurringBuysModel? recurringBuy,
    @Default('unknown') String symbol,
    @Default('unknown') String description,
    @Default(0) int accuracy,
    @Default(0) int normalizedAccuracy,
    @Default(TagType.none) TagType tagType,
    @Default(AssetType.crypto) AssetType type,
    @Default(AssetFeesModel()) AssetFeesModel fees,
    @Default([]) List<BuyMethodDto> buyMethods,
    @Default([]) List<ReceiveMethodDto> depositMethods,
    @Default([]) List<SendMethodDto> withdrawalMethods,
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
    @DecimalNullSerialiser() Decimal? minTradeAmount,
    @DecimalNullSerialiser() Decimal? maxTradeAmount,
    @Default(false) bool walletIsActive,
    int? walletOrder,
  }) = _CurrencyModel;
  factory CurrencyModel.fromJson(Map<String, dynamic> json) => _$CurrencyModelFromJson(json);

  const CurrencyModel._();

  factory CurrencyModel.empty() => CurrencyModel(
        assetBalance: Decimal.zero,
        baseBalance: Decimal.zero,
        currentPrice: Decimal.zero,
        dayPriceChange: Decimal.zero,
        assetTotalEarnAmount: Decimal.zero,
        baseTotalEarnAmount: Decimal.zero,
        assetCurrentEarnAmount: Decimal.zero,
        cardReserve: Decimal.zero,
        baseCurrentEarnAmount: Decimal.zero,
        apy: Decimal.zero,
        apr: Decimal.zero,
        depositInProcess: Decimal.zero,
        earnInProcessTotal: Decimal.zero,
        buysInProcessTotal: Decimal.zero,
        transfersInProcessTotal: Decimal.zero,
        earnInProcessCount: 0,
        buysInProcessCount: 0,
        transfersInProcessCount: 0,
      );

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
          (transfersInProcessTotal == Decimal.zero && earnInProcessTotal == Decimal.zero) ||
      transfersInProcessTotal != Decimal.zero &&
          (buysInProcessTotal == Decimal.zero && earnInProcessTotal == Decimal.zero) ||
      earnInProcessTotal != Decimal.zero &&
          (buysInProcessTotal == Decimal.zero && transfersInProcessTotal == Decimal.zero);

  Decimal get totalAmountInProcess => transfersInProcessTotal + earnInProcessTotal + buysInProcessTotal;

  bool get isAssetBalanceEmpty => assetBalance == Decimal.zero;

  bool get isAssetBalanceNotEmpty => assetBalance != Decimal.zero;

  Decimal withdrawalFeeSize(String network) {
    var feeCollection = assetWithdrawalFees;
    var newFeeCollection = assetWithdrawalFees;
    var feeBlockchainCollection = withdrawalBlockchains;
    feeCollection = feeCollection.where((element) {
      if (network == '') {
        return element.network == '' || element.network == null;
      }

      return element.network == network;
    }).toList();
    if (feeCollection.isEmpty) {
      feeBlockchainCollection = feeBlockchainCollection
          .where(
            (element) => element.description == network,
          )
          .toList();
      if (feeBlockchainCollection.isNotEmpty) {
        newFeeCollection = newFeeCollection
            .where(
              (element) => element.network == feeBlockchainCollection[0].id,
            )
            .toList();
      }
    }

    return feeCollection.isNotEmpty
        ? feeCollection[0].size
        : newFeeCollection.isNotEmpty
            ? newFeeCollection[0].size
            : Decimal.zero;
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
      accuracy: baseCurrency.accuracy,
      symbol: baseCurrency.symbol,
    );
  }

  String get volumeAssetBalance {
    return assetBalance.toVolumeFormat(
      accuracy: accuracy,
      symbol: symbol,
    );
  }

  bool get supportsAtLeastOneBuyMethod {
    return buyMethods.isNotEmpty;
  }

  bool get supportsCircle {
    for (final method in buyMethods) {
      if (method.id == PaymentMethodType.circleCard) {
        return true;
      }
    }

    return false;
  }

  bool get supportsAtLeastOneFiatDepositMethod {
    return supportsCardDeposit || supportsSepaDeposit || supportsSwiftDeposit;
  }

  bool get supportsCryptoDeposit {
    if (type == AssetType.fiat) {
      return depositMethods.where((element) => element.id == DepositMethods.ibanReceive).isNotEmpty;
    }

    return depositMethods.where((element) => element.id == DepositMethods.cryptoDeposit).isNotEmpty ||
        depositMethods.where((element) => element.id == DepositMethods.blockchainReceive).isNotEmpty;
  }

  bool get supportsGlobalSend {
    return withdrawalMethods.where((element) => element.id == WithdrawalMethods.globalSend).isNotEmpty;
  }

  bool get supportsGiftlSend {
    return withdrawalMethods.where((element) => element.id == WithdrawalMethods.internalSend).isNotEmpty;
  }

  bool get supportsIbanDeposit {
    return depositMethods.where((element) => element.id == DepositMethods.ibanReceive).isNotEmpty;
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
    return supportIbanSendWithdrawal ||
        supporGlobalSendWithdrawal ||
        supportsSepaWithdrawal ||
        supportsSwiftWithdrawal ||
        supportsCryptoWithdrawal;
  }

  bool get isSupportAnyWithdrawal {
    return withdrawalMethods.isNotEmpty;
  }

  bool get supportsCryptoWithdrawal {
    if (type == AssetType.fiat) {
      return false;
    }

    return withdrawalMethods
            .where(
              (element) => element.id == WithdrawalMethods.cryptoWithdrawal,
            )
            .isNotEmpty ||
        withdrawalMethods.where((element) => element.id == WithdrawalMethods.blockchainSend).isNotEmpty;
  }

  bool get supportsByAssetWithdrawal {
    return withdrawalMethods
            .where(
              (element) => element.id == WithdrawalMethods.cryptoWithdrawal,
            )
            .isNotEmpty ||
        withdrawalMethods.where((element) => element.id == WithdrawalMethods.blockchainSend).isNotEmpty;
  }

  bool get supportsByPhoneNicknameWithdrawal {
    return withdrawalMethods.where((element) => element.id == WithdrawalMethods.internalSend).isNotEmpty;
  }

  bool get supportsSepaWithdrawal {
    return withdrawalMethods.contains(WithdrawalMethods.sepaWithdrawal);
  }

  bool get supportsSwiftWithdrawal {
    return withdrawalMethods.contains(WithdrawalMethods.swiftWithdrawal);
  }

  bool get supportIbanSendWithdrawal {
    return withdrawalMethods.where((element) => element.id == WithdrawalMethods.ibanSend).isNotEmpty;
  }

  bool get supporGlobalSendWithdrawal {
    return withdrawalMethods.where((element) => element.id == WithdrawalMethods.globalSend).isNotEmpty;
  }

  bool get isSingleNetwork => depositBlockchains.length == 1;

  List<BlockchainModel> get networksForBlockchainSend {
    final sendMethods = sSignalRModules.sendMethods;
    final blockchainSendMethod = sendMethods.firstWhere(
      (element) => element.id == WithdrawalMethods.blockchainSend,
    );
    final thisSymbolNetworkDetails = blockchainSendMethod.symbolNetworkDetails?.where(
          (element) => element.symbol == symbol,
        ) ??
        [];
    final result = depositBlockchains
        .where(
          (element) => thisSymbolNetworkDetails.any(
            (symbolNetworkDetails) => symbolNetworkDetails.network == element.id,
          ),
        )
        .toList();

    return result;
  }

  bool get isSingleNetworkForBlockchainSend => networksForBlockchainSend.length == 1;
}

class ObservableCurrencyModelListConverter implements JsonConverter<ObservableList<CurrencyModel>, List<dynamic>> {
  const ObservableCurrencyModelListConverter();

  @override
  ObservableList<CurrencyModel> fromJson(List<dynamic> json) => ObservableList.of(
        json.cast<Map<String, dynamic>>().map(CurrencyModel.fromJson),
      );

  @override
  List<Map<String, dynamic>> toJson(ObservableList<CurrencyModel> list) => list.map((e) => e.toJson()).toList();
}
