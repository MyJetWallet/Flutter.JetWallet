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
import 'package:jetwallet/features/invest_transfer/store/invest_deposite_amount_store.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class InvestDepositeAmountScreen extends StatefulWidget {
  const InvestDepositeAmountScreen({
    super.key,
  });

  @override
  _InvestDepositeAmountScreenState createState() => _InvestDepositeAmountScreenState();
}

class _InvestDepositeAmountScreenState extends State<InvestDepositeAmountScreen> {
  late InvestDepositeAmountStore store;

  @override
  void initState() {
    super.initState();
    store = InvestDepositeAmountStore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (store.isShowTopUpModal) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await sShowAlertPopup(
          context,
          primaryText: intl.earn_deposit_crypto_wallet,
          secondaryText: intl.invest_transfer_empty_balance,
          primaryButtonName: intl.earn_top_up_value(store.cryptoSymbol),
          secondaryButtonName: intl.earn_cancel,
          image: Image.asset(
            blockedAsset,
            width: 80,
            height: 80,
            package: 'simple_kit',
          ),
          onWillPop: () async {
            sRouter.popUntilRoot();
          },
          onPrimaryButtonTap: () {
            navigateToWallet(context, store.currency);
          },
          onSecondaryButtonTap: () async {
            sRouter.popUntilRoot();
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<InvestDepositeAmountStore>(
      create: (_) => store,
      child: const _EarnWithdrawalAmountBody(),
    );
  }
}

class _EarnWithdrawalAmountBody extends StatelessWidget {
  const _EarnWithdrawalAmountBody();
  @override
  Widget build(BuildContext context) {
    final store = InvestDepositeAmountStore.of(context);
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
                          title: store.currency.description,
                          subTitle: intl.invest_transfer_from_crypto_wallet,
                          trailing: getIt<AppStore>().isBalanceHide
                              ? '**** ${store.currency.symbol}'
                              : store.currency.volumeAssetBalance,
                          icon: NetworkIconWidget(
                            store.currency.iconUrl,
                          ),
                          onTap: () {},
                          showArrow: false,
                        ),
                        const SpaceH4(),
                        SuggestionButtonWidget(
                          title: intl.invest_title,
                          subTitle: intl.invest_transfer_to_invest,
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
                          InvestDepositeConfrimationRoute(
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
