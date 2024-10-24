import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';

import '../../core/di/di.dart';
import '../../core/l10n/i10n.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/simple_networking/simple_networking.dart';
import '../../utils/constants.dart';
import '../../utils/event_bus_events.dart';

@RoutePage(name: 'CardRouter')
class CardScreen extends StatefulObserverWidget {
  const CardScreen({
    super.key,
  });

  @override
  State<CardScreen> createState() => _CardScreenBodyState();
}

class _CardScreenBodyState extends State<CardScreen> {
  late ConfettiController _controllerConfetti;
  ScrollController controller = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _controllerConfetti = ConfettiController(duration: const Duration(milliseconds: 200));
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
    final userInfo = sUserInfo;

    final colors = SColorsLight();

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: const GlobalBasicAppBar(
        hasLeftIcon: false,
        hasRightIcon: false,
      ),
      child: Stack(
        children: [
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            controller: controller,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Image.asset(
                          preorderCardAsset,
                        ),
                      ),
                      Text(
                        intl.card_header,
                        maxLines: 2,
                        style: STStyles.header5,
                      ),
                      const SpaceH12(),
                      if (userInfo.cardRequested) ...[
                        Text(
                          intl.card_preorder_joibed_description,
                          maxLines: 3,
                          style: STStyles.subtitle2.copyWith(
                            color: colors.gray10,
                          ),
                        ),
                      ] else ...[
                        Text(
                          intl.card_preorder_join_description,
                          maxLines: 4,
                          style: STStyles.subtitle2,
                        ),
                        const SpaceH8(),
                        Text(
                          intl.card_preorder_highlights,
                          maxLines: 4,
                          style: STStyles.subtitle2,
                        ),
                        const SpaceH12(),
                        OneColumnCell(
                          icon: Assets.svg.small.check,
                          text: intl.card_preorder_highlight_1,
                          needHorizontalPading: false,
                        ),
                        OneColumnCell(
                          icon: Assets.svg.small.check,
                          text: intl.card_preorder_highlight_2,
                          needHorizontalPading: false,
                        ),
                        OneColumnCell(
                          icon: Assets.svg.small.check,
                          text: intl.card_preorder_highlight_3,
                          needHorizontalPading: false,
                        ),
                        OneColumnCell(
                          icon: Assets.svg.small.check,
                          text: intl.card_preorder_highlight_4,
                          needHorizontalPading: false,
                        ),
                      ],
                      const SpaceH120(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: SButton.black(
                text: intl.join_the_waitlist,
                callback: !userInfo.cardRequested ? onTap : null,
                isLoading: isLoading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onTap() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await sNetwork.getWalletModule().postCardSoon();

      if (response.error != null) {
        sNotification.showError(
          response.error!.cause,
          id: 1,
        );
      } else {
        _controllerConfetti.play();
        Timer(const Duration(microseconds: 100), () {
          sUserInfo.updateCardRequested(
            newValue: true,
          );

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
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
