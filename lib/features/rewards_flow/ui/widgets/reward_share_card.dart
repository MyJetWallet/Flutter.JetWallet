import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logs/helpers/encode_query_parameters.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class RewardShareCard extends StatefulObserverWidget {
  const RewardShareCard({super.key});

  @override
  State<RewardShareCard> createState() => _RewardShareCardState();
}

class _RewardShareCardState extends State<RewardShareCard> {
  late FlipCardController controller;

  late Timer timer;

  Duration animationDuration = const Duration(seconds: 3);
  Duration delayedDuration = const Duration(seconds: 4);

  @override
  void initState() {
    controller = FlipCardController();

    timer = Timer.periodic(animationDuration, (timer) async {
      await controller.flipcard();
      await Future.delayed(delayedDuration);
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(
      Image.asset(simpleRewardCardFront).image,
      context,
    );
    precacheImage(
      Image.asset(simpleRewardCardRevers).image,
      context,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shareText = "${intl.reward_share_main_text}\n\n${sSignalRModules.rewardsData?.referralLink ?? ''}";

    return SPaddingH24(
      child: Container(
        padding: const EdgeInsets.only(
          top: 12,
          left: 24,
          right: 24,
          bottom: 28,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            transform: GradientRotation(-0.1),
            stops: [0.3, 1.5],
            colors: [Color(0xD8E8E1FF), Color(0xD89E7DFF)],
          ),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceH8(),
            Text(
              sSignalRModules.rewardsData?.titleText ?? '',
              style: sTextH4Style,
              maxLines: 6,
            ),
            const SpaceH16(),
            Text(
              sSignalRModules.rewardsData?.descriptionText ?? '',
              style: sBodyText1Style,
              maxLines: 6,
            ),
            Stack(
              children: [
                Positioned(
                  right: 35,
                  top: 20,
                  width: 48,
                  height: 40,
                  child: SvgPicture.asset(
                    simpleGlitter,
                  ),
                ),
                SizedBox(
                  height: 288,
                  child: Center(
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(0.0)
                        ..rotateZ(0.09),
                      child: FlipCard(
                        rotateSide: RotateSide.right,
                        controller: controller,
                        animationDuration: animationDuration,
                        frontWidget: Image.asset(
                          simpleRewardCardFront,
                          width: 168.89,
                          height: 213.33,
                        ),
                        backWidget: Image.asset(
                          simpleRewardCardRevers,
                          width: 168.89,
                          height: 213.33,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SpaceH32(),
            Text(
              intl.rewards_flow_copy_link,
              style: sSubtitle3Style,
            ),
            const SpaceH7(),
            InkWell(
              onTap: () {
                sAnalytics.rewardsClickShare();

                Clipboard.setData(
                  ClipboardData(
                    text: shareText,
                  ),
                );

                sNotification.showError(
                  intl.copy_message,
                  id: 1,
                  isError: false,
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Text(
                  sSignalRModules.rewardsData?.referralLink ?? '',
                  style: sBodyText1Style.copyWith(
                    color: sKit.colors.grey1,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            const SpaceH24(),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    sAnalytics.rewardsClickShare();

                    final emailLaunchUri = Uri(
                      scheme: 'mailto',
                      query: encodeQueryParameters({
                        'subject': intl.reward_email_subject,
                        'body': shareText,
                      }),
                    );

                    launchUrl(emailLaunchUri);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const SMail2Icon(),
                  ),
                ),
                const SpaceW24(),
                InkWell(
                  onTap: () {
                    sAnalytics.rewardsClickShare();

                    Clipboard.setData(
                      ClipboardData(
                        text: shareText,
                      ),
                    );

                    sNotification.showError(
                      intl.copy_message,
                      id: 1,
                      isError: false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const SCopyIcon(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SpaceW24(),
                InkWell(
                  onTap: () async {
                    sAnalytics.rewardsClickShare();

                    await Share.share(shareText);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const SShareIcon(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
