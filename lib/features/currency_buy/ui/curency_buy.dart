import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/currency_buy/helper/formatted_circle_card.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_asset_input.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_circle_input.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_unlimint_input.dart';
import 'package:jetwallet/features/currency_buy/store/currency_buy_store.dart';
import 'package:jetwallet/features/currency_buy/ui/widgets/add_payment_bottom_sheet.dart';
import 'package:jetwallet/features/currency_buy/ui/widgets/recurring_selector.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/payment_methods/ui/widgets/card_limit.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';

class CurrencyBuy extends StatelessWidget {
  const CurrencyBuy({
    Key? key,
    this.recurringBuysType,
    required this.currency,
    required this.fromCard,
  }) : super(key: key);

  final RecurringBuysType? recurringBuysType;
  final CurrencyModel currency;
  final bool fromCard;

  @override
  Widget build(BuildContext context) {
    return Provider<CurrencyBuyStore>(
      create: (context) => CurrencyBuyStore(currency),
      builder: (context, child) => _CurrencyBuyBody(
        recurringBuysType: recurringBuysType,
        currency: currency,
        fromCard: fromCard,
      ),
    );
  }
}

class _CurrencyBuyBody extends StatefulObserverWidget {
  const _CurrencyBuyBody({
    Key? key,
    this.recurringBuysType,
    required this.currency,
    required this.fromCard,
  }) : super(key: key);

  final RecurringBuysType? recurringBuysType;
  final CurrencyModel currency;
  final bool fromCard;

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
    final cardType = state.selectedPaymentMethod?.type ==
            PaymentMethodType.circleCard ||
        state.selectedPaymentMethod?.type == PaymentMethodType.unlimintCard ||
        state.selectedPaymentMethod?.type == PaymentMethodType.simplex;

    final unlimintIncludes = widget.currency.buyMethods.where(
      (element) => element.type == PaymentMethodType.unlimintCard,
    );

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
        ? '${(cardLimit.barInterval == StateBarType.day1 || cardLimit.day1State == StateLimitType.block) ? intl.paymentMethods_oneDay : (cardLimit.barInterval == StateBarType.day7 || cardLimit.day7State == StateLimitType.block) ? intl.paymentMethods_sevenDays : intl.paymentMethods_thirtyDays} ${intl.currencyBuy_limit}: ${checkLimitText()}'
        : '';

    void _showAssetSelector() {
      sAnalytics.circleChooseMethod();
      sAnalytics.circlePayFromView();
      sShowBasicModalBottomSheet(
        scrollable: true,
        pinned: SBottomSheetHeader(
          name: intl.curencyBuy_payFrom,
        ),
        children: [
          if (cardLimit != null)
            CardLimit(
              cardLimit: cardLimit,
              small: true,
            ),
          if (state.selectedPaymentMethod?.type ==
              PaymentMethodType.simplex) ...[
            SActionItem(
              isSelected: true,
              expanded: true,
              icon: SActionDepositIcon(
                color: colors.blue,
              ),
              name: intl.curencyBuy_actionItemName,
              description: intl.curencyBuy_actionItemDescription,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SpaceH10(),
            SDivider(
              color: colors.grey3,
            ),
            const SpaceH10(),
          ],
          if (state.selectedPaymentMethod?.type ==
                  PaymentMethodType.unlimintCard &&
              state.pickedUnlimintCard == null) ...[
            SActionItem(
              isSelected: true,
              expanded: true,
              icon: SActionDepositIcon(
                color: colors.blue,
              ),
              name: intl.curencyBuy_unlimint,
              description: intl.curencyBuy_actionItemDescriptionWithoutApplePay,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SpaceH10(),
            SDivider(
              color: colors.grey3,
            ),
            const SpaceH10(),
          ],
          if (state.circleCards.isNotEmpty) ...[
            for (final card in state.circleCards)
              Builder(
                builder: (context) {
                  final formatted = formattedCircleCard(
                    card,
                    state.baseCurrency!,
                  );

                  return SCreditCardItem(
                    lightDivider: true,
                    isSelected: state.pickedCircleCard?.id == card.id &&
                        state.selectedPaymentMethod?.type ==
                            PaymentMethodType.circleCard,
                    icon: SActionDepositIcon(
                      color: (cardLimit?.barProgress == 100 || isLimitBlock)
                          ? colors.grey2
                          : state.pickedCircleCard?.id == card.id &&
                                  state.selectedPaymentMethod?.type ==
                                      PaymentMethodType.circleCard
                              ? colors.blue
                              : colors.black,
                    ),
                    name: formatted.name,
                    amount: formatted.last4Digits,
                    helper: card.status == CircleCardStatus.pending
                        ? intl.paymentMethod_CardIsProcessing
                        : formatted.expDate,
                    description: '',
                    removeDivider: card.id == state.circleCards.last.id &&
                        !(state.unlimintCards.isNotEmpty &&
                            unlimintIncludes.isNotEmpty),
                    disabled: cardLimit?.barProgress == 100 || isLimitBlock,
                    onTap: () {
                      if (cardLimit?.barProgress != 100 && !isLimitBlock) {
                        Navigator.pop(context, card);
                      }
                    },
                  );
                },
              ),
            const SpaceH10(),
            if (!(state.unlimintCards.isNotEmpty &&
                unlimintIncludes.isNotEmpty)) ...[
              SDivider(
                color: colors.grey3,
              ),
              const SpaceH10(),
            ],
          ],
          if (state.unlimintCards.isNotEmpty &&
              unlimintIncludes.isNotEmpty) ...[
            for (final card in state.unlimintCards)
              Builder(
                builder: (context) {
                  final formatted = formattedCircleCard(
                    card,
                    state.baseCurrency!,
                  );

                  return SCreditCardItem(
                    lightDivider: true,
                    isSelected: state.pickedUnlimintCard?.id == card.id &&
                        state.selectedPaymentMethod?.type ==
                            PaymentMethodType.unlimintCard,
                    icon: SActionDepositIcon(
                      color: (cardLimit?.barProgress == 100 || isLimitBlock)
                          ? colors.grey2
                          : state.pickedUnlimintCard?.id == card.id &&
                                  state.selectedPaymentMethod?.type ==
                                      PaymentMethodType.unlimintCard
                              ? colors.blue
                              : colors.black,
                    ),
                    name: formatted.name,
                    amount: formatted.last4Digits,
                    helper: card.status == CircleCardStatus.pending
                        ? intl.paymentMethod_CardIsProcessing
                        : formatted.expDate,
                    description: '',
                    removeDivider: card.id == state.unlimintCards.last.id,
                    disabled: cardLimit?.barProgress == 100 || isLimitBlock,
                    onTap: () {
                      if (cardLimit?.barProgress != 100 && !isLimitBlock) {
                        Navigator.pop(context, card);
                      }
                    },
                  );
                },
              ),
            const SpaceH10(),
            SDivider(
              color: colors.grey3,
            ),
            const SpaceH10(),
          ],
          for (final currency in state.currencies)
            if (currency.type == AssetType.crypto)
              SAssetItem(
                lightDivider: true,
                isSelected: currency == state.selectedCurrency,
                icon: SNetworkSvg24(
                  color: currency == state.selectedCurrency
                      ? colors.blue
                      : colors.black,
                  url: currency.iconUrl,
                ),
                name: currency.description,
                amount: currency.volumeBaseBalance(
                  state.baseCurrency!,
                ),
                description: currency.volumeAssetBalance,
                removeDivider: currency == state.currencies.last,
                onTap: () => Navigator.pop(context, currency),
              )
            else
              SFiatItem(
                isSelected: currency == state.selectedCurrency,
                icon: SNetworkSvg24(
                  color: currency.type != AssetType.indices
                      ? currency == state.selectedCurrency
                          ? colors.blue
                          : colors.black
                      : null,
                  url: currency.type == AssetType.indices &&
                          currency == state.selectedCurrency
                      ? currency.selectedIndexIconUrl
                      : currency.iconUrl,
                ),
                name: currency.description,
                amount: currency.volumeBaseBalance(
                  state.baseCurrency!,
                ),
                onTap: () => Navigator.pop(context, currency),
              ),
          if (widget.currency.buyMethods.isNotEmpty &&
              !(widget.currency.buyMethods.length == 1 &&
                  (state.selectedPaymentMethod?.type ==
                          PaymentMethodType.simplex ||
                      (state.selectedPaymentMethod?.type ==
                              PaymentMethodType.unlimintCard &&
                          state.unlimintCards.isEmpty)))) ...[
            const SpaceH24(),
            SPaddingH24(
              child: SSecondaryButton1(
                active: true,
                name: intl.currencyBuy_morePaymentMethod,
                onTap: () {
                  showAddPaymentBottomSheet(
                    context: context,
                    paymentMethods: widget.currency.buyMethods,
                    selectedPaymentMethod: state.selectedPaymentMethod,
                    colors: colors,
                    onCircleCardAdded: (CircleCard card) {
                      state.onCircleCardAdded(card);
                    },
                  );
                },
              ),
            ),
          ],
          deviceSize.when(
            small: () {
              if (Platform.isIOS) {
                return const SpaceH24();
              }

              return const SizedBox();
            },
            medium: () {
              return const SizedBox();
            },
          ),
          if (Platform.isAndroid) const SpaceH24(),
        ],
        context: context,
        then: (value) {
          if (value is PaymentMethod) {
            if (value != state.selectedPaymentMethod ||
                (value == state.selectedPaymentMethod &&
                    value.type == PaymentMethodType.unlimintCard &&
                    state.pickedUnlimintCard != null)) {
              state.updateSelectedPaymentMethod(value);
              state.resetValuesToZero();
            }
          } else if (value is CurrencyModel) {
            if (value != state.selectedCurrency) {
              if (value.symbol != state.baseCurrency!.symbol) {
                state.updateTargetConversionPrice(null);
              }
              state.updateSelectedCurrency(value);
              state.resetValuesToZero();
            }
          } else if (value is CircleCard) {
            if (value.integration == IntegrationType.unlimint) {
              state.updateSelectedUnlimintCard(value);
            } else {
              state.updateSelectedCircleCard(value);
            }
          }
        },
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
                    price: formatCurrencyStringAmount(
                      prefix: state.selectedCurrency?.prefixSymbol,
                      value: state.inputValue,
                      symbol: state.selectedCurrencySymbol,
                    ),
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
              ] else ...[
                RecurringSelector(
                  oneTimePurchaseOnly: state.isOneTimePurchaseOnly,
                  currentSelection: state.recurringBuyType,
                  onSelect: (selection) {
                    state.updateRecurringBuyType(selection);
                    Navigator.pop(context);
                  },
                ),
              ],
              deviceSize.when(
                small: () => const SpaceH8(),
                medium: () => const SpaceH16(),
              ),
              if (state.selectedPaymentMethod?.type ==
                  PaymentMethodType.simplex)
                SPaymentSelectCreditCard(
                  widgetSize: widgetSizeFrom(deviceSize),
                  icon: SActionDepositIcon(
                    color: (cardLimit?.barProgress == 100 || isLimitBlock)
                        ? colors.grey2
                        : colors.black,
                  ),
                  name: intl.curencyBuy_actionItemName,
                  description: limitText,
                  limit: isLimitBlock ? 100 : cardLimit?.barProgress ?? 0,
                  onTap: () => _showAssetSelector(),
                )
              else if (state.selectedPaymentMethod?.type ==
                  PaymentMethodType.unlimintCard)
                if (state.pickedUnlimintCard != null)
                  SPaymentSelectCreditCard(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: SActionDepositIcon(
                      color: (cardLimit?.barProgress == 100 || isLimitBlock)
                          ? colors.grey2
                          : colors.black,
                    ),
                    name: state.pickedUnlimintCard!.network,
                    amount: state.pickedUnlimintCard!.last4,
                    helper: limitText,
                    description: state.pickedUnlimintCard?.status ==
                            CircleCardStatus.pending
                        ? intl.paymentMethod_CardIsProcessing
                        : '${state.pickedUnlimintCard!.expMonth}/'
                            '${state.pickedUnlimintCard!.expYear}',
                    limit: isLimitBlock ? 100 : cardLimit?.barProgress ?? 0,
                    onTap: () => _showAssetSelector(),
                  )
                else
                  SPaymentSelectCreditCard(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: SActionDepositIcon(
                      color: (cardLimit?.barProgress == 100 || isLimitBlock)
                          ? colors.grey2
                          : colors.black,
                    ),
                    name: intl.curencyBuy_unlimint,
                    description: limitText,
                    limit: isLimitBlock ? 100 : cardLimit?.barProgress ?? 0,
                    onTap: () => _showAssetSelector(),
                  )
              else if (state.selectedPaymentMethod?.type ==
                  PaymentMethodType.circleCard)
                if (state.circleCards.isEmpty)
                  SPaymentSelectDefault(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: const SActionBuyIcon(),
                    name: intl.currencyBuy_choosePaymentMethod,
                    onTap: () => _showAssetSelector(),
                  )
                else
                  SPaymentSelectCreditCard(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: SActionDepositIcon(
                      color: (cardLimit?.barProgress == 100 || isLimitBlock)
                          ? colors.grey2
                          : colors.black,
                    ),
                    name: state.selectedCircleCard!.name,
                    amount: state.selectedCircleCard!.last4Digits,
                    helper: limitText,
                    description: state.pickedCircleCard?.status ==
                            CircleCardStatus.pending
                        ? intl.paymentMethod_CardIsProcessing
                        : state.selectedCircleCard!.expDate,
                    limit: isLimitBlock ? 100 : cardLimit?.barProgress ?? 0,
                    onTap: () => _showAssetSelector(),
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
                  onTap: () => _showAssetSelector(),
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
                  onTap: () => _showAssetSelector(),
                )
              else if (widget.fromCard &&
                  widget.currency.supportsAtLeastOneBuyMethod)
                SPaymentSelectDefault(
                  widgetSize: widgetSizeFrom(deviceSize),
                  icon: const SActionBuyIcon(),
                  name: intl.currencyBuy_choosePaymentMethod,
                  onTap: () => _showAssetSelector(),
                )
              else
                SPaymentSelectEmptyBalance(
                  widgetSize: widgetSizeFrom(deviceSize),
                  text: intl.sPaymentSelectEmpty_buyOnlyWithCrypto,
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
                    !(cardType && isLimitBlock),
                submitButtonName:
                    state.recurringBuyType != RecurringBuysType.oneTimePurchase
                        ? intl.curencyBuy_NumericKeyboardButtonName1
                        : intl.curencyBuy_NumericKeyboardButtonName2,
                onSubmitPressed: () async {
                  sAnalytics.tapPreviewBuy(
                    assetName: widget.currency.description,
                    paymentMethod: state.selectedPaymentMethod?.type.name ??
                        intl.curencyBuy_crypto,
                    amount: formatCurrencyStringAmount(
                      prefix: state.selectedCurrency?.prefixSymbol,
                      value: state.inputValue,
                      symbol: state.selectedCurrencySymbol,
                    ),
                    frequency: state.recurringBuyType.toFrequency,
                    preset: state.tappedPreset,
                  );

                  if (state.selectedPaymentMethod?.type ==
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
                  } else if (state.selectedPaymentMethod?.type ==
                      PaymentMethodType.circleCard) {
                    sAnalytics.previewBuyView(
                      assetName: widget.currency.description,
                      paymentMethod: state.selectedPaymentMethod?.type.name ??
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
                        ),
                      ),
                    );
                  } else if (state.selectedPaymentMethod?.type ==
                      PaymentMethodType.unlimintCard) {
                    sAnalytics.previewBuyView(
                      assetName: widget.currency.description,
                      paymentMethod: state.selectedPaymentMethod?.type.name ??
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
                        ),
                      ),
                    );
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
