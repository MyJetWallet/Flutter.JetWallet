import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logs/helpers/encode_query_parameters.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class RewardShareCard extends StatelessObserverWidget {
  const RewardShareCard({super.key});

  @override
  Widget build(BuildContext context) {
    final shareText = "${intl.reward_share_main_text}\n\n${sSignalRModules.rewardsData?.referralLink ?? ''}";

    return SPaddingH24(
      child: Container(
        padding: const EdgeInsets.only(
          top: 12,
          left: 24,
          right: 12,
          bottom: 28,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment(1.0, 3.0),
            end: Alignment(-1.0, -3.0),
            colors: [
              Color(0xFFEFFBE0),
              Color(0xFFBEF276),
              Color(0x00E4F9E6),
            ],
          ),
        ),
        width: double.infinity,
        child: Stack(
          children: [
            const Positioned(
              right: 12,
              top: 12,
              width: 48,
              height: 40,
              child: SStarsIcon(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceH8(),
                  Text(
                    sSignalRModules.rewardsData?.titleText ?? '',
                    style: sTextH3Style,
                    maxLines: 6,
                  ),
                  const SpaceH16(),
                  Text(
                    sSignalRModules.rewardsData?.descriptionText ?? '',
                    style: sBodyText1Style,
                    maxLines: 6,
                  ),
                  const SpaceH32(),
                  Text(
                    intl.rewards_flow_copy_link,
                    style: sSubtitle3Style,
                  ),
                  const SpaceH7(),
                  InkWell(
                    onTap: () {
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
          ],
        ),
      ),
    );
  }
}
