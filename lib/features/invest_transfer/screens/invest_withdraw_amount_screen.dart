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
import 'package:jetwallet/features/invest_transfer/store/invest_withdraw_amount_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
                        SuggestionButton(
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
                        const SpaceH4(),
                        SuggestionButton(
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SNumericKeyboard(
              onKeyPressed: (value) {
                store.updateInputValue(value);
              },
              button: SButton.black(
                text: intl.addCircleCard_continue,
                callback: store.isContinueAvaible
                    ? () {
                        final amount = Decimal.tryParse(store.cryptoInputValue) ?? Decimal.zero;
                        sRouter.push(
                          InvestWithdrawConfrimationRoute(
                            amount: amount,
                            assetId: store.cryptoSymbol,
                          ),
                        );
                      }
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
