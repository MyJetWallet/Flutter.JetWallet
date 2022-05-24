import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/launch_url.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';

class AboutUs extends HookWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return SPageFrameWithPadding(
      header: SSmallHeader(
        title: intl.account_aboutUs,
        onBackButtonTap: () => Navigator.pop(context),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Baseline(
            baseline: 60,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              intl.aboutUs_text1,
              maxLines: 3,
              style: sTextH2Style,
            ),
          ),
          Baseline(
            baselineType: TextBaseline.alphabetic,
            baseline: 48,
            child: Text(
              intl.aboutUs_text2,
              maxLines: 6,
              style: sBodyText1Style,
            ),
          ),
          Baseline(
            baselineType: TextBaseline.alphabetic,
            baseline: 48,
            child: Text(
              intl.aboutUs_text3,
              maxLines: 8,
              style: sBodyText1Style,
            ),
          ),
          Baseline(
            baseline: 48,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              intl.aboutUs_text4,
              maxLines: 10,
              style: sBodyText1Style,
            ),
          ),
          const SpaceH30(),
          Row(
            children: [
              SimpleAccountTermButton(
                name: intl.aboutUs_termButton1,
                onTap: () => launchURL(context, userAgreementLink),
              ),
            ],
          ),
          const SpaceH20(),
          Row(
            children: [
              SimpleAccountTermButton(
                name: intl.aboutUs_privacyPolicy,
                onTap: () => launchURL(context, privacyPolicyLink),
              ),
            ],
          ),
          const SpaceH20(),
          Row(
            children: [
              SimpleAccountTermButton(
                name: intl.aboutUs_termButton3,
                onTap: () => launchURL(context, referralPolicyLink),
              ),
            ],
          ),
          const SpaceH60(),
        ],
      ),
    );
  }
}
