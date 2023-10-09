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
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

@RoutePage()
class BuyAmountScreen extends StatelessWidget {
  const BuyAmountScreen({
    super.key,
    required this.asset,
    this.method,
    this.card,
    this.cardNumber,
    this.cardId,
    this.account,
    this.showUaAlert = false,
  });

  final CurrencyModel asset;

  final BuyMethodDto? method;
  final CircleCard? card;
  final SimpleBankingAccount? account;

  final String? cardNumber;
  final String? cardId;

  final bool showUaAlert;

  @override
  Widget build(BuildContext context) {
    return Provider<BuyAmountStore>(
      create: (context) => BuyAmountStore()..init(asset, method, card, showUaAlert),
      builder: (context, child) => _BuyAmountScreenBody(
        asset: asset,
        method: method,
        card: card,
      ),
    );
  }
}

class _BuyAmountScreenBody extends StatefulObserverWidget {
  const _BuyAmountScreenBody({
    required this.asset,
    this.method,
    this.card,
  });

  final CurrencyModel asset;

  final BuyMethodDto? method;
  final CircleCard? card;

  @override
  State<_BuyAmountScreenBody> createState() => _BuyAmountScreenBodyState();
}

class _BuyAmountScreenBodyState extends State<_BuyAmountScreenBody> with TickerProviderStateMixin {
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
          decimal: amount,
          symbol: store.buyCurrency.symbol,
          accuracy: store.buyCurrency.accuracy,
          onlyFullPart: true,
        )} / ${volumeFormat(
          decimal: limit,
          symbol: store.buyCurrency.symbol,
          accuracy: store.buyCurrency.accuracy,
          onlyFullPart: true,
        )}';
      }

      return '';
    }

    final limitText = store.limitByAsset != null
        ? '''${(store.limitByAsset!.barInterval == StateBarType.day1 || store.limitByAsset!.day1State == StateLimitType.block) ? intl.paymentMethodsSheet_daily : (store.limitByAsset!.barInterval == StateBarType.day7 || store.limitByAsset!.day7State == StateLimitType.block) ? intl.paymentMethodsSheet_weekly : intl.paymentMethodsSheet_monthly} ${intl.paymentMethodsSheet_limit}'''
            ': ${checkLimitText()}'
        : '';

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
                    tabs: const [
                      Tab(
                        text: 'Buy',
                      ),
                      Tab(
                        text: 'Sell',
                      ),
                      Tab(
                        text: 'Convert',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SpaceH40(),
          Row(
            children: [
              Baseline(
                baseline: deviceSize.when(
                  small: () => 32,
                  medium: () => 31,
                ),
                baselineType: TextBaseline.alphabetic,
                child: SNewActionPriceField(
                  widgetSize: widgetSizeFrom(deviceSize),
                  price: formatCurrencyStringAmount(
                    value: store.inputValue,
                    symbol: store.buyCurrency.symbol,
                  ),
                  helper: formatCurrencyStringAmount(
                    value: store.targetConversionValue,
                    symbol: widget.asset.symbol,
                  ),
                  error: store.inputErrorValue,
                  isErrorActive: store.isInputErrorActive,
                ),
              ),
              const Spacer(),
              SIconButton(
                onTap: () {},
                defaultIcon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.grey5,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  margin: const EdgeInsets.only(right: 27),
                  child: Icon(
                    Icons.swap_vert,
                    color: colors.black,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (kycState.withdrawalStatus != kycOperationStatus(KycStatus.allowed)) ...[
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
          BuyAssetWidget(
            icon: store.asset?.iconUrl ?? '',
          ),
          const SpaceH8(),
          const PayWithWidget(),
          const SpaceH20(),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            showPresets: false,
            preset1Name: '',
            preset2Name: '',
            preset3Name: '',
            selectedPreset: null,
            onPresetChanged: (preset) {},
            onKeyPressed: (value) {
              store.updateInputValue(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: store.inputValid && !store.disableSubmit && !(double.parse(store.inputValue) == 0.0),
            submitButtonName: intl.addCircleCard_continue,
            onSubmitPressed: () {
              sRouter.push(
                BuyConfirmationRoute(
                  asset: widget.asset,
                  paymentCurrency: store.buyCurrency,
                  amount: store.inputValue,
                  method: widget.method,
                  card: widget.card,
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

class BuyAssetWidget extends StatelessWidget {
  const BuyAssetWidget({super.key, required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      width: double.infinity,
      height: 56,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 24),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: colors.grey5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SNetworkSvg24(
            url: icon,
          ),
          const SpaceW8(),
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buy',
                style: TextStyle(
                  color: Color(0xFF777C85),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Bitcoin',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            '0.033 BTC',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFF777C85),
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SpaceW8(),
          SizedBox(
            width: 20,
            height: 20,
            child: SBlueRightArrowIcon(
              color: colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class PayWithWidget extends StatelessWidget {
  const PayWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Container(
      width: double.infinity,
      height: 56,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 24),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: colors.grey5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Container(
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
          const SpaceW8(),
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pay with',
                style: TextStyle(
                  color: Color(0xFF777C85),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Account 1',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            '1 545 EUR',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFF777C85),
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SpaceW8(),
          SizedBox(
            width: 20,
            height: 20,
            child: SBlueRightArrowIcon(
              color: colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
