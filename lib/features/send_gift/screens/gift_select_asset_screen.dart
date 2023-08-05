import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/models/currency_model.dart';

@RoutePage(name: 'GiftSelectAssetRouter')
class GiftSelectAssetScreen extends StatelessObserverWidget {
  GiftSelectAssetScreen({super.key});

  final ObservableList<CurrencyModel> isGiftSendActive =
      sSignalRModules.currenciesList
        ..sort(
          (a, b) {
            return b.baseBalance.compareTo(a.baseBalance);
          },
        );

  final baseCurrency = sSignalRModules.baseCurrency;

  @override
  Widget build(BuildContext context) {
    getIt.get<ActionSearchStore>().initConvert(
          isGiftSendActive
              .where((element) => element.isAssetBalanceNotEmpty)
              .toList(),
          isGiftSendActive
              .where((element) => element.isAssetBalanceEmpty)
              .toList(),
        );
    final searchStore = getIt.get<ActionSearchStore>();

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.send_gift_sending_asset,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (isGiftSendActive
                        .where(
                          (element) =>
                              element.supportsGiftlSend &&
                              element.isAssetBalanceNotEmpty,
                        )
                        .length >
                    7) ...[
                  SPaddingH24(
                    child: SStandardField(
                      controller: TextEditingController(),
                      labelText: intl.actionBottomSheetHeader_search,
                      onChanged: (String value) {
                        searchStore.searchConvert(
                          value,
                          isGiftSendActive,
                          isGiftSendActive,
                        );
                      },
                    ),
                  ),
                  const SDivider(),
                ],
                Observer(
                  builder: (_) {
                    return Column(
                      children: [
                        for (final currency
                            in searchStore.convertCurrenciesWithBalance.where(
                          (element) =>
                              element.supportsGiftlSend &&
                              element.isAssetBalanceNotEmpty,
                        ))
                          SWalletItem(
                            decline: currency.dayPercentChange.isNegative,
                            icon: SNetworkSvg24(
                              url: currency.iconUrl,
                            ),
                            primaryText: currency.description,
                            amount: currency.volumeBaseBalance(baseCurrency),
                            secondaryText: currency.volumeAssetBalance,
                            removeDivider: currency ==
                                    searchStore.convertCurrenciesWithBalance
                                        .where(
                                          (element) =>
                                              element.supportsGiftlSend &&
                                              element.isAssetBalanceNotEmpty,
                                        )
                                        .last ||
                                searchStore.convertCurrenciesWithBalance
                                        .where(
                                          (element) =>
                                              element.supportsGiftlSend &&
                                              element.isAssetBalanceNotEmpty,
                                        )
                                        .length ==
                                    1,
                            onTap: () {
                              sRouter.push(
                                GiftReceiversDetailsRouter(currency: currency),
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
