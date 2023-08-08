import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/send_gift/gift_model.dart';

import '../../../utils/constants.dart';
import '../../core/di/di.dart';
import '../../core/router/app_router.dart';
import '../market/market_details/helper/currency_from.dart';

void receiveGiftBottomSheet({
  required BuildContext context,
  required GiftModel giftModel,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    horizontalPinnedPadding: 24,
    pinned: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 24),
        Text(
          'Claim',
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
  );
}

class _ReceiveGiftBottomSheet extends StatelessWidget {
  const _ReceiveGiftBottomSheet(this.giftModel);

  final GiftModel giftModel;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      giftModel.assetSymbol ?? '',
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
                      fit: BoxFit.none,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          SNetworkSvg24(
                            url: currency.iconUrl,
                            color: sKit.colors.white,
                          ),
                          Text(
                            giftModel.assetSymbol ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w600,
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
                        fit: BoxFit.none,
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
            'Gift from ${giftModel.fromName}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          const SpaceH8(),
          Text(
            '''A gift of ${giftModel.amount} ${giftModel.assetSymbol} from ${giftModel.fromName} \nis waiting for you''',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF777C85),
              fontSize: 16,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          const SpaceH49(),
          SPrimaryButton2(
            active: true,
            name: 'Claim',
            onTap: () async {
              final loading = StackLoaderStore()..startLoadingImmediately();
              unawaited(sRouter.push(ProgressRouter(loading: loading)));
              try {
                await getIt
                    .get<SNetwork>()
                    .simpleNetworking
                    .getWalletModule()
                    .acceptGift(giftModel.id as String);
                await sRouter.pop();
                unawaited(showSuccessScreen(currency));
              } on ServerRejectException catch (error) {
                unawaited(showFailureScreen(error.cause));
              } catch (error) {
                unawaited(showFailureScreen(intl.something_went_wrong));
              }
            },
          ),
          const SpaceH10(),
          STextButton1(
            active: true,
            name: 'Reject',
            onTap: () async {
              showAlert(context);
            },
          ),
          const SpaceH37(),
        ],
      ),
    );
  }

  Future<void> showSuccessScreen(CurrencyModel currency) {
    return sRouter
        .push(
      SuccessScreenRouter(
        primaryText: intl.successScreen_success,
        secondaryText: '${volumeFormat(
          prefix: currency.prefixSymbol,
          decimal: giftModel.amount ?? Decimal.zero,
          accuracy: currency.accuracy,
          symbol: currency.symbol,
        )} were credited to My Assets!',
        showProgressBar: true,
      ),
    )
        .then(
      (value) async {
        await sRouter.pop();
      },
    );
  }

  Future<void> showFailureScreen(String error) {
    return sRouter.push(
      FailureScreenRouter(
        primaryText: intl.previewBuyWithAsset_failure,
        secondaryText: error,
        primaryButtonName: intl.previewBuyWithAsset_close,
        onPrimaryButtonTap: () {
          sRouter.popUntilRoot();
        },
      ),
    );
  }

  void showAlert(BuildContext context) {
    sShowAlertPopup(
      context,
      primaryText: 'Reject?',
      secondaryText: 'Are you sure you want to reject the gift?',
      primaryButtonName: 'Yes, reject',
      secondaryButtonName: intl.gift_history_no,
      primaryButtonType: SButtonType.primary3,
      onPrimaryButtonTap: () async {
        await getIt
            .get<SNetwork>()
            .simpleNetworking
            .getWalletModule()
            .declineGift(giftModel.id as String);
        await sRouter.pop();
        await sRouter.pop();
      },
      onSecondaryButtonTap: () => Navigator.pop(context),
    );
  }
}
