import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/helpers/show_currency_search.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/light/qr_code/simple_light_qr_code_icon.dart';
import 'package:simple_kit/modules/icons/24x24/light/wallet/simple_light_wallet_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../kyc/helper/kyc_alert_handler.dart';
import '../../kyc/kyc_service.dart';
import '../../kyc/models/kyc_operation_status_model.dart';

void showReceiveAction(
  BuildContext context, {
  bool shouldPop = true,
}) {
  final colors = sKit.colors;
  final kyc = getIt.get<KycService>();
  final handler = getIt.get<KycAlertHandler>();

  sAnalytics.receiveChooseAsset();

  if (shouldPop) Navigator.pop(context);

  final showCrypto = sSignalRModules.clientDetail.isNftEnable;
  if (!showCrypto) {
    showCryptoReceiveAction(context);
  } else {
    sShowBasicModalBottomSheet(
      context: context,
      then: (value) {
        //sAnalytics.receiveChooseAssetClose();
      },
      pinned: ActionBottomSheetHeader(
        name: intl.actionReceive_receive,
        onChanged: (String value) {},
      ),
      horizontalPinnedPadding: 0.0,
      removePinnedPadding: true,
      children: [
        Column(
          children: [
            receiveItem(
              icon: const SizedBox(
                width: 24,
                height: 24,
                child: SimpleLightWalletIcon(),
              ),
              text: intl.actionReceive_receive_crypto,
              subtext: intl.actionReceive_receive_crypto,
              onTap: () {
                showCryptoReceiveAction(context);
              },
            ),
            receiveItem(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: SimpleLightQrCodeIcon(
                  color: colors.blue,
                ),
              ),
              text: intl.actionReceive_receive_nft,
              subtext: intl.actionReceive_receive_nft,
              onTap: () {
                sAnalytics.nftReceiveTap(source: "'S' Menu");
                if (kyc.depositStatus ==
                        kycOperationStatus(KycStatus.allowed) &&
                    kyc.withdrawalStatus ==
                        kycOperationStatus(KycStatus.allowed) &&
                    kyc.sellStatus == kycOperationStatus(KycStatus.allowed)) {
                  sRouter.push(
                    const ReceiveNFTRouter(),
                  );
                } else {
                  handler.handle(
                    status: kyc.depositStatus !=
                            kycOperationStatus(KycStatus.allowed)
                        ? kyc.depositStatus
                        : kyc.withdrawalStatus !=
                                kycOperationStatus(KycStatus.allowed)
                            ? kyc.withdrawalStatus
                            : kyc.sellStatus,
                    isProgress: kyc.verificationInProgress,
                    currentNavigate: () {
                      sRouter.push(
                        const ReceiveNFTRouter(),
                      );
                    },
                    requiredDocuments: kyc.requiredDocuments,
                    requiredVerifications: kyc.requiredVerifications,
                  );
                }
              },
            ),
            const SpaceH40(),
          ],
        ),
      ],
    );
  }
}

Widget receiveItem({
  required Widget icon,
  required String text,
  required String subtext,
  required Function() onTap,
}) {
  final colors = sKit.colors;

  return InkWell(
    highlightColor: colors.grey5,
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 11,
        left: 24,
        right: 24,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: icon,
          ),
          const SpaceW20(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Baseline(
                baseline: 28,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  text,
                  style: sSubtitle2Style,
                ),
              ),
              Baseline(
                baseline: 18,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  subtext,
                  style: sCaptionTextStyle.copyWith(color: colors.grey3),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void showCryptoReceiveAction(BuildContext context) {
  getIt.get<ActionSearchStore>().init();
  final searchStore = getIt.get<ActionSearchStore>();
  final showSearch = showReceiveCurrencySearch(context);

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    then: (value) {
      sAnalytics.receiveChooseAssetClose();
    },
    pinned: ActionBottomSheetHeader(
      name: intl.actionReceive_bottomSheetHeaderName1,
      showSearch: showSearch,
      onChanged: (String value) {
        getIt.get<ActionSearchStore>().search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _ActionReceive(
        searchStore: searchStore,
      ),
    ],
  );
}

class _ActionReceive extends StatelessObserverWidget {
  const _ActionReceive({
    Key? key,
    required this.searchStore,
  }) : super(key: key);

  final ActionSearchStore searchStore;

  @override
  Widget build(BuildContext context) {
    final state = searchStore;
    sortByBalanceAndWeight(state.filteredCurrencies);

    return Column(
      children: [
        for (final currency in state.filteredCurrencies)
          if (currency.type == AssetType.crypto)
            if (currency.supportsCryptoDeposit)
              SWalletItem(
                icon: SNetworkSvg24(
                  url: currency.iconUrl,
                ),
                primaryText: currency.description,
                secondaryText: currency.symbol,
                removeDivider: currency == state.filteredCurrencies.last,
                onTap: () {
                  sAnalytics.receiveAssetView(asset: currency.description);

                  getIt.get<AppRouter>().push(
                        CryptoDepositRouter(
                          header: intl.actionReceive_receive,
                          currency: currency,
                        ),
                      );
                },
              ),
        const SpaceH24(),
      ],
    );
  }
}
