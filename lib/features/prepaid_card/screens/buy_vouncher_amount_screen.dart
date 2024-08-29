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
import 'package:jetwallet/features/prepaid_card/store/buy_vouncher_amount_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/widgets/currency_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/purchase_card_brand_list_response_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/services/prevent_duplication_events_servise.dart';

@RoutePage(name: 'BuyVouncherAmountRouter')
class BuyVouncherAmountScreen extends StatelessWidget {
  const BuyVouncherAmountScreen({
    super.key,
    required this.selectedBrand,
    required this.country,
  });

  final PurchaseCardBrandDtoModel selectedBrand;
  final SPhoneNumber country;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('vouncher-amount-screen-key'),
      onVisibilityChanged: (info) {
        getIt.get<PreventDuplicationEventsService>().sendEvent(
              id: 'vouncher-amount-screen-key',
              event: sAnalytics.amountBuyVoucherScreenView,
            );
      },
      child: SPageFrame(
        loaderText: '',
        header: SPaddingH24(
          child: SSmallHeader(
            title: intl.prepaid_card_buy_voucher,
            onBackButtonTap: () {
              sAnalytics.tapOnTheBackButtonOnAmountBuyVoucherScreen();
              sAnalytics.choosePrepaidCardScreenView();
              sRouter.maybePop();
            },
          ),
        ),
        child: Provider<BuyVouncherAmountAtore>(
          create: (_) => BuyVouncherAmountAtore(
            brand: selectedBrand,
            country: country,
          ),
          child: const _EarnWithdrawalAmountBody(),
        ),
      ),
    );
  }
}

class _EarnWithdrawalAmountBody extends StatelessWidget {
  const _EarnWithdrawalAmountBody();
  @override
  Widget build(BuildContext context) {
    final store = BuyVouncherAmountAtore.of(context);
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
                value: store.fiatInputValue,
              ),
              primarySymbol: store.fiatSymbol,
              secondaryAmount: formatCurrencyStringAmount(
                value: store.cryptoInputValue,
              ),
              secondarySymbol: store.cryptoSymbol,
              onSwap: null,
              showSwopButton: false,
              errorText: store.errorText,
              optionText: store.cryptoInputValue == '0'
                  ? '''${intl.earn_max} ${getIt<AppStore>().isBalanceHide ? '**** ${store.cryptoSymbol}' : store.buyAllValue.toFormatCount(accuracy: store.brandCurrency.accuracy, symbol: store.fiatSymbol)}'''
                  : null,
              optionOnTap: () {
                store.onBuyAll();
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
              subTitle: intl.prepaid_card_pay_with,
              trailing:
                  getIt<AppStore>().isBalanceHide ? '**** ${store.currency.symbol}' : store.currency.volumeAssetBalance,
              icon: NetworkIconWidget(
                store.currency.iconUrl,
              ),
              onTap: () {},
              showArrow: false,
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
                sAnalytics.tapOnTheContinueButtonOnAmountBuyVoucherScreen(
                  amount: formatCurrencyStringAmount(
                    value: store.cryptoInputValue,
                    symbol: store.cryptoSymbol,
                  ),
                  country: store.country.isoCode,
                );
                sRouter.push(
                  BuyVouncherConfirmationRoute(
                    amount: Decimal.parse(store.fiatInputValue),
                    brand: store.brand,
                    country: store.country,
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
