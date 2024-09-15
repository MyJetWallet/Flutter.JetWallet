import 'dart:async';
import 'dart:math';

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
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/remote_config/models/rewards_asset_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/remote_config/remote_config_values.dart';
import '../../../../utils/formatting/formatting.dart';
import '../../../../utils/helpers/currency_from.dart';

const _imgWidth = 160.0;
const _imgHeight = 208.0;
const _iconSize = 48.0;

class RewardShareCard extends StatefulObserverWidget {
  const RewardShareCard({super.key});

  @override
  State<RewardShareCard> createState() => _RewardShareCardState();
}

class _RewardShareCardState extends State<RewardShareCard> {
  late FlipCardController controller;
  late Timer timer;
  RewardsAssetModel? asset;
  final Map<String, Widget> iconsMap = {};

  Duration animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    controller = FlipCardController();
    final localRewardsAssets = [...rewardsAssets];

    for (final element in sSignalRModules.currenciesList) {
      iconsMap.addAll({
        element.symbol: NetworkIconWidget(
          currencyFrom(
            sSignalRModules.currenciesList,
            element.symbol,
          ).iconUrl,
          width: _iconSize,
          height: _iconSize,
        ),
      });
    }

    if (localRewardsAssets.isNotEmpty) {
      final index = Random().nextInt(localRewardsAssets.length);
      asset = localRewardsAssets[index];
      localRewardsAssets.removeAt(index);
    }

    Future<void> flipCard() async {
      Timer(const Duration(seconds: 1), () async {
        await controller.flipcard();
      });

      await controller.flipcard().then((value) {
        if (localRewardsAssets.isNotEmpty) {
          final index = Random().nextInt(localRewardsAssets.length);

          setState(() {
            asset = localRewardsAssets[index];
          });

          localRewardsAssets.removeAt(index);

          if (localRewardsAssets.isEmpty) {
            localRewardsAssets.addAll(rewardsAssets);
          }
        }
      });
    }

    flipCard();

    timer = Timer.periodic(const Duration(seconds: 4), (timer) => flipCard());

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
    final currentAsset = asset;
    final icon = currentAsset != null && iconsMap[currentAsset.name] != null
        ? iconsMap[currentAsset.name]
        : Assets.svg.assets.crypto.defaultPlaceholderPurple.simpleSvg(
            width: _iconSize,
            height: _iconSize,
          );

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
                        backWidget: Stack(
                          children: [
                            Image.asset(
                              simpleRewardCardFront,
                              width: _imgWidth,
                              height: _imgHeight,
                            ),
                            Positioned(
                              top: 39,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(48),
                                      border: Border.all(
                                        color: SColorsLight().white,
                                        width: 4.33,
                                      ),
                                    ),
                                    child: icon,
                                  ),
                                ],
                              ),
                            ),
                            if (currentAsset != null)
                              Positioned(
                                top: 106,
                                left: 0,
                                right: 0,
                                child: Text(
                                  currentAsset.value.toFormatCount(
                                    symbol: currentAsset.name,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    height: 1.23,
                                    fontSize: 17.78,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w600,
                                    color: SColorsLight().white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        frontWidget: Image.asset(
                          simpleRewardCardRevers,
                          width: _imgWidth,
                          height: _imgHeight,
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
