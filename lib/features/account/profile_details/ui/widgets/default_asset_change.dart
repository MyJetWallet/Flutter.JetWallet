import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../market/market_details/helper/currency_from_all.dart';
import '../../store/change_base_asset_store.dart';

@RoutePage(name: 'DefaultAssetChangeRouter')
class DefaultAssetChange extends StatelessObserverWidget {
  const DefaultAssetChange({super.key});

  @override
  Widget build(BuildContext context) {
    final baseAsset = getIt.get<ChangeBaseAssetStore>();
    final currencies = sSignalRModules.currenciesWithHiddenList;
    final iterableAssets = <CurrencyModel>[];
    final colors = sKit.colors;

    for (final asset in baseAsset.assetsList) {
      final currencyByAsset = currencyFromAll(currencies, asset);
      iterableAssets.add(currencyByAsset);
    }

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.profileDetails_baseCurrency,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: [
          for (final asset in iterableAssets) ...[
            InkWell(
              onTap: () {
                baseAsset.changeBaseAsset(asset.symbol);
              },
              splashColor: Colors.transparent,
              highlightColor: colors.grey5,
              hoverColor: Colors.transparent,
              child: SPaddingH24(
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 64,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 20,
                        ),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              width: 2,
                              color: asset.symbol != baseAsset.checkedAsset
                                  ? colors.black
                                  : colors.blue,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                asset.prefixSymbol ?? '?',
                                style: sCaptionTextStyle.copyWith(
                                  color: asset.symbol != baseAsset.checkedAsset
                                      ? colors.black
                                      : colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            asset.description,
                            style: sSubtitle2Style.copyWith(
                              color: asset.symbol != baseAsset.checkedAsset
                                  ? colors.black
                                  : colors.blue,
                            ),
                          ),
                          const SpaceH4(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (asset != iterableAssets.last)
              const SPaddingH24(child: SDivider()),
          ],
        ],
      ),
    );
  }
}
