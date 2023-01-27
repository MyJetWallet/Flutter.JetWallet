import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_asset_input.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_circle_input.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_unlimint_input.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_bank_card_input.dart';
import 'package:jetwallet/features/currency_buy/store/currency_buy_store.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/show_payment_currecies_bottom_sheet.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_confirm.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';

import '../../payment_methods/ui/widgets/card_limits_bottom_sheet.dart';

class CurrencyBuy extends StatelessWidget {
  const CurrencyBuy({
    Key? key,
    this.recurringBuysType,
    this.circleCard,
    this.unlimintCard,
    this.bankCard,
    this.newBankCardId,
    required this.currency,
    required this.fromCard,
    required this.paymentMethod,
  }) : super(key: key);

  final RecurringBuysType? recurringBuysType;
  final CurrencyModel currency;
  final bool fromCard;
  final PaymentMethodType paymentMethod;
  final CircleCard? circleCard;
  final CircleCard? unlimintCard;
  final CircleCard? bankCard;
  final String? newBankCardId;

  @override
  Widget build(BuildContext context) {
    return Provider<CurrencyBuyStore>(
      create: (context) => CurrencyBuyStore(
        currency,
        paymentMethod,
        circleCard,
        unlimintCard,
        bankCard,
        newBankCardId,
      ),
      builder: (context, child) => _CurrencyBuyBody(
        recurringBuysType: recurringBuysType,
        currency: currency,
        fromCard: fromCard,
        paymentMethod: paymentMethod,
        circleCard: circleCard,
        unlimintCard: unlimintCard,
        bankCard: bankCard,
        newBankCardId: newBankCardId,
      ),
    );
  }
}

class _CurrencyBuyBody extends StatefulObserverWidget {
  const _CurrencyBuyBody({
    Key? key,
    this.recurringBuysType,
    this.circleCard,
    this.unlimintCard,
    this.bankCard,
    this.newBankCardId,
    required this.currency,
    required this.fromCard,
    required this.paymentMethod,
  }) : super(key: key);

  final RecurringBuysType? recurringBuysType;
  final CurrencyModel currency;
  final bool fromCard;
  final PaymentMethodType paymentMethod;
  final CircleCard? circleCard;
  final CircleCard? unlimintCard;
  final CircleCard? bankCard;
  final String? newBankCardId;

  @override
  State<_CurrencyBuyBody> createState() => _CurrencyBuyBodyState();
}

class _CurrencyBuyBodyState extends State<_CurrencyBuyBody> {
  @override
  void initState() {
    super.initState();
    final store = CurrencyBuyStore.of(context);

    store.initDefaultPaymentMethod(fromCard: widget.fromCard);
    store.initRecurringBuyType(widget.recurringBuysType);

    store.setUpdateTargetConversionPrice(
      widget.currency.symbol,
      store.selectedCurrencySymbol,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final cardLimit = sSignalRModules.cardLimitsModel;
    final state = CurrencyBuyStore.of(context);

    final isLimitBlock = cardLimit?.day1State == StateLimitType.block ||
        cardLimit?.day7State == StateLimitType.block ||
        cardLimit?.day30State == StateLimitType.block;
    final cardType = state.selectedPaymentMethod?.id ==
            PaymentMethodType.circleCard ||
        state.selectedPaymentMethod?.id == PaymentMethodType.unlimintCard ||
        state.selectedPaymentMethod?.id == PaymentMethodType.simplex ||
        state.selectedPaymentMethod?.id == PaymentMethodType.bankCard;

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    String checkLimitText() {
      var amount = Decimal.zero;
      var limit = Decimal.zero;
      if (state.baseCurrency != null && cardLimit != null) {
        if (cardLimit.day1State == StateLimitType.block) {
          amount = cardLimit.day1Amount;
          limit = cardLimit.day1Limit;
        } else if (cardLimit.day7State == StateLimitType.block) {
          amount = cardLimit.day7Amount;
          limit = cardLimit.day7Limit;
        } else if (cardLimit.day30State == StateLimitType.block) {
          amount = cardLimit.day30Amount;
          limit = cardLimit.day30Limit;
        } else if (cardLimit.barInterval == StateBarType.day1) {
          amount = cardLimit.day1Amount;
          limit = cardLimit.day1Limit;
        } else if (cardLimit.barInterval == StateBarType.day7) {
          amount = cardLimit.day7Amount;
          limit = cardLimit.day7Limit;
        } else {
          amount = cardLimit.day30Amount;
          limit = cardLimit.day30Limit;
        }

        return '${volumeFormat(
          prefix: state.baseCurrency!.prefix,
          decimal: amount,
          symbol: state.baseCurrency!.symbol,
          accuracy: state.baseCurrency!.accuracy,
          onlyFullPart: true,
        )} / ${volumeFormat(
          prefix: state.baseCurrency!.prefix,
          decimal: limit,
          symbol: state.baseCurrency!.symbol,
          accuracy: state.baseCurrency!.accuracy,
          onlyFullPart: true,
        )}';
      }

      return '';
    }

    final limitText = cardLimit != null
        ? '${(cardLimit.barInterval == StateBarType.day1 ||
            cardLimit.day1State == StateLimitType.block)
          ? intl.paymentMethodsSheet_daily
          : (cardLimit.barInterval == StateBarType.day7 ||
            cardLimit.day7State == StateLimitType.block)
          ? intl.paymentMethodsSheet_weekly
          : intl.paymentMethodsSheet_monthly} ${intl.paymentMethodsSheet_limit}'
          ': ${checkLimitText()}'
        : '';

    void showLimits() {
      showCardLimitsBottomSheet(
        context: context,
        cardLimits: cardLimit!,
      );
    }

    return SPageFrame(
      loaderText: intl.curencyBuy_pleaseWait,
      loading: state.loader,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${intl.curencyBuy_buy} ${widget.currency.description}',
          onBackButtonTap: () => sRouter.pop(),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              deviceSize.when(
                small: () => const SizedBox(),
                medium: () => const Spacer(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Baseline(
                  baseline: deviceSize.when(
                    small: () => 32,
                    medium: () => 31,
                  ),
                  baselineType: TextBaseline.alphabetic,
                  child: SActionPriceField(
                    widgetSize: widgetSizeFrom(deviceSize),
                    additionalWidget: GestureDetector(
                      onTap: () {
                        showPaymentCurrenciesBottomSheet(
                          context: context,
                          header: intl.currencyBuy_chooseCurrency,
                          onTap: (PaymentAsset value) {
                            Navigator.pop(context);
                            state.updatePaymentCurrency(value);
                          },
                          activeAsset: state.selectedPaymentAsset,
                          assets: state.selectedPaymentMethod?.paymentAssets
                            ?? [],
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 14.5,
                          right: 10.5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: colors.grey4,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              state.paymentCurrency?.prefixSymbol ??
                                  state.paymentCurrency?.symbol ?? '',
                              style: sTextH4Style,
                            ),
                            const SpaceW4(),
                            const SAngleDownIcon(),
                          ],
                        ),
                      ),
                    ),
                    price: state.inputValue,
                    helper: state.conversionText(widget.currency),
                    error: state.inputErrorValue,
                    isErrorActive: state.isInputErrorActive,
                  ),
                ),
              ),
              const Spacer(),
              if (kycState.withdrawalStatus !=
                  kycOperationStatus(KycStatus.allowed)) ...[
                GestureDetector(
                  onTap: () {
                    sShowAlertPopup(
                      context,
                      primaryText: intl.actionBuy_alertPopup,
                      primaryButtonName: intl.actionBuy_goToKYC,
                      onPrimaryButtonTap: () {
                        kycAlertHandler.handle(
                          status: kycState.withdrawalStatus,
                          isProgress: kycState.verificationInProgress,
                          currentNavigate: () {},
                          kycFlowOnly: true,
                          requiredDocuments: kycState.requiredDocuments,
                          requiredVerifications: kycState.requiredVerifications,
                        );
                      },
                      secondaryButtonName: intl.actionBuy_gotIt,
                      onSecondaryButtonTap: () {
                        Navigator.pop(context);
                      },
                      size: widgetSizeFrom(deviceSize),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SErrorIcon(
                        color: colors.green,
                      ),
                      const SpaceW10(),
                      Text(
                        intl.actionBuy_kycRequired,
                        style: sCaptionTextStyle.copyWith(
                          color: colors.grey2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              deviceSize.when(
                small: () => const SpaceH8(),
                medium: () => const SpaceH16(),
              ),
              if (state.selectedPaymentMethod?.id ==
                  PaymentMethodType.simplex)
                SPaymentSelectCreditCard(
                  widgetSize: widgetSizeFrom(deviceSize),
                  icon: SActionDepositIcon(
                    color: (cardLimit?.barProgress == 100 || isLimitBlock)
                        ? colors.grey2
                        : colors.black,
                  ),
                  name: intl.currencyBuy_card,
                  description: limitText,
                  limit: isLimitBlock ? 100 : cardLimit?.barProgress ?? 0,
                  onTap: () => showLimits(),
                )
              else if (state.selectedPaymentMethod?.id ==
                  PaymentMethodType.unlimintCard)
                if (state.pickedUnlimintCard != null)
                  SPaymentSelectCreditCard(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: SActionDepositIcon(
                      color: (cardLimit?.barProgress == 100 || isLimitBlock)
                          ? colors.grey2
                          : colors.black,
                    ),
                    name: '${state.pickedUnlimintCard!.network} '
                        '${state.pickedUnlimintCard!.last4}',
                    description: limitText,
                    limit: isLimitBlock ? 100 : cardLimit?.barProgress ?? 0,
                    onTap: () => showLimits(),
                  )
                else
                  SPaymentSelectCreditCard(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: SActionDepositIcon(
                      color: (cardLimit?.barProgress == 100 || isLimitBlock)
                          ? colors.grey2
                          : colors.black,
                    ),
                    name: intl.currencyBuy_card,
                    description: limitText,
                    limit: isLimitBlock ? 100 : cardLimit?.barProgress ?? 0,
                    onTap: () => showLimits(),
                  )
              else if (state.selectedPaymentMethod?.id ==
                  PaymentMethodType.bankCard)
                if (state.pickedAltUnlimintCard != null)
                  SPaymentSelectCreditCard(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: SActionDepositIcon(
                      color: (cardLimit?.barProgress == 100 || isLimitBlock)
                          ? colors.grey2
                          : colors.black,
                    ),
                    name: '${state.pickedAltUnlimintCard!.network} '
                        '${state.pickedAltUnlimintCard!.last4[0] == '•'
                          ? ''
                          :'•••• '}'
                        '${state.pickedAltUnlimintCard!.last4}',
                    description: limitText,
                    limit: isLimitBlock ? 100 : cardLimit?.barProgress ?? 0,
                    onTap: () => showLimits(),
                  )
                else
                  SPaymentSelectCreditCard(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: SActionDepositIcon(
                      color: (cardLimit?.barProgress == 100 || isLimitBlock)
                          ? colors.grey2
                          : colors.black,
                    ),
                    name: intl.currencyBuy_card,
                    description: limitText,
                    limit: isLimitBlock ? 100 : cardLimit?.barProgress ?? 0,
                    onTap: () => showLimits(),
                  )
              else if (state.selectedPaymentMethod?.id ==
                  PaymentMethodType.circleCard)
                if (state.circleCards.isEmpty)
                  SPaymentSelectDefault(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: const SActionBuyIcon(),
                    name: intl.currencyBuy_choosePaymentMethod,
                    onTap: () => showLimits(),
                  )
                else
                  SPaymentSelectCreditCard(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: SActionDepositIcon(
                      color: (cardLimit?.barProgress == 100 || isLimitBlock)
                          ? colors.grey2
                          : colors.black,
                    ),
                    name: '${state.selectedCircleCard!.name} '
                        '${state.selectedCircleCard!.last4Digits}',
                    description: limitText,
                    limit: isLimitBlock ? 100 : cardLimit?.barProgress ?? 0,
                    onTap: () => showLimits(),
                  )
              else if (state.selectedCurrency?.type == AssetType.crypto)
                SPaymentSelectAsset(
                  widgetSize: widgetSizeFrom(deviceSize),
                  icon: SNetworkSvg24(
                    url: state.selectedCurrency!.iconUrl,
                  ),
                  name: state.selectedCurrency!.description,
                  amount: state.selectedCurrency!.volumeBaseBalance(
                    state.baseCurrency!,
                  ),
                  description: state.selectedCurrency!.volumeAssetBalance,
                  onTap: () => showLimits(),
                )
              else if (state.selectedCurrency?.type == AssetType.fiat)
                SPaymentSelectFiat(
                  widgetSize: widgetSizeFrom(deviceSize),
                  icon: SNetworkSvg24(
                    url: state.selectedCurrency!.iconUrl,
                  ),
                  name: state.selectedCurrency!.description,
                  amount: state.selectedCurrency!.volumeBaseBalance(
                    state.baseCurrency!,
                  ),
                  onTap: () => showLimits(),
                )
              else if (widget.fromCard &&
                  widget.currency.supportsAtLeastOneBuyMethod)
                SPaymentSelectDefault(
                  widgetSize: widgetSizeFrom(deviceSize),
                  icon: const SActionBuyIcon(),
                  name: intl.currencyBuy_choosePaymentMethod,
                  onTap: () => showLimits(),
                )
              else
                SPaymentSelectEmptyBalance(
                  widgetSize: widgetSizeFrom(deviceSize),
                  text: intl.sPaymentSelectEmpty_somethingWentWrong,
                  secondaryText: intl.sPaymentSelectEmpty_contactSupport,
                ),
              deviceSize.when(
                small: () => const SpaceH9(),
                medium: () => const SpaceH20(),
              ),
              SNumericKeyboardAmount(
                widgetSize: widgetSizeFrom(deviceSize),
                preset1Name: state.preset1Name,
                preset2Name: state.preset2Name,
                preset3Name: state.preset3Name,
                selectedPreset: state.selectedPreset,
                onPresetChanged: (preset) {
                  state.tapPreset(
                    preset.index == 0
                        ? state.preset1Name
                        : preset.index == 1
                            ? state.preset2Name
                            : state.preset3Name,
                  );
                  if (state.selectedPaymentMethod != null) {
                    state.selectFixedSum(preset);
                  } else {
                    state.selectPercentFromBalance(preset);
                  }
                },
                onKeyPressed: (value) {
                  state.updateInputValue(value);
                },
                buttonType: SButtonType.primary2,
                submitButtonActive: state.inputValid &&
                    !state.loader.loading &&
                    !state.disableSubmit &&
                    !(cardType && cardLimit?.barProgress == 100) &&
                    !(cardType && isLimitBlock) &&
                    !(double.parse(state.inputValue) == 0.0),
                submitButtonName:
                    state.recurringBuyType != RecurringBuysType.oneTimePurchase
                        ? intl.curencyBuy_NumericKeyboardButtonName1
                        : state.selectedPaymentMethod?.id ==
                                    PaymentMethodType.bankCard &&
                                state.pickedAltUnlimintCard == null
                            ? intl.addCircleCard_continue
                            : intl.curencyBuy_NumericKeyboardButtonName2,
                onSubmitPressed: () async {
                  sAnalytics.tapPreviewBuy(
                    assetName: widget.currency.description,
                    paymentMethod: state.selectedPaymentMethod?.id.name ??
                        intl.curencyBuy_crypto,
                    amount: formatCurrencyStringAmount(
                      prefix: state.selectedCurrency?.prefixSymbol,
                      value: state.inputValue,
                      symbol: state.selectedCurrencySymbol,
                    ),
                    frequency: state.recurringBuyType.toFrequency,
                    preset: state.tappedPreset,
                  );

                  if (state.selectedPaymentMethod?.id ==
                      PaymentMethodType.simplex) {
                    state.disableSubmit = true;
                    state.loader.startLoading();

                    final response = await state.makeSimplexRequest();

                    state.loader.finishLoading();
                    state.disableSubmit = false;

                    print(response);

                    if (response != null) {
                      if (!mounted) return;

                      await sRouter.push(
                        SimplexWebViewRouter(url: response),
                      );
                    }
                  } else if (state.selectedPaymentMethod?.id ==
                      PaymentMethodType.circleCard) {
                    sAnalytics.previewBuyView(
                      assetName: widget.currency.description,
                      paymentMethod: state.selectedPaymentMethod?.id.name ??
                          intl.curencyBuy_crypto,
                      amount: formatCurrencyStringAmount(
                        prefix: state.selectedCurrency?.prefixSymbol,
                        value: state.inputValue,
                        symbol: state.selectedCurrencySymbol,
                      ),
                      frequency: state.recurringBuyType.toFrequency,
                    );

                    await sRouter.push(
                      PreviewBuyWithCircleRouter(
                        input: PreviewBuyWithCircleInput(
                          fromCard: widget.fromCard,
                          amount: state.inputValue,
                          card: state.pickedCircleCard!,
                          currency: widget.currency,
                          currencyPayment: state.paymentCurrency ??
                              widget.currency,
                        ),
                      ),
                    );
                  } else if (state.selectedPaymentMethod?.id ==
                      PaymentMethodType.unlimintCard) {
                    sAnalytics.previewBuyView(
                      assetName: widget.currency.description,
                      paymentMethod: state.selectedPaymentMethod?.id.name ??
                          intl.curencyBuy_crypto,
                      amount: formatCurrencyStringAmount(
                        prefix: state.selectedCurrency?.prefixSymbol,
                        value: state.inputValue,
                        symbol: state.selectedCurrencySymbol,
                      ),
                      frequency: state.recurringBuyType.toFrequency,
                    );
                    await sRouter.push(
                      PreviewBuyWithUnlimintRouter(
                        input: PreviewBuyWithUnlimintInput(
                          amount: state.inputValue,
                          currency: widget.currency,
                          card: state.pickedUnlimintCard,
                          currencyPayment: state.paymentCurrency ??
                              widget.currency,
                        ),
                      ),
                    );
                  } else if (state.selectedPaymentMethod?.id ==
                      PaymentMethodType.bankCard) {
                    sAnalytics.previewBuyView(
                      assetName: widget.currency.description,
                      paymentMethod: state.selectedPaymentMethod?.id.name ??
                          intl.curencyBuy_crypto,
                      amount: formatCurrencyStringAmount(
                        prefix: state.selectedCurrency?.prefixSymbol,
                        value: state.inputValue,
                        symbol: state.selectedCurrencySymbol,
                      ),
                      frequency: state.recurringBuyType.toFrequency,
                    );
                    if (state.pickedAltUnlimintCard == null) {
                      sAnalytics.paymentDetailsView(source: 'Unlimint');
                      await sRouter.push(
                        AddUnlimintCardRouter(
                          onCardAdded: () {},
                          isPreview: true,
                          amount: state.inputValue,
                          currency: widget.currency,
                        ),
                      );
                    } else {
                      await sRouter.push(
                        PreviewBuyWithBankCardRouter(
                          input: PreviewBuyWithBankCardInput(
                            amount: state.inputValue,
                            currency: widget.currency,
                            cardId: state.pickedAltUnlimintCard!.id,
                            cardNumber: state.pickedAltUnlimintCard!.last4,
                            currencyPayment: state.paymentCurrency ??
                                widget.currency,
                          ),
                        ),
                      );
                    }
                  } else {
                    await sRouter.push(
                      PreviewBuyWithAssetRouter(
                        input: PreviewBuyWithAssetInput(
                          amount: state.inputValue,
                          fromCurrency: state.selectedCurrency!,
                          toCurrency: widget.currency,
                          recurringType: state.recurringBuyType,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
