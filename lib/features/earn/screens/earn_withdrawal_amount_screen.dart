import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/earn/store/earn_withdrawal_amount_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

@RoutePage(name: 'EarnWithdrawalAmountRouter')
class EarnWithdrawalAmountScreen extends StatelessWidget {
  const EarnWithdrawalAmountScreen({
    super.key,
    required this.earnPosition,
  });

  final EarnPositionClientModel earnPosition;

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: SPaddingH24(
        child: SSmallHeader(
          onBackButtonTap: () {
            Navigator.of(context).pop();
          },
          title: intl.earn_partial_withdrawal,
        ),
      ),
      child: Provider<EarnWithdrawalAmountStore>(
        create: (context) => EarnWithdrawalAmountStore(
          earnPosition: earnPosition,
        ),
        child: const _EarnWithdrawalAmountBody(),
      ),
    );
  }
}

class _EarnWithdrawalAmountBody extends StatelessWidget {
  const _EarnWithdrawalAmountBody();

  @override
  Widget build(BuildContext context) {
    final store = EarnWithdrawalAmountStore.of(context);
    final deviceSize = sDeviceSize;

    return Observer(
      builder: (context) {
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        deviceSize.when(
                          small: () => const SpaceH40(),
                          medium: () => const Spacer(),
                        ),
                        SNumericLargeInput(
                          primaryAmount: formatCurrencyStringAmount(
                            value: store.cryptoInputValue,
                          ),
                          primarySymbol: store.cryptoSymbol,
                          onSwap: null,
                          showSwopButton: false,
                          errorText: store.errorText,
                          showMaxButton: true,
                          onMaxTap: () {
                            store.onSellAll();
                          },
                          pasteLabel: intl.paste,
                          onPaste: () async {
                            final data = await Clipboard.getData('text/plain');
                            if (data?.text != null) {
                              final n = double.tryParse(data!.text!);
                              if (n != null) {
                                store.pasteValue(n.toString().trim());
                              }
                            }
                          },
                        ),
                        const Spacer(),
                        SuggestionButtonWidget(
                          title: store.earnPosition.offers.first.name,
                          subTitle: intl.earn_from_earn,
                          trailing: getIt<AppStore>().isBalanceHide
                              ? '**** ${store.currency.symbol}'
                              : store.earnPosition.baseAmount.toFormatCount(
                                  accuracy: store.currency.accuracy,
                                  symbol: store.cryptoSymbol,
                                ),
                          icon: NetworkIconWidget(
                            store.currency.iconUrl,
                          ),
                          onTap: () {},
                          showArrow: false,
                        ),
                        const SpaceH4(),
                        SuggestionButtonWidget(
                          title: store.currency.description,
                          subTitle: intl.earn_to_crypto_wallet,
                          trailing: getIt<AppStore>().isBalanceHide
                              ? '**** ${store.currency.symbol}'
                              : store.currency.volumeAssetBalance,
                          icon: NetworkIconWidget(
                            store.currency.iconUrl,
                          ),
                          onTap: () {},
                          showArrow: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SNumericKeyboardAmount(
              widgetSize: widgetSizeFrom(deviceSize),
              onKeyPressed: (value) {
                store.updateInputValue(value);
              },
              buttonType: SButtonType.primary2,
              submitButtonActive: store.isContinueAvaible,
              submitButtonName: intl.addCircleCard_continue,
              onSubmitPressed: () {
                sAnalytics.tapOnTheContinueWithEarnWithdrawAmountButton(
                  assetName: store.earnPosition.assetId,
                  earnOfferId: store.earnPosition.offerId,
                  earnPlanName: store.earnPosition.offers.first.name ?? '',
                  earnWithdrawalType: store.earnPosition.withdrawType.name,
                  withdrawAmount: store.cryptoInputValue,
                );
                sRouter.push(
                  EarnWithdrawOrderSummaryRouter(
                    amount: Decimal.parse(store.cryptoInputValue),
                    earnPosition: store.earnPosition,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
