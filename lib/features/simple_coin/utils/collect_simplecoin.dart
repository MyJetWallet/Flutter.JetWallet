import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/smpl_wallet_model.dart';

class ClaimSimplecoin {
  static final List<SmplRequestModel> _alredyShowedSimpleCoinRequests = [];

  static final Set<SmplRequestModel> _querySimpleCoinRequests = {};

  static bool isPopUpAlredyShoving = false;

  Future<void> pushCollectSimplecoinDialog({required List<SmplRequestModel> requests}) async {
    final isSimpleTapTokenAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
        .any((element) => element.id == AssetPaymentProductsEnum.simpleTapToken);

    if (!isSimpleTapTokenAvaible) return;

    for (final request in requests) {
      if (!_alredyShowedSimpleCoinRequests.any((showedRequest) => showedRequest.id == request.id)) {
        _querySimpleCoinRequests.addAll(requests);
      }
    }

    if (_querySimpleCoinRequests.isEmpty || isPopUpAlredyShoving) return;

    if (getIt.isRegistered<AppStore>() && getIt.get<AppStore>().authorizedStatus is Home) {
      final context = sRouter.navigatorKey.currentContext!;
      if (context.mounted) {
        await showCollectSimplecoinDialog(
          context: context,
        );
      }
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            final context = sRouter.navigatorKey.currentContext!;
            if (context.mounted) {
              await showCollectSimplecoinDialog(
                context: context,
              );
            }
          },
        ),
      );
    }
  }

  Future<void> showCollectSimplecoinDialog({
    required BuildContext context,
  }) async {
    final colors = SColorsLight();

    final amount = _querySimpleCoinRequests.fold(
      Decimal.zero,
      (prev, element) {
        return prev + element.amount;
      },
    );

    final formatedAmount = volumeFormat(
      decimal: amount,
      symbol: 'SMPL',
    );

    isPopUpAlredyShoving = true;

    await sShowAlertPopup(
      context,
      barrierDismissible: false,
      primaryText: intl.simplecoin_collect_simplecoin,
      secondaryText: intl.simplecoin_you_have_been_sent(formatedAmount),
      primaryButtonName: intl.simplecoin_collect_smpl(formatedAmount),
      secondaryButtonName: intl.simplecoin_decline,
      image: Image.asset(
        collectSmplAsset,
        width: 160,
        height: 136,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: SBannerBasic(
          text: '',
          icon: Assets.svg.small.warning,
          color: colors.yellowExtralight,
          corners: BannerCorners.rounded,
          customTextWidget: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${intl.simplecoin_by_clicking_collect} ',
                  style: STStyles.body2Medium.copyWith(
                    color: colors.black,
                  ),
                ),
                TextSpan(
                  text: intl.simplecoin_disclaimer,
                  style: STStyles.body2Medium.copyWith(
                    color: colors.black,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchURL(
                        context,
                        simpleCoinDisclaimerLink,
                      );
                    },
                ),
              ],
            ),
          ),
        ),
      ),
      onPrimaryButtonTap: () {
        collectCoins();
      },
      onSecondaryButtonTap: () {
        declineCoins();
      },
      onWillPop: () {
        isPopUpAlredyShoving = false;
      },
    );
  }

  Future<void> collectCoins() async {
    try {
      getIt.get<GlobalLoader>().setLoading(true);
      final ids = _querySimpleCoinRequests.map((request) => request.id).toList();
      final responce = await sNetwork.getWalletModule().postClaimSimplCoins(ids: ids);
      responce.pick(
        onNoError: (data) async {
          _alredyShowedSimpleCoinRequests.addAll(_querySimpleCoinRequests);
          _querySimpleCoinRequests.clear();
          sRouter.popUntilRoot();

          unawaited(sRouter.push(const AccountRouter()));
          await Future.delayed(const Duration(milliseconds: 650));
          await sRouter.push(const MySimpleCoinsRouter());
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
            needFeedback: true,
          );
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
        needFeedback: true,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    } finally {
      getIt.get<GlobalLoader>().setLoading(false);
    }
  }

  Future<void> declineCoins() async {
    try {
      getIt.get<GlobalLoader>().setLoading(true);
      final ids = _querySimpleCoinRequests.map((request) => request.id).toList();
      final responce = await sNetwork.getWalletModule().postCancelSimplCoinsRequest(ids: ids);
      responce.pick(
        onNoError: (data) async {
          _alredyShowedSimpleCoinRequests.addAll(_querySimpleCoinRequests);
          _querySimpleCoinRequests.clear();
          await sRouter.maybePop();
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
            needFeedback: true,
          );
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
        needFeedback: true,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    } finally {
      getIt.get<GlobalLoader>().setLoading(false);
    }
  }
}
