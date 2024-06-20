import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/p2p_buy/store/buy_p2p_amount_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_methods_responce_model.dart';

@RoutePage(name: 'P2PBuyAmountRouter')
class P2PBuyAmountScreen extends StatelessWidget {
  const P2PBuyAmountScreen({
    super.key,
    required this.currency,
    required this.paymentCurrecy,
    required this.p2pMethod,
  });

  final CurrencyModel currency;
  final PaymentAsset paymentCurrecy;
  final P2PMethodModel p2pMethod;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;

    return Provider<BuyP2PAmountStore>(
      create: (context) => BuyP2PAmountStore()
        ..init(
          inputAsset: currency,
          inputP2pMethod: p2pMethod,
          inputPaymentAsset: paymentCurrecy,
        ),
      builder: (context, child) {
        final store = BuyP2PAmountStore.of(context);

        return SPageFrame(
          loaderText: '',
          header: SPaddingH24(
            child: SSmallHeader(
              title: intl.prepaid_card_buy_voucher,
            ),
          ),
          child: Observer(
            builder: (context) {
              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      physics: const ClampingScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: Column(
                            children: [
                              deviceSize.when(
                                small: () => const SpaceH40(),
                                medium: () => const Spacer(),
                              ),
                              SNewActionPriceField(
                                widgetSize: widgetSizeFrom(deviceSize),
                                primaryAmount: formatCurrencyStringAmount(
                                  value: store.primaryAmount,
                                ),
                                primarySymbol: store.primarySymbol,
                                secondaryAmount: store.asset != null
                                    ? '${intl.earn_est} ${volumeFormat(
                                        decimal: Decimal.parse(store.secondaryAmount),
                                        symbol: '',
                                        accuracy: store.secondaryAccuracy,
                                      )}'
                                    : null,
                                secondarySymbol: store.asset != null ? store.secondarySymbol : null,
                                onSwap: () {
                                  store.swapAssets();
                                },
                                errorText: store.paymentMethodInputError,
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
                              SuggestionButtonWidget(
                                title: store.asset?.description,
                                subTitle: intl.amount_screen_buy,
                                icon: SNetworkSvg24(
                                  url: store.asset?.iconUrl ?? '',
                                ),
                                showArrow: false,
                                onTap: () {},
                              ),
                              const SpaceH8(),
                              SuggestionButtonWidget(
                                subTitle: intl.amount_screen_pay_with,
                                icon: SNetworkCachedSvg(
                                  url: iconForPaymentMethod(
                                    methodId: store.p2pMethod?.methodId ?? '',
                                  ),
                                  width: 24,
                                  height: 24,
                                  placeholder: const SizedBox(),
                                ),
                                showArrow: false,
                                onTap: () {},
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
                      sRouter.push(
                        BuyP2PConfirmationRoute(
                          asset: store.buyCurrency,
                          paymentAsset: store.paymentAsset!,
                          p2pMethod: store.p2pMethod!,
                          isFromFixed: store.isFiatEntering,
                          fromAmount: store.fiatInputValue,
                          toAmount: store.cryptoInputValue,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
