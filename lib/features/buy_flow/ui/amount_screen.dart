import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/buy_flow/store/amount_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

@RoutePage()
class BuyAmountScreen extends StatelessWidget {
  const BuyAmountScreen({
    super.key,
    required this.asset,
    required this.currency,
    this.method,
    this.card,
  });

  final CurrencyModel asset;
  final PaymentAsset currency;

  final BuyMethodDto? method;
  final CircleCard? card;

  @override
  Widget build(BuildContext context) {
    return Provider<BuyAmountStore>(
      create: (context) =>
          BuyAmountStore()..init(asset, currency, method, card),
      builder: (context, child) => _BuyAmountScreenBody(
        asset: asset,
        currency: currency,
        method: method,
      ),
    );
  }
}

class _BuyAmountScreenBody extends StatelessObserverWidget {
  const _BuyAmountScreenBody({
    super.key,
    required this.asset,
    required this.currency,
    this.method,
    this.card,
  });

  final CurrencyModel asset;
  final PaymentAsset currency;

  final BuyMethodDto? method;
  final CircleCard? card;

  @override
  Widget build(BuildContext context) {
    final store = BuyAmountStore.of(context);

    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    String checkLimitText() {
      var amount = Decimal.zero;
      var limit = Decimal.zero;
      if (store.asset != null && store.limitByAsset != null) {
        if (store.limitByAsset!.day1State == StateLimitType.block) {
          amount = store.limitByAsset!.day1Amount;
          limit = store.limitByAsset!.day1Limit;
        } else if (store.limitByAsset!.day7State == StateLimitType.block) {
          amount = store.limitByAsset!.day7Amount;
          limit = store.limitByAsset!.day7Limit;
        } else if (store.limitByAsset!.day30State == StateLimitType.block) {
          amount = store.limitByAsset!.day30Amount;
          limit = store.limitByAsset!.day30Limit;
        } else if (store.limitByAsset!.barInterval == StateBarType.day1) {
          amount = store.limitByAsset!.day1Amount;
          limit = store.limitByAsset!.day1Limit;
        } else if (store.limitByAsset!.barInterval == StateBarType.day7) {
          amount = store.limitByAsset!.day7Amount;
          limit = store.limitByAsset!.day7Limit;
        } else {
          amount = store.limitByAsset!.day30Amount;
          limit = store.limitByAsset!.day30Limit;
        }

        return '${volumeFormat(
          prefix: store.asset!.prefixSymbol,
          decimal: amount,
          symbol: store.asset!.symbol,
          accuracy: store.asset!.accuracy,
          onlyFullPart: true,
        )} / ${volumeFormat(
          prefix: store.asset!.prefixSymbol,
          decimal: limit,
          symbol: store.asset!.symbol,
          accuracy: store.asset!.accuracy,
          onlyFullPart: true,
        )}';
      }

      return '';
    }

    final limitText = store.limitByAsset != null
        ? '${(store.limitByAsset!.barInterval == StateBarType.day1 || store.limitByAsset!.day1State == StateLimitType.block) ? intl.paymentMethodsSheet_daily : (store.limitByAsset!.barInterval == StateBarType.day7 || store.limitByAsset!.day7State == StateLimitType.block) ? intl.paymentMethodsSheet_weekly : intl.paymentMethodsSheet_monthly} ${intl.paymentMethodsSheet_limit}'
            ': ${checkLimitText()}'
        : '';

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${intl.curencyBuy_buy} ${store.asset?.description}',
          onBackButtonTap: () => sRouter.pop(),
        ),
      ),
      child: Column(
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
                price: store.inputValue,
                helper: store.conversionText(store.buyCurrency),
                error: store.inputErrorValue,
                isErrorActive: store.isInputErrorActive,
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
                  primaryText: intl.actionBuy_alertPopupSecond,
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
          if (store.card != null) ...[
            SPaymentSelectCreditCard(
              widgetSize: widgetSizeFrom(deviceSize),
              icon: getNetworkIcon(store.card?.network),
              name: store.card?.cardLabel ?? '',
              description: limitText,
              limit: store.isLimitBlock
                  ? 100
                  : store.limitByAsset?.barProgress ?? 0,
              onTap: () => {},
            ),
          ],
          if (store.method != null) ...[
            SPaddingH24(
              child: InkWell(
                onTap: () {},
                highlightColor: sKit.colors.grey4,
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: Ink(
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: colors.grey4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SpaceW19(),
                          const SpaceW12(),
                          Flexible(
                            child: Baseline(
                              baseline: 18,
                              baselineType: TextBaseline.alphabetic,
                              child: Text(
                                '123123',
                                overflow: TextOverflow.ellipsis,
                                style: sSubtitle2Style,
                              ),
                            ),
                          ),
                          const SpaceW19(), // 1 px border
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH20(),
          ),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            preset1Name: store.preset1Name,
            preset2Name: store.preset2Name,
            preset3Name: store.preset3Name,
            selectedPreset: store.selectedPreset,
            onPresetChanged: (preset) {
              store.tapPreset(
                preset.index == 0
                    ? store.preset1Name
                    : preset.index == 1
                        ? store.preset2Name
                        : store.preset3Name,
              );
            },
            onKeyPressed: (value) {
              store.updateInputValue(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: true,
            submitButtonName: intl.addCircleCard_continue,
            onSubmitPressed: () {},
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
