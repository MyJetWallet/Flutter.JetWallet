import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/card_coming_soon/widgets/card_header.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../core/di/di.dart';
import '../../core/l10n/i10n.dart';
import '../../core/services/device_size/device_size.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/simple_networking/simple_networking.dart';
import '../../utils/constants.dart';
import '../../utils/helpers/check_kyc_status.dart';
import '../../utils/helpers/widget_size_from.dart';
import '../kyc/helper/kyc_alert_handler.dart';
import '../kyc/kyc_service.dart';
import '../kyc/models/kyc_operation_status_model.dart';

@RoutePage(name: 'CardRouter')
class CardScreen extends StatefulObserverWidget {
  const CardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CardScreen> createState() => _CardScreenBodyState();
}

class _CardScreenBodyState extends State<CardScreen> {
  late ConfettiController _controllerConfetti;
  final loader = StackLoaderStore();

  @override
  void initState() {
    super.initState();
    _controllerConfetti =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controllerConfetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();
    final userInfo = sUserInfo;

    final colors = sKit.colors;
    final deviceSize = sDeviceSize;

    final kycPassed = checkKycPassed(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );
    final size = widgetSizeFrom(deviceSize) == SWidgetSize.small
        ? MediaQuery.of(context).size.width * 0.6
        : MediaQuery.of(context).size.width;

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      loading: loader,
      header: const CardHeader(),
      child: SPaddingH24(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    if (widgetSizeFrom(deviceSize) != SWidgetSize.small)
                      const SpaceH42(),
                    Image.asset(
                      simpleCardAsset,
                      width: size,
                    ),
                    if (widgetSizeFrom(deviceSize) != SWidgetSize.small)
                      const SpaceH34()
                    else
                      const SpaceH20(),
                    if (!userInfo.cardRequested) ...[
                      Text(
                        intl.card_main_text,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: sTextH5Style.copyWith(
                          color: colors.black,
                        ),
                      ),
                      const SpaceH8(),
                      Text(
                        intl.card_description,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: sBodyText1Style.copyWith(
                          color: colors.grey1,
                        ),
                      ),
                    ] else ...[
                      Text(
                        intl.card_making_desc,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: sBodyText1Style.copyWith(
                          color: colors.grey1,
                        ),
                      ),
                    ],
                  ],
                ),
                if (!userInfo.cardRequested)
                  Column(
                    children: [
                      SPrimaryButton4(
                        active: true,
                        name: intl.card_claim_card,
                        onTap: () async {
                          if (!kycPassed) {
                            sShowAlertPopup(
                              context,
                              primaryText: '',
                              secondaryText: intl.card_verify,
                              primaryButtonName: intl.card_proceed,
                              image: Image.asset(
                                infoLightAsset,
                                height: 80,
                                width: 80,
                                package: 'simple_kit',
                              ),
                              onPrimaryButtonTap: () {
                                Navigator.pop(context);
                                final isDepositAllow = kycState.depositStatus !=
                                    kycOperationStatus(KycStatus.allowed);
                                final isWithdrawalAllow = kycState.withdrawalStatus !=
                                    kycOperationStatus(KycStatus.allowed);

                                kycAlertHandler.handle(
                                  status: isDepositAllow
                                      ? kycState.depositStatus
                                      : isWithdrawalAllow
                                      ? kycState.withdrawalStatus
                                      : kycState.sellStatus,
                                  isProgress: kycState.verificationInProgress,
                                  currentNavigate: () {},
                                  requiredDocuments: kycState.requiredDocuments,
                                  requiredVerifications:
                                  kycState.requiredVerifications,
                                );
                              },
                              secondaryButtonName: intl.card_cancel,
                              onSecondaryButtonTap: () {
                                Navigator.pop(context);
                              },
                            );
                          } else {
                            loader.startLoading();
                            try {
                              final response =
                              await sNetwork.getWalletModule().postCardSoon();

                              loader.finishLoadingImmediately();
                              loader.finishLoading();
                              if (response.error != null) {
                                sNotification.showError(
                                  response.error!.cause,
                                  id: 1,
                                );
                              } else {
                                _controllerConfetti.play();
                                Timer(const Duration(seconds: 2), () {
                                  sUserInfo.updateCardRequested(newValue: true);
                                  sShowAlertPopup(
                                    context,
                                    primaryText: intl.card_congrats,
                                    secondaryText: intl.card_congrats_desc,
                                    primaryButtonName: intl.card_got_it,
                                    image: Image.asset(
                                      congratsAsset,
                                      height: 80,
                                      width: 80,
                                      package: 'simple_kit',
                                    ),
                                    onPrimaryButtonTap: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                              }
                            } catch (e) {
                              loader.finishLoadingImmediately();
                              loader.finishLoading();
                              sNotification.showError(
                                intl.something_went_wrong_try_again2,
                                duration: 4,
                                id: 1,
                                needFeedback: true,
                              );
                            }
                          }
                        },
                      ),
                      const SpaceH24(),
                    ],
                  )
                else
                  const SpaceH56(),
              ],
            ),
            Align(
              child: ConfettiWidget(
                confettiController: _controllerConfetti,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.01,
                numberOfParticles: 100,
                gravity: 0.01,
                colors: [
                  colors.blueLight2,
                  colors.greenLight,
                  colors.greenLight2,
                  colors.aquaGreen,
                  colors.violetLight,
                  colors.brownLight,
                  colors.yellowLight,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
