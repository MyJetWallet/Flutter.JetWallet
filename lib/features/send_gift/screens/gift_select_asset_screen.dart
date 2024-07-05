import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/send_gift/model/send_gift_info_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/models/currency_model.dart';
import '../../app/store/app_store.dart';

@RoutePage(name: 'GiftSelectAssetRouter')
class GiftSelectAssetScreen extends StatefulObserverWidget {
  const GiftSelectAssetScreen({super.key});

  @override
  State<GiftSelectAssetScreen> createState() => _GiftSelectAssetScreenState();
}

class _GiftSelectAssetScreenState extends State<GiftSelectAssetScreen> {
  String? lastCurrency;

  @override
  void initState() {
    sAnalytics.sendingAssetScreenView();
    super.initState();
    final storageService = getIt.get<LocalStorageService>();
    textController = TextEditingController();
    storageService.getValue(lastAssetSend).then(
      (value) {
        setState(() {
          lastCurrency = value;
        });
      },
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  late TextEditingController textController;

  final ObservableList<CurrencyModel> isGiftSendActive = sSignalRModules.currenciesList;

  final baseCurrency = sSignalRModules.baseCurrency;

  @override
  Widget build(BuildContext context) {
    final sortedAssets = isGiftSendActive
        .where(
          (element) => element.supportsGiftlSend && element.isAssetBalanceNotEmpty,
        )
        .toList();

    sortedAssets.sort((a, b) {
      if (lastCurrency != null) {
        if (a.symbol == lastCurrency) {
          return 0.compareTo(1);
        } else if (b.symbol == lastCurrency) {
          return 1.compareTo(0);
        }
      }

      return b.baseBalance.compareTo(a.baseBalance);
    });

    getIt.get<ActionSearchStore>().initConvert(
          sortedAssets,
          sortedAssets,
        );
    final searchStore = getIt.get<ActionSearchStore>();

    return SPageFrame(
      loaderText: intl.loader_please_wait,
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
                if (sortedAssets.length > 7) ...[
                  SPaddingH24(
                    child: SStandardField(
                      controller: textController,
                      labelText: intl.actionBottomSheetHeader_search,
                      onChanged: (String value) {
                        searchStore.searchConvert(
                          value,
                          sortedAssets,
                          sortedAssets,
                        );
                      },
                      maxLines: 1,
                    ),
                  ),
                  const SDivider(),
                ],
                Observer(
                  builder: (_) {
                    return Column(
                      children: [
                        for (final currency in searchStore.convertCurrenciesWithBalance)
                          SWalletItem(
                            decline: currency.dayPercentChange.isNegative,
                            icon: SNetworkSvg24(
                              url: currency.iconUrl,
                            ),
                            primaryText: currency.description,
                            amount: getIt<AppStore>().isBalanceHide
                                ? '**** ${baseCurrency.symbol}'
                                : currency.volumeBaseBalance(baseCurrency),
                            secondaryText: getIt<AppStore>().isBalanceHide
                                ? '******* ${currency.symbol}'
                                : currency.volumeAssetBalance,
                            removeDivider: currency == searchStore.convertCurrenciesWithBalance.last ||
                                searchStore.convertCurrenciesWithBalance.length == 1,
                            onTap: () {
                              final sendGiftInfo = SendGiftInfoModel(currency: currency);
                              sRouter.push(
                                GiftReceiversDetailsRouter(
                                  sendGiftInfo: sendGiftInfo,
                                ),
                              );
                            },
                            hideBalance: getIt<AppStore>().isBalanceHide,
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
