import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class RewardShareCard extends StatelessWidget {
  const RewardShareCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 24,
          right: 24,
          bottom: 28,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment(-1.0, -3.0),
            end: Alignment(1.0, 3.0),
            colors: [
              Color(0xFFEFFBE0),
              Color(0xFFBEF276),
              Color(0x00E4F9E6),
            ],
          ),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              intl.rewards_flow_card_title,
              style: sTextH3Style,
              maxLines: 6,
            ),
            const SpaceH16(),
            Text(
              intl.rewards_flow_card_subtitle,
              style: sBodyText1Style,
              maxLines: 6,
            ),
            const SpaceH32(),
            Text(
              intl.rewards_flow_copy_link,
              style: sSubtitle3Style,
            ),
            const SpaceH7(),
            Container(
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
                'https://simple.app/share/07dfjasdjnasjdnasndnjsa',
                style: sBodyText1Style.copyWith(
                  color: sKit.colors.grey1,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SpaceH24(),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const SMailIcon(),
                ),
                const SpaceW24(),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const SCopyIcon(
                    color: Colors.white,
                  ),
                ),
                const SpaceW24(),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const SShareIcon(
                    color: Colors.white,
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
