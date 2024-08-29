import 'dart:async';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/currency_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/incoming_gift_model.dart';

import '../../../utils/constants.dart';
import '../../core/di/di.dart';
import '../../core/router/app_router.dart';
import '../app/store/models/authorized_union.dart';
import '../market/market_details/helper/currency_from.dart';

final List<IncomingGiftObject> alreadyShownGifts = [];

Future<void> pushReceiveGiftBottomSheet(
  IncomingGiftObject gift,
) async {
  if (getIt.isRegistered<AppStore>() && getIt.get<AppStore>().authorizedStatus is Home) {
    final context = sRouter.navigatorKey.currentContext!;
    if (context.mounted) {
      await receiveGiftBottomSheet(
        context: context,
        giftModel: gift,
      );
    }
  } else {
    getIt<RouteQueryService>().addToQuery(
      RouteQueryModel(
        func: () async {
          final context = sRouter.navigatorKey.currentContext!;
          if (context.mounted) {
            await receiveGiftBottomSheet(
              context: context,
              giftModel: gift,
            );
          }
        },
      ),
    );
  }
}

Future<void> receiveGiftBottomSheet({
  required BuildContext context,
  required IncomingGiftObject giftModel,
}) async {
  final currency = currencyFrom(
    sSignalRModules.currenciesList,
    giftModel.assetSymbol ?? '',
  );
  sAnalytics.claimGiftScreenView(
    giftAmount: (giftModel.amount ?? Decimal.zero).toFormatCount(
      accuracy: currency.accuracy,
      symbol: currency.symbol,
    ),
    giftFrom: giftModel.fromName ?? '',
  );
  sShowBasicModalBottomSheet(
    context: context,
    horizontalPinnedPadding: 24,
    pinned: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 24),
        Text(
          intl.reseive_gift_claim,
          style: sTextH5Style,
        ),
        SIconButton(
          onTap: () => Navigator.pop(context),
          defaultIcon: const SEraseIcon(),
          pressedIcon: const SErasePressedIcon(),
        ),
      ],
    ),
    children: [
      _ReceiveGiftBottomSheet(giftModel),
    ],
    then: (itsPostProcessing) {
      if (!(itsPostProcessing is bool && itsPostProcessing)) {
        sAnalytics.tapOnTheButtonCloseOrTapInEmptyPlaceForClosingClaimGiftSheet(
          giftAmount: (giftModel.amount ?? Decimal.zero).toFormatCount(
            accuracy: currency.accuracy,
            symbol: currency.symbol,
          ),
          giftFrom: giftModel.fromName ?? '',
        );
      }
    },
  );
}

class _ReceiveGiftBottomSheet extends StatelessWidget {
  const _ReceiveGiftBottomSheet(this.giftModel);

  final IncomingGiftObject giftModel;

  @override
  Widget build(BuildContext context) {
    final sColors = sKit.colors;

    final kyc = getIt.get<KycService>();
    final handler = getIt.get<KycAlertHandler>();

    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      giftModel.assetSymbol ?? '',
    );

    final giftAmount = (giftModel.amount ?? Decimal.zero).toFormatCount(
      accuracy: currency.accuracy,
      symbol: currency.symbol,
    );

    return SPaddingH24(
      child: Column(
        children: [
          Container(
            width: 327,
            height: 240,
            decoration: BoxDecoration(
              color: sKit.colors.grey5,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  SizedBox(
                    width: 327,
                    height: 240,
                    child: Image.asset(
                      shareGiftBackgroundAsset,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          NetworkIconWidget(
                            currency.iconUrl,
                          ),
                          const SpaceW4(),
                          Text(
                            giftAmount,
                            style: sTextH4Style.copyWith(
                              color: sColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Image.asset(
                        logoWithTitle,
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                        width: 104,
                        height: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SpaceH24(),
          Text(
            '${intl.reseive_gift_gift_from} ${giftModel.fromName}',
            textAlign: TextAlign.center,
            style: sTextH4Style.copyWith(
              color: sColors.black,
            ),
          ),
          const SpaceH8(),
          Text(
            '''${intl.reseive_gift_a_gift_of} $giftAmount ${intl.reseive_gift_from} ${giftModel.fromName} \n${intl.reseive_gift_is_waiting_for_you}''',
            textAlign: TextAlign.center,
            style: sBodyText1Style.copyWith(
              color: sColors.grey1,
            ),
          ),
          const SpaceH49(),
          SPrimaryButton2(
            active: true,
            name: intl.reseive_gift_claim,
            onTap: () async {
              sAnalytics.tapOnTheButtonClaimOnClaimGiftSheet(
                giftAmount: giftAmount,
                giftFrom: giftModel.fromName ?? '',
              );

              if (kyc.depositStatus == kycOperationStatus(KycStatus.allowed)) {
                await claim(currency, context);
              } else {
                handler.handle(
                  needGifteExplanationPopup: true,
                  status: kyc.depositStatus,
                  isProgress: kyc.verificationInProgress,
                  currentNavigate: () => claim(currency, context),
                  requiredDocuments: kyc.requiredDocuments,
                  requiredVerifications: kyc.requiredVerifications,
                );
              }
            },
          ),
          const SpaceH10(),
          STextButton1(
            active: true,
            name: intl.reseive_gift_reject_gift,
            onTap: () async {
              sAnalytics.tapOnTheButtonRejectOnClaimGiftSheet(
                giftAmount: giftAmount,
                giftFrom: giftModel.fromName ?? '',
              );
              showAlert(context);
            },
          ),
          const SpaceH37(),
        ],
      ),
    );
  }

  Future<void> claim(CurrencyModel currency, BuildContext context) async {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      giftModel.assetSymbol ?? '',
    );
    final giftAmount = (giftModel.amount ?? Decimal.zero).toFormatCount(
      accuracy: currency.accuracy,
      symbol: currency.symbol,
    );

    final loading = StackLoaderStore()..startLoadingImmediately();

    sAnalytics.processingClaimGiftScreenView(
      giftAmount: giftAmount,
      giftFrom: giftModel.fromName ?? '',
    );

    unawaited(sRouter.push(ProgressRouter(loading: loading)));
    try {
      await getIt.get<SNetwork>().simpleNetworking.getWalletModule().acceptGift(giftModel.id);

      await showSuccessScreen(currency);
    } on ServerRejectException catch (error) {
      await showFailureScreen(error.cause, context);
    } catch (error) {
      await showFailureScreen(intl.something_went_wrong, context);
    }
  }

  Future<void> showSuccessScreen(CurrencyModel currency) {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      giftModel.assetSymbol ?? '',
    );
    final giftAmount = (giftModel.amount ?? Decimal.zero).toFormatCount(
      accuracy: currency.accuracy,
      symbol: currency.symbol,
    );
    sAnalytics.successClaimedGiftScreenView(
      giftAmount: giftAmount,
      giftFrom: giftModel.fromName ?? '',
    );

    return sRouter.push(
      SuccessScreenRouter(
        secondaryText: '${(giftModel.amount ?? Decimal.zero).toFormatCount(
          accuracy: currency.accuracy,
          symbol: currency.symbol,
        )} ${intl.reseive_gift_were_credited_to_my_assets}',
        onSuccess: (context) {
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  Future<void> showFailureScreen(String error, BuildContext context) {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      giftModel.assetSymbol ?? '',
    );
    final giftAmount = (giftModel.amount ?? Decimal.zero).toFormatCount(
      accuracy: currency.accuracy,
      symbol: currency.symbol,
    );
    sAnalytics.failedClaimGiftScreenView(
      giftAmount: giftAmount,
      giftFrom: giftModel.fromName ?? '',
    );

    return sRouter.push(
      FailureScreenRouter(
        primaryText: intl.previewBuyWithAsset_failure,
        secondaryText: error,
        onPrimaryButtonTap: () {
          sAnalytics.tapOnTheButtonCloseOnFailedClaimGiftScreen(
            giftAmount: giftAmount,
            giftFrom: giftModel.fromName ?? '',
            failedReason: error,
          );
        },
      ),
    );
  }

  void showAlert(BuildContext context) {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      giftModel.assetSymbol ?? '',
    );
    final giftAmount = (giftModel.amount ?? Decimal.zero).toFormatCount(
      accuracy: currency.accuracy,
      symbol: currency.symbol,
    );
    sAnalytics.cancelClaimTransactionGiftScreenView(
      giftAmount: giftAmount,
      giftFrom: giftModel.fromName ?? '',
    );

    sShowAlertPopup(
      context,
      primaryText: intl.reseive_gift_reject,
      secondaryText: intl.reseive_gift_are_you_sure,
      primaryButtonName: intl.reseive_gift_yes_reject,
      secondaryButtonName: intl.gift_history_no,
      primaryButtonType: SButtonType.primary3,
      onPrimaryButtonTap: () async {
        sAnalytics.tapOnTheButtonYesCancelOnCancelClaimTransactionGiftPopup(
          giftAmount: giftAmount,
          giftFrom: giftModel.fromName ?? '',
        );

        await getIt.get<SNetwork>().simpleNetworking.getWalletModule().declineGift(giftModel.id).then(
          (value) {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          },
        );
      },
      onSecondaryButtonTap: () {
        sAnalytics.tapOnTheButtonNoOnCancelClaimTransactionGiftPopup(
          giftAmount: giftAmount,
          giftFrom: giftModel.fromName ?? '',
        );

        Navigator.pop(context, true);
      },
    );
  }
}
