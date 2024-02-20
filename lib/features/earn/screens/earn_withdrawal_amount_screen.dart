import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/earn/store/earn_withdrawal_amount_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
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
            deviceSize.when(
              small: () => const SpaceH40(),
              medium: () => const Spacer(),
            ),
            SNewActionPriceField(
              widgetSize: widgetSizeFrom(deviceSize),
              primaryAmount: formatCurrencyStringAmount(
                value: store.cryptoInputValue,
              ),
              primarySymbol: store.cryptoSymbol,
              secondaryAmount:
                  '${intl.earn_est} ${volumeFormat(decimal: Decimal.parse(store.fiatInputValue), symbol: '', accuracy: store.eurCurrency.accuracy)}',
              secondarySymbol: store.eurCurrency.symbol,
              onSwap: null,
              showSwopButton: false,
              errorText: store.errorText,
              optionText: store.cryptoInputValue == '0'
                  ? '''${intl.earn_max} ${getIt<AppStore>().isBalanceHide ? '**** ${store.cryptoSymbol}' : volumeFormat(decimal: store.withdrawAllValue, accuracy: store.currency.accuracy, symbol: store.cryptoSymbol)}'''
                  : null,
              optionOnTap: () {
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
                  : volumeFormat(
                      decimal: store.earnPosition.incomeAmount,
                      accuracy: store.currency.accuracy,
                      symbol: store.cryptoSymbol,
                    ),
              icon: SNetworkSvg24(
                url: store.currency.iconUrl,
              ),
              onTap: () {},
            ),
            const SpaceH8(),
            SuggestionButtonWidget(
              title: store.currency.description,
              subTitle: intl.earn_to_crypto_wallet,
              trailing: getIt<AppStore>().isBalanceHide
                  ? '**** ${store.currency.symbol}'
                  : volumeFormat(
                      decimal: store.currency.assetBalance,
                      accuracy: store.currency.accuracy,
                      symbol: store.currency.symbol,
                    ),
              icon: SNetworkSvg24(
                url: store.currency.iconUrl,
              ),
              onTap: () {},
            ),
            const SpaceH20(),
            SNumericKeyboardAmount(
              widgetSize: widgetSizeFrom(deviceSize),
              onKeyPressed: (value) {
                store.updateInputValue(value);
              },
              buttonType: SButtonType.primary2,
              submitButtonActive: store.isContinueAvaible,
              submitButtonName: intl.addCircleCard_continue,
              onSubmitPressed: () {
                // TODO (Yaroslav): add routing to Order Simmary screen
              },
            ),
          ],
        );
      },
    );
  }
}
