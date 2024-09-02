import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/invest_transfer/store/invest_withdraw_amount_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';

class InvestWithdrawAmountScreen extends StatefulWidget {
  const InvestWithdrawAmountScreen({
    super.key,
  });

  @override
  _InvestWithdrawAmountScreenState createState() => _InvestWithdrawAmountScreenState();
}

class _InvestWithdrawAmountScreenState extends State<InvestWithdrawAmountScreen> {
  late InvestWithdrawAmountStore store;

  @override
  void initState() {
    super.initState();
    store = InvestWithdrawAmountStore();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<InvestWithdrawAmountStore>(
      create: (_) => store,
      child: const _EarnWithdrawalAmountBody(),
    );
  }
}

class _EarnWithdrawalAmountBody extends StatelessWidget {
  const _EarnWithdrawalAmountBody();
  @override
  Widget build(BuildContext context) {
    final store = InvestWithdrawAmountStore.of(context);
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
                        SNewActionPriceField(
                          widgetSize: widgetSizeFrom(deviceSize),
                          primaryAmount: formatCurrencyStringAmount(
                            value: store.cryptoInputValue,
                          ),
                          primarySymbol: store.cryptoSymbol,
                          secondaryAmount:
                              '${intl.earn_est} ${Decimal.parse(store.fiatInputValue).toFormatSum(accuracy: store.baseCurrency.accuracy)}',
                          secondarySymbol: store.fiatSymbol,
                          onSwap: null,
                          showSwopButton: false,
                          errorText: store.errorText,
                          optionText: store.cryptoInputValue == '0'
                              ? '''${intl.earn_max} ${getIt<AppStore>().isBalanceHide ? '**** ${store.cryptoSymbol}' : store.withdrawAllValue.toFormatCount(accuracy: store.currency.accuracy, symbol: store.cryptoSymbol)}'''
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
                          title: intl.invest_title,
                          subTitle: intl.invest_transfer_from_invest,
                          trailing: getIt<AppStore>().isBalanceHide
                              ? '**** ${store.currency.symbol}'
                              : (sSignalRModules.investWalletData?.balance ?? Decimal.zero).toFormatCount(
                                  accuracy: store.currency.accuracy,
                                  symbol: store.cryptoSymbol,
                                ),
                          icon: Assets.svg.assets.fiat.simpleInvest.simpleSvg(),
                          onTap: () {},
                          showArrow: false,
                        ),
                        const SpaceH8(),
                        SuggestionButtonWidget(
                          title: store.currency.description,
                          subTitle: intl.invest_transfer_to_crypto_wallet,
                          trailing: getIt<AppStore>().isBalanceHide
                              ? '**** ${store.currency.symbol}'
                              : store.currency.volumeAssetBalance,
                          icon: NetworkIconWidget(
                            store.currency.iconUrl,
                          ),
                          onTap: () {},
                          showArrow: false,
                        ),
                        const SpaceH20(),
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
                final amount = Decimal.tryParse(store.cryptoInputValue) ?? Decimal.zero;
                sRouter.push(
                  InvestWithdrawConfrimationRoute(
                    amount: amount,
                    assetId: store.cryptoSymbol,
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
