import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';

part 'currencies_with_hidden_service.g.dart';

final sCurrenciesWithHidden = getIt.get<CurrenciesWithHidden>();

class CurrenciesWithHidden = _CurrenciesWithHiddenBase
    with _$CurrenciesWithHidden;

abstract class _CurrenciesWithHiddenBase with Store {

  @action
  void init() {
    sSignalRModules.assets.listen(
      (value) {
        print('CurrenciesWithHiddenService');

        for (final asset in value.assets) {
          final depositBlockchains = <BlockchainModel>[];
          final withdrawalBlockchains = <BlockchainModel>[];

          for (final blockchain in asset.depositBlockchains) {
            depositBlockchains.add(
              BlockchainModel(
                id: blockchain,
              ),
            );
          }

          for (final blockchain in asset.withdrawalBlockchains) {
            withdrawalBlockchains.add(
              BlockchainModel(
                id: blockchain,
              ),
            );
          }

          currencies.add(
            CurrencyModel(
              symbol: asset.symbol,
              description: asset.description,
              accuracy: asset.accuracy.toInt(),
              depositMode: asset.depositMode,
              withdrawalMode: asset.withdrawalMode,
              tagType: asset.tagType,
              type: asset.type,
              depositMethods: asset.depositMethods,
              fees: asset.fees,
              withdrawalMethods: asset.withdrawalMethods,
              depositBlockchains: depositBlockchains,
              withdrawalBlockchains: withdrawalBlockchains,
              iconUrl: iconUrlFrom(assetSymbol: asset.symbol),
              selectedIndexIconUrl: iconUrlFrom(
                assetSymbol: asset.symbol,
                selected: true,
              ),
              prefixSymbol: asset.prefixSymbol,
              apy: Decimal.zero,
              apr: Decimal.zero,
              assetBalance: Decimal.zero,
              assetCurrentEarnAmount: Decimal.zero,
              assetTotalEarnAmount: Decimal.zero,
              cardReserve: Decimal.zero,
              baseBalance: Decimal.zero,
              baseCurrentEarnAmount: Decimal.zero,
              baseTotalEarnAmount: Decimal.zero,
              currentPrice: Decimal.zero,
              dayPriceChange: Decimal.zero,
              earnProgramEnabled: asset.earnProgramEnabled,
              depositInProcess: Decimal.zero,
              earnInProcessTotal: Decimal.zero,
              buysInProcessTotal: Decimal.zero,
              transfersInProcessTotal: Decimal.zero,
              earnInProcessCount: 0,
              buysInProcessCount: 0,
              transfersInProcessCount: 0,
            ),
          );
        }
      },
    );
  }

  @observable
  ObservableList<CurrencyModel> currencies = ObservableList.of([]);
}
