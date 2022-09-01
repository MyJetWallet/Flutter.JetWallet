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
import '../../kyc/model/kyc_operation_status_model.dart';
import '../../kyc/notifier/kyc/kyc_notipod.dart';
import '../../payment_methods/view/components/card_limit.dart';
import '../../recurring/helper/recurring_buys_operation_name.dart';
import '../helper/formatted_circle_card.dart';
import '../model/preview_buy_with_asset_input.dart';
import '../model/preview_buy_with_circle_input.dart';
import '../model/preview_buy_with_unlimint_input.dart';
import '../notifier/currency_buy_notifier/currency_buy_notipod.dart';
import 'components/add_payment_bottom_sheet.dart';
import 'components/recurring_selector.dart';
import 'screens/preview_buy_with_asset.dart';
import 'screens/preview_buy_with_circle/preview_buy_with_circle/preview_buy_with_circle.dart';
import 'screens/preview_buy_with_unlimint.dart';
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
    final kycState = useProvider(kycNotipod);
    final kycAlertHandler = useProvider(
      kycAlertHandlerPod(context),
    );

    final unlimintIncludes = widget.currency.buyMethods.where(
      (element) => element.type == PaymentMethodType.unlimintCard,
    );
    final unlimintAltIncludes = widget.currency.buyMethods.where(
      (element) => element.type == PaymentMethodType.unlimintAlternative,
    );
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
    final cardType = state.selectedPaymentMethod?.type ==
        PaymentMethodType.circleCard || state.selectedPaymentMethod?.type ==
        PaymentMethodType.unlimintCard || state.selectedPaymentMethod?.type ==
        PaymentMethodType.simplex || state.selectedPaymentMethod?.type ==
        PaymentMethodType.unlimintAlternative;

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
            PaymentMethodType.unlimintCard && state.pickedUnlimintCard == null
          ) ...[
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
          if (state.selectedPaymentMethod?.type ==
            PaymentMethodType.unlimintAlternative &&
              state.pickedAltUnlimintCard == null
          ) ...[
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
                      color: (cardLimit.cardLimits?.barProgress == 100 ||
                          isLimitBlock)
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
                            unlimintIncludes.isNotEmpty) &&
                        !(state.unlimintAltCards.isNotEmpty &&
                            unlimintAltIncludes.isNotEmpty),
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
            if (!(state.unlimintCards.isNotEmpty &&
                unlimintIncludes.isNotEmpty) &&
                !(state.unlimintAltCards.isNotEmpty &&
                unlimintAltIncludes.isNotEmpty)) ...[
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
                      color: (cardLimit.cardLimits?.barProgress == 100 ||
                          isLimitBlock)
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
                    removeDivider: card.id == state.unlimintCards.last.id &&
                        !(state.unlimintAltCards.isNotEmpty &&
                        unlimintAltIncludes.isNotEmpty),
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
          if (state.unlimintAltCards.isNotEmpty &&
              unlimintAltIncludes.isNotEmpty) ...[
            for (final card in state.unlimintAltCards)
              Builder(
                builder: (context) {
                  final formatted = formattedCircleCard(
                    card,
                    state.baseCurrency!,
                  );

                  return SCreditCardItem(
                    lightDivider: true,
                    isSelected: state.pickedAltUnlimintCard?.id == card.id &&
                        state.selectedPaymentMethod?.type ==
                            PaymentMethodType.unlimintAlternative,
                    icon: SActionDepositIcon(
                      color: (cardLimit.cardLimits?.barProgress == 100 ||
                          isLimitBlock)
                          ? colors.grey2
                          : state.pickedAltUnlimintCard?.id == card.id &&
                            state.selectedPaymentMethod?.type ==
                              PaymentMethodType.unlimintAlternative
                          ? colors.blue
                          : colors.black,
                    ),
                    name: formatted.name,
                    amount: formatted.last4Digits,
                    helper: card.status == CircleCardStatus.pending
                      ? intl.paymentMethod_CardIsProcessing
                      : formatted.expDate,
                    description: '',
                    removeDivider: card.id == state.unlimintAltCards.last.id,
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
          if (widget.currency.buyMethods.isNotEmpty && !(
              widget.currency.buyMethods.length == 1 &&
              (state.selectedPaymentMethod?.type == PaymentMethodType.simplex ||
                (state.selectedPaymentMethod?.type ==
                PaymentMethodType.unlimintCard &&
                    state.unlimintCards.isEmpty) ||
                (state.selectedPaymentMethod?.type ==
                PaymentMethodType.unlimintAlternative &&
                    state.unlimintAltCards.isEmpty))
          )) ...[
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
                      notifier.onCircleCardAdded(card);
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
                (value == state.selectedPaymentMethod && value.type ==
                    PaymentMethodType.unlimintCard &&
                    state.pickedUnlimintCard != null) ||
                (value == state.selectedPaymentMethod && value.type ==
                    PaymentMethodType.unlimintAlternative &&
                    state.pickedAltUnlimintCard != null)) {
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
            if (value.integration == IntegrationType.unlimint) {
              notifier.updateSelectedUnlimintCard(value);
            } else if (value.integration == IntegrationType.unlimintAlt) {
              notifier.updateSelectedAltUnlimintCard(value);
            } else {
              notifier.updateSelectedCircleCard(value);
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
                          kycVerified: kycState,
                          isProgress: kycState.verificationInProgress,
                          currentNavigate: () {},
                          kycFlowOnly: true,
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
                    notifier.updateRecurringBuyType(selection);
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
                  color: (cardLimit.cardLimits?.barProgress == 100 ||
                    isLimitBlock)
                    ? colors.grey2
                      : colors.black,
                  ),
                  name: intl.curencyBuy_actionItemName,
                  description: limitText,
                  limit: isLimitBlock
                    ? 100
                    : cardLimit.cardLimits?.barProgress ?? 0,
                  onTap: () => _showAssetSelector(),
                )
              else if (state.selectedPaymentMethod?.type ==
                  PaymentMethodType.unlimintCard)
                if (state.pickedUnlimintCard != null)
                  SPaymentSelectCreditCard(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: SActionDepositIcon(
                      color: (cardLimit.cardLimits?.barProgress == 100 ||
                          isLimitBlock) ? colors.grey2 : colors.black,
                    ),
                    name: state.pickedUnlimintCard!.network,
                    amount: state.pickedUnlimintCard!.last4,
                    helper: limitText,
                    description: state.pickedUnlimintCard?.status ==
                        CircleCardStatus.pending
                        ? intl.paymentMethod_CardIsProcessing
                        : '${state.pickedUnlimintCard!.expMonth}/'
                        '${state.pickedUnlimintCard!.expYear}',
                    limit: isLimitBlock
                        ? 100
                        : cardLimit.cardLimits?.barProgress ?? 0,
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
                    name: intl.curencyBuy_unlimint,
                    description: limitText,
                    limit: isLimitBlock
                        ? 100
                        : cardLimit.cardLimits?.barProgress ?? 0,
                    onTap: () => _showAssetSelector(),
                  )
              else if (state.selectedPaymentMethod?.type ==
                  PaymentMethodType.unlimintAlternative)
                if (state.pickedAltUnlimintCard != null)
                  SPaymentSelectCreditCard(
                    widgetSize: widgetSizeFrom(deviceSize),
                    icon: SActionDepositIcon(
                      color: (cardLimit.cardLimits?.barProgress == 100 ||
                          isLimitBlock) ? colors.grey2 : colors.black,
                    ),
                    name: state.pickedAltUnlimintCard!.network,
                    amount: state.pickedAltUnlimintCard!.last4,
                    helper: limitText,
                    description: state.pickedAltUnlimintCard?.status ==
                        CircleCardStatus.pending
                        ? intl.paymentMethod_CardIsProcessing
                        : '${state.pickedAltUnlimintCard!.expMonth}/'
                        '${state.pickedAltUnlimintCard!.expYear}',
                    limit: isLimitBlock
                        ? 100
                        : cardLimit.cardLimits?.barProgress ?? 0,
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
                    name: intl.curencyBuy_unlimint,
                    description: limitText,
                    limit: isLimitBlock
                        ? 100
                        : cardLimit.cardLimits?.barProgress ?? 0,
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
                    !(cardType &&
                        cardLimit.cardLimits?.barProgress == 100) &&
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
                    navigatorPush(
                      context,
                      PreviewBuyWithUnlimint(
                        input: PreviewBuyWithUnlimintInput(
                          amount: state.inputValue,
                          currency: widget.currency,
                          card: state.pickedUnlimintCard,
                        ),
                      ),
                    );
                  } else if (state.selectedPaymentMethod?.type ==
                      PaymentMethodType.unlimintAlternative) {
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
                      PreviewBuyWithUnlimint(
                        input: PreviewBuyWithUnlimintInput(
                          amount: state.inputValue,
                          currency: widget.currency,
                          card: state.pickedAltUnlimintCard,
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
