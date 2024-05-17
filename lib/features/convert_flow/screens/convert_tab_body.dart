import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/convert_flow/store/convert_amount_store.dart';
import 'package:jetwallet/features/convert_flow/widgets/convert_from_choose_asset_bottom_sheet.dart';
import 'package:jetwallet/features/convert_flow/widgets/convert_to_choose_asset_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/crypto/simple_crypto_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/di/di.dart';
import '../../app/store/app_store.dart';

class ConvertAmountTabBody extends StatefulObserverWidget {
  const ConvertAmountTabBody({
    super.key,
    this.fromAsset,
    this.toAsset,
  });

  final CurrencyModel? fromAsset;
  final CurrencyModel? toAsset;

  @override
  State<ConvertAmountTabBody> createState() => ConvertAmountScreenBodyState();
}

class ConvertAmountScreenBodyState extends State<ConvertAmountTabBody> with AutomaticKeepAliveClientMixin {
  final GlobalKey _key = GlobalKey();

  void updateStorage({
    CurrencyModel? newFromAsset,
    CurrencyModel? newToAsset,
  }) {
    final contextWithStorage = _key.currentContext;
    if (contextWithStorage == null) return;
    final store = ConvertAmountStore.of(contextWithStorage);
    store.init(
      newFromAsset: newFromAsset,
      newToAsset: newToAsset,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final deviceSize = sDeviceSize;

    return Provider<ConvertAmountStore>(
      create: (context) => ConvertAmountStore()
        ..init(
          newFromAsset: widget.fromAsset,
          newToAsset: widget.toAsset,
        ),
      builder: (context, child) {
        final store = ConvertAmountStore.of(context);

        return VisibilityDetector(
          key: const Key('convert-flow-widget-key'),
          onVisibilityChanged: (visibilityInfo) {
            if (visibilityInfo.visibleFraction != 1) return;

            sAnalytics.convertAmountScreenView();
          },
          child: Observer(
            key: _key,
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
                                  value: store.primaryAmount,
                                ),
                                primarySymbol: store.primarySymbol,
                                secondaryAmount: store.secondarySymbol != ''
                                    ? volumeFormat(
                                        decimal: Decimal.parse(store.secondaryAmount),
                                        symbol: '',
                                        accuracy: store.secondaryAccuracy,
                                      )
                                    : null,
                                secondarySymbol: store.toAsset != null ? store.secondarySymbol : null,
                                onSwap: () {
                                  sAnalytics.tapOnTheChangeInputAssetConvert();
                                  store.swapAssets();
                                },
                                errorText: store.paymentMethodInputError,
                                optionText: store.fromInputValue == '0' &&
                                        store.fromAsset != null &&
                                        store.toAsset != null
                                    ? '''${intl.convert_amount_convert_all} ${getIt<AppStore>().isBalanceHide ? '**** ${store.fromAsset?.symbol}' : volumeFormat(decimal: store.convertAllAmount, accuracy: store.fromAsset?.accuracy ?? 1, symbol: store.fromAsset?.symbol ?? '')}'''
                                    : null,
                                optionOnTap: () {
                                  sAnalytics.tapOnTheConvertAll();
                                  store.onConvetrAll();
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
                              if (store.fromAsset != null)
                                SuggestionButtonWidget(
                                  title: store.fromAsset?.description,
                                  subTitle: intl.amount_screen_convert,
                                  trailing: getIt<AppStore>().isBalanceHide
                                      ? '**** ${store.fromAsset?.symbol}'
                                      : store.fromAsset?.volumeAssetBalance,
                                  icon: SNetworkSvg24(
                                    url: store.fromAsset?.iconUrl ?? '',
                                  ),
                                  onTap: () {
                                    sAnalytics.tapOnTheConvertFromButton(
                                      currentFromValueForSell: store.fromAsset?.symbol ?? '',
                                    );

                                    showConvertFromChooseAssetBottomSheet(
                                      context: context,
                                      onChooseAsset: (currency) {
                                        store.setNewFromAsset(currency);
                                        sAnalytics.tapOnSelectedNewConvertFromAssetButton(
                                          newConvertFromAsset: currency.symbol,
                                        );
                                        Navigator.of(context).pop(true);
                                      },
                                      skipAssetSymbol: store.toAsset?.symbol,
                                      then: (value) {
                                        if (value != true) {
                                          sAnalytics.tapOnCloseSheetConvertFromButton();
                                        }
                                      },
                                    );
                                  },
                                  isDisabled: store.isNoCurrencies,
                                )
                              else
                                SuggestionButtonWidget(
                                  subTitle: intl.amount_screen_convert,
                                  icon: const SCryptoIcon(),
                                  onTap: () {
                                    sAnalytics.tapOnTheConvertFromButton(
                                      currentFromValueForSell: store.fromAsset?.symbol ?? '',
                                    );

                                    showConvertFromChooseAssetBottomSheet(
                                      context: context,
                                      onChooseAsset: (currency) {
                                        store.setNewFromAsset(currency);
                                        sAnalytics.tapOnSelectedNewConvertFromAssetButton(
                                          newConvertFromAsset: currency.symbol,
                                        );
                                        Navigator.of(context).pop(true);
                                      },
                                      skipAssetSymbol: store.toAsset?.symbol,
                                      then: (value) {
                                        if (value != true) {
                                          sAnalytics.tapOnCloseSheetConvertFromButton();
                                        }
                                      },
                                    );
                                  },
                                  isDisabled: store.isNoCurrencies,
                                ),
                              const SpaceH8(),
                              if (store.toAsset != null)
                                SuggestionButtonWidget(
                                  title: store.toAsset?.description,
                                  subTitle: intl.convert_amount_convert_to,
                                  trailing: getIt<AppStore>().isBalanceHide
                                      ? '**** ${store.toAsset?.symbol}'
                                      : store.toAsset?.volumeAssetBalance,
                                  icon: SNetworkSvg24(
                                    url: store.toAsset?.iconUrl ?? '',
                                  ),
                                  onTap: () {
                                    sAnalytics.tapOnTheConvertToButton(
                                      currentToValueForConvert: store.toAsset?.symbol ?? '',
                                    );

                                    showConvertToChooseAssetBottomSheet(
                                      context: context,
                                      onChooseAsset: (currency) {
                                        store.setNewToAsset(currency);
                                        Navigator.of(context).pop(true);
                                      },
                                      skipAssetSymbol: store.fromAsset?.symbol,
                                    );
                                  },
                                )
                              else
                                SuggestionButtonWidget(
                                  subTitle: intl.convert_amount_convert_to,
                                  icon: const SCryptoIcon(),
                                  onTap: () {
                                    sAnalytics.tapOnTheConvertToButton(
                                      currentToValueForConvert: store.toAsset?.symbol ?? '',
                                    );

                                    showConvertToChooseAssetBottomSheet(
                                      context: context,
                                      onChooseAsset: (currency) {
                                        store.setNewToAsset(currency);
                                        Navigator.of(context).pop(true);
                                      },
                                      skipAssetSymbol: store.fromAsset?.symbol,
                                    );
                                  },
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
                      sAnalytics.tapOnTContinueWithConvertAmountCutton(
                        enteredAmount: store.primaryAmount,
                        convertFromAsset: store.fromAsset?.symbol ?? '',
                        convertToAsset: store.toAsset?.symbol ?? '',
                        nowInput: store.isFromEntering ? 'ConvertFrom' : 'ConvertTo',
                      );
                      sRouter.push(
                        ConvetrConfirmationRoute(
                          fromAsset: store.fromAsset!,
                          toAsset: store.toAsset!,
                          fromAmount: Decimal.parse(store.fromInputValue),
                          toAmount: Decimal.parse(store.toInputValue),
                          isFromFixed: store.isFromEntering,
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

  @override
  bool get wantKeepAlive => true;
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
