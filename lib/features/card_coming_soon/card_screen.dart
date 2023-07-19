import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:event_bus/event_bus.dart';
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
import '../../utils/event_bus_events.dart';
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
  ScrollController controller = ScrollController();
  final loader = StackLoaderStore();
  late bool isButtonActive;

  @override
  void initState() {
    super.initState();
    isButtonActive = true;
    _controllerConfetti =
        ConfettiController(duration: const Duration(milliseconds: 200));
    getIt<EventBus>().on<ResetScrollCard>().listen((event) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    });
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
    final fullName = '${userInfo.firstName} ${userInfo.lastName}'
        .toUpperCase();
    final shortName = '${userInfo.firstName} ${userInfo.lastName[0]}.'
        .toUpperCase();

    final kycPassed = checkKycPassed(
      kycState.depositStatus,
      kycState.sellStatus,
      kycState.withdrawalStatus,
    );
    final size = widgetSizeFrom(deviceSize) == SWidgetSize.small
        ? MediaQuery.of(context).size.width * 0.6
        : MediaQuery.of(context).size.width;
    final sizeHeight = (size - 48) * 0.54;
    final sizeWidth = (size - 48) * 0.855;

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      loading: loader,
      header: const CardHeader(),
      child: SingleChildScrollView(
        controller: controller,
        child: SPaddingH24(
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        if (widgetSizeFrom(deviceSize) != SWidgetSize.small)
                          const SpaceH42(),
                        Stack(
                          children: [
                            Image.asset(
                              simpleCardAsset,
                              width: size,
                            ),
                            Positioned(
                              left: 24,
                              bottom: 80,
                              child: Transform.rotate(
                                angle: -pi / 4,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: sizeWidth,
                                      height: sizeHeight,
                                    ),
                                    Positioned(
                                      bottom: 24,
                                      left: 24,
                                      child: Text(
                                        fullName.length > 21 ? shortName : fullName,
                                        style: sTextH5Style.copyWith(
                                          color: colors.white,
                                          height: 1,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                            active: isButtonActive,
                            name: intl.card_claim_card,
                            onTap: () async {
                              setState(() {
                                isButtonActive = false;
                              });
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
                                setState(() {
                                  isButtonActive = true;
                                });
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
                                    setState(() {
                                      isButtonActive = true;
                                    });
                                  } else {
                                    _controllerConfetti.play();
                                    Timer(const Duration(seconds: 1), () {
                                      sUserInfo.updateCardRequested(newValue: true);
                                      setState(() {
                                        isButtonActive = true;
                                      });
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
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _controllerConfetti,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.01,
                  numberOfParticles: 100,
                  gravity: 0.01,
                  shouldLoop: false,
                  colors: [
                    colors.confetti1,
                    colors.confetti2,
                    colors.confetti3,
                    colors.confetti4,
                    colors.confetti5,
                    colors.confetti6,
                    colors.confetti7,
                    colors.confetti8,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
