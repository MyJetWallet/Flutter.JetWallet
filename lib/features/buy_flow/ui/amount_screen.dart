import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/buy_flow/store/amount_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/buy_option_widget.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/pay_with_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

import '../../currency_buy/ui/widgets/choose_asset_bottom_sheet.dart';

@RoutePage()
class BuyAmountScreen extends StatelessWidget {
  const BuyAmountScreen({
    super.key,
    required this.asset,
    this.card,
    this.account,
  });

  final CurrencyModel asset;

  final CircleCard? card;
  final SimpleBankingAccount? account;

  @override
  Widget build(BuildContext context) {
    return Provider<BuyAmountStore>(
      create: (context) => BuyAmountStore()
        ..init(
          inputAsset: asset,
          inputCard: card,
          account: account,
        ),
      builder: (context, child) => _BuyAmountScreenBody(
        asset: asset,
        card: card,
      ),
    );
  }
}

class _BuyAmountScreenBody extends StatefulObserverWidget {
  const _BuyAmountScreenBody({
    required this.asset,
    this.card,
  });

  final CurrencyModel asset;

  final CircleCard? card;

  @override
  State<_BuyAmountScreenBody> createState() => _BuyAmountScreenBodyState();
}

class _BuyAmountScreenBodyState extends State<_BuyAmountScreenBody> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final store = BuyAmountStore.of(context);

    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '',
          onBackButtonTap: () => sRouter.pop(),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SPaddingH24(
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.grey5,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TabBar(
                    controller: TabController(length: 3, vsync: this),
                    indicator: BoxDecoration(
                      color: colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    labelColor: colors.white,
                    labelStyle: sSubtitle3Style,
                    unselectedLabelColor: colors.grey1,
                    unselectedLabelStyle: sSubtitle3Style,
                    splashBorderRadius: BorderRadius.circular(16),
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: intl.amount_screen_tab_buy,
                      ),
                      Tab(
                        text: intl.amount_screen_tab_sell,
                      ),
                      Tab(
                        text: intl.amount_screen_tab_convert,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          deviceSize.when(
            small: () => const SpaceH40(),
            medium: () => const Spacer(),
          ),
          SNewActionPriceField(
            widgetSize: widgetSizeFrom(deviceSize),
            primaryAmount: formatCurrencyStringAmount(
              value: store.fiatInputValue,
            ),
            primarySymbol: store.fiatSymbol,
            secondaryAmount: formatCurrencyStringAmount(
              value: store.cryptoInputValue,
            ),
            secondarySymbol: store.cryptoSymbol,
            isPrimaryActive: store.isFiatEntering,
            onSwap: () {
              store.isFiatEntering = !store.isFiatEntering;
            },
            errorText: store.paymentMethodInputError,
          ),
          const Spacer(),
          BuyOptionWidget(
            title: store.asset?.description ?? '',
            subTitle: intl.amount_screen_buy,
            trailing:  store.asset?.volumeAssetBalance,
            icon: SNetworkSvg24(
              url: store.asset?.iconUrl ?? '',
            ),
            onTap: () {
              showChooseAssetBottomSheet(
                context: context,
                onChooseAsset: (currency) {
                  store.setNewAsset(currency);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
          const SpaceH8(),
          if (store.category == PaymentMethodCategory.account)
            BuyOptionWidget(
              title: store.account?.label ?? '',
              subTitle: intl.amount_screen_pay_with,
              trailing: volumeFormat(
                decimal: store.account?.balance ?? Decimal.zero,
                accuracy: store.asset?.accuracy ?? 1,
                symbol: store.account?.currency ?? '',
              ),
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: sKit.colors.blue,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: SBankMediumIcon(color: sKit.colors.white),
                ),
              ),
              onTap: () {
                showPayWithBottomSheet(
                  context: context,
                  currency: store.asset!,
                  onSelected: ({account, inputCard}) {
                    store.setNewPayWith(
                      newCard: inputCard,
                      newAccount: account,
                    );
                    Navigator.of(context).pop();
                  },
                );
              },
            )
          else
            BuyOptionWidget(
              title: store.card?.formatedCardLabel ?? '',
              subTitle: intl.amount_screen_pay_with,
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: ShapeDecoration(
                  color: sKit.colors.white,
                  shape: OvalBorder(
                    side: BorderSide(
                      color: colors.grey4,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: getNetworkIcon(store.card?.network),
                ),
              ),
              onTap: () {
                showPayWithBottomSheet(
                  context: context,
                  currency: store.asset!,
                  onSelected: ({account, inputCard}) {
                    store.setNewPayWith(
                      newCard: inputCard,
                      newAccount: account,
                    );
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          const SpaceH20(),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            onKeyPressed: (value) {
              store.updateInputValue(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: store.inputValid &&
                !store.disableSubmit &&
                !(double.parse(store.primaryAmount) == 0.0) &&
                store.limitByAsset?.barProgress != 100,
            submitButtonName: intl.addCircleCard_continue,
            onSubmitPressed: () {
              sRouter.push(
                BuyConfirmationRoute(
                  asset: store.asset!,
                  paymentCurrency: store.buyCurrency,
                  amount: store.fiatInputValue,
                  card: store.card,
                  account: store.account,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget getNetworkIcon(CircleCardNetwork? network) {
  switch (network) {
    case CircleCardNetwork.VISA:
      return const SVisaCardIcon(
        width: 40,
        height: 25,
      );
    case CircleCardNetwork.MASTERCARD:
      return const SMasterCardIcon(
        width: 40,
        height: 25,
      );
    default:
      return const SActionDepositIcon();
  }
}
