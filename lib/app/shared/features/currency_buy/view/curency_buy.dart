import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';
import 'package:simple_networking/services/signal_r/model/asset_model.dart';
import 'package:simple_networking/services/signal_r/model/asset_payment_methods.dart';
import 'package:simple_networking/services/signal_r/model/card_limits_model.dart';
import 'package:simple_networking/services/swap/model/get_quote/get_quote_request_model.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/widget_size_from.dart';
import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/format_currency_string_amount.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../../models/currency_model.dart';
import '../../../providers/converstion_price_pod/conversion_price_input.dart';
import '../../../providers/converstion_price_pod/conversion_price_pod.dart';
import '../../card_limits/notifier/card_limits_notipod.dart';
import '../../payment_methods/view/components/card_limit.dart';
import '../../recurring/helper/recurring_buys_operation_name.dart';
import '../helper/formatted_circle_card.dart';
import '../model/preview_buy_with_asset_input.dart';
import '../model/preview_buy_with_circle_input.dart';
import '../notifier/currency_buy_notifier/currency_buy_notipod.dart';
import 'components/add_payment_bottom_sheet.dart';
import 'components/recurring_selector.dart';
import 'screens/preview_buy_with_asset.dart';
import 'screens/preview_buy_with_circle/preview_buy_with_circle/preview_buy_with_circle.dart';
import 'screens/simplex_web_view.dart';

class CurrencyBuy extends StatefulHookWidget {
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
  State<CurrencyBuy> createState() => _CurrencyBuyState();
}

class _CurrencyBuyState extends State<CurrencyBuy> {
  @override
  void initState() {
    super.initState();
    final notifier = context.read(currencyBuyNotipod(widget.currency).notifier);
    notifier.initDefaultPaymentMethod(fromCard: widget.fromCard);
    notifier.initRecurringBuyType(widget.recurringBuysType);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final cardLimit = useProvider(cardLimitsNotipod);
    final state = useProvider(currencyBuyNotipod(widget.currency));
    final notifier = useProvider(currencyBuyNotipod(widget.currency).notifier);
    useProvider(
      conversionPriceFpod(
        ConversionPriceInput(
          baseAssetSymbol: widget.currency.symbol,
          quotedAssetSymbol: state.selectedCurrencySymbol,
          then: notifier.updateTargetConversionPrice,
        ),
      ),
    );
    final disableSubmit = useState(false);
    final isLimitBlock = cardLimit.cardLimits?.day1State == StateLimitType.block
        || cardLimit.cardLimits?.day7State ==
            StateLimitType.block
        || cardLimit.cardLimits?.day30State ==
            StateLimitType.block;

    String checkLimitText() {
      var amount = Decimal.zero;
      var limit = Decimal.zero;
      if (state.baseCurrency != null && cardLimit.cardLimits != null) {
        if (cardLimit.cardLimits!.day1State == StateLimitType.block) {
          amount = cardLimit.cardLimits!.day1Amount;
          limit = cardLimit.cardLimits!.day1Limit;
        } else if (cardLimit.cardLimits!.day7State == StateLimitType.block) {
          amount = cardLimit.cardLimits!.day7Amount;
          limit = cardLimit.cardLimits!.day7Limit;
        } else if (cardLimit.cardLimits!.day30State == StateLimitType.block) {
          amount = cardLimit.cardLimits!.day30Amount;
          limit = cardLimit.cardLimits!.day30Limit;
        } else  if (cardLimit.cardLimits!.barInterval == StateBarType.day1) {
          amount = cardLimit.cardLimits!.day1Amount;
          limit = cardLimit.cardLimits!.day1Limit;
        } else if (cardLimit.cardLimits!.barInterval == StateBarType.day7) {
          amount = cardLimit.cardLimits!.day7Amount;
          limit = cardLimit.cardLimits!.day7Limit;
        } else {
          amount = cardLimit.cardLimits!.day30Amount;
          limit = cardLimit.cardLimits!.day30Limit;
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

    final limitText = cardLimit.cardLimits != null ? '${
        (cardLimit.cardLimits!.barInterval == StateBarType.day1
            || cardLimit.cardLimits!.day1State == StateLimitType.block)
            ? intl.paymentMethods_oneDay
            : (cardLimit.cardLimits!.barInterval == StateBarType.day7
            || cardLimit.cardLimits!.day7State == StateLimitType.block)
            ? intl.paymentMethods_sevenDays
            : intl.paymentMethods_thirtyDays
    } ${intl.currencyBuy_limit}: ${checkLimitText()}' : '';

    void _showAssetSelector() {
      sAnalytics.circleChooseMethod();
      sAnalytics.circlePayFromView();
      sShowBasicModalBottomSheet(
        scrollable: true,
        pinned: SBottomSheetHeader(
          name: intl.curencyBuy_payFrom,
        ),
        children: [
          if (cardLimit.cardLimits != null)
            CardLimit(
              cardLimit: cardLimit.cardLimits!,
              small: true,
            ),
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
                      color: (cardLimit.cardLimits?.barProgress == 100 ||
                          isLimitBlock)
                          ? colors.grey2
                          : state.pickedCircleCard?.id == card.id
                          ? colors.blue
                          : colors.black,
                    ),
                    name: formatted.name,
                    amount: formatted.last4Digits,
                    helper: card.status == CircleCardStatus.pending
                      ? intl.paymentMethod_CardIsProcessing
                      : formatted.expDate,
                    description: '',

                    removeDivider: card.id == state.circleCards.last.id,
                    disabled: cardLimit.cardLimits?.barProgress == 100 ||
                        isLimitBlock,
                    onTap: () {
                      if (cardLimit.cardLimits?.barProgress != 100 &&
                          !isLimitBlock) {
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
          if (widget.currency.buyMethods.isNotEmpty) ...[
            const SpaceH24(),
            SPaddingH24(
              child: SSecondaryButton1(
                active: true,
                name: intl.currencyBuy_addPaymentMethod,
                icon: Container(
                  margin: const EdgeInsets.only(
                    top: 32,
                  ),
                  child: SActionBuyIcon(
                    color: colors.black,
                  ),
                ),
                onTap: () {
                  showAddPaymentBottomSheet(
                    context: context,
                    paymentMethods: widget.currency.buyMethods,
                    selectedPaymentMethod: state.selectedPaymentMethod,
                    colors: colors,
                    onCircleCardAdded: (CircleCard card) {
                      notifier.onCircleCardAdded(card);
                    },
                  );
                },
              ),
            ),
          ],
          if (Platform.isAndroid) const SpaceH24(),
        ],
        context: context,
        then: (value) {
          if (value is PaymentMethod) {
            if (value != state.selectedPaymentMethod) {
              notifier.updateSelectedPaymentMethod(value);
              notifier.resetValuesToZero();
            }
          } else if (value is CurrencyModel) {
            if (value != state.selectedCurrency) {
              if (value.symbol != state.baseCurrency!.symbol) {
                notifier.updateTargetConversionPrice(null);
              }
              notifier.updateSelectedCurrency(value);
              notifier.resetValuesToZero();
            }
          } else if (value is CircleCard) {
            notifier.updateSelectedCircleCard(value);
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
              RecurringSelector(
                oneTimePurchaseOnly: state.isOneTimePurchaseOnly,
                currentSelection: state.recurringBuyType,
                onSelect: (selection) {
                  notifier.updateRecurringBuyType(selection);
                  Navigator.pop(context);
                },
              ),
              deviceSize.when(
                small: () => const SpaceH8(),
                medium: () => const SpaceH16(),
              ),
              if (state.selectedPaymentMethod?.type ==
                  PaymentMethodType.simplex)
                SPaymentSelectAsset(
                  widgetSize: widgetSizeFrom(deviceSize),
                  icon: SActionDepositIcon(
                    color: colors.black,
                  ),
                  name: intl.curencyBuy_actionItemName,
                  helper: '≈ 10-30 ${intl.min}',
                  description: intl.curencyBuy_actionItemDescription,
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
                      color: (cardLimit.cardLimits?.barProgress == 100 ||
                          isLimitBlock)
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
                    limit: isLimitBlock
                        ? 100
                        : cardLimit.cardLimits?.barProgress ?? 0,
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
                  notifier.tapPreset(
                      preset.index == 0
                          ? state.preset1Name
                          : preset.index == 1
                          ? state.preset2Name
                          : state.preset3Name,
                  );
                  if (state.selectedPaymentMethod != null) {
                    notifier.selectFixedSum(preset);
                  } else {
                    notifier.selectPercentFromBalance(preset);
                  }
                },
                onKeyPressed: (value) {
                  notifier.updateInputValue(value);
                },
                buttonType: SButtonType.primary2,
                submitButtonActive: state.inputValid &&
                    !state.loader.value &&
                    !disableSubmit.value &&
                    !(state.selectedPaymentMethod?.type ==
                        PaymentMethodType.circleCard &&
                        cardLimit.cardLimits?.barProgress == 100) &&
                    !(state.selectedPaymentMethod?.type ==
                        PaymentMethodType.circleCard && isLimitBlock),
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
                    disableSubmit.value = true;
                    state.loader.startLoading();
                    final response = await notifier.makeSimplexRequest();
                    state.loader.finishLoading();
                    disableSubmit.value = false;

                    if (response != null) {
                      if (!mounted) return;
                      navigatorPush(
                        context,
                        SimplexWebView(response),
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
                    navigatorPush(
                      context,
                      PreviewBuyWithCircle(
                        input: PreviewBuyWithCircleInput(
                          fromCard: widget.fromCard,
                          amount: state.inputValue,
                          card: state.pickedCircleCard!,
                          currency: widget.currency,
                        ),
                      ),
                    );
                  } else {
                    navigatorPush(
                      context,
                      PreviewBuyWithAsset(
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
