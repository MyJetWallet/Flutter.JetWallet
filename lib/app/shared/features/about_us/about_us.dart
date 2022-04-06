import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/launch_url.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';

class AboutUs extends HookWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SPageFrameWithPadding(
      header: SSmallHeader(
        title: 'About us',
        onBackButtonTap: () => Navigator.pop(context),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Baseline(
            baseline: 60,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              'At Simple, we see investing differently.',
              maxLines: 3,
              style: sTextH2Style,
            ),
          ),
          Baseline(
            baselineType: TextBaseline.alphabetic,
            baseline: 48,
            child: Text(
              'Today’s financial system is complex, '
              'exclusive and expensive - making it hard to '
              'gain access, get lower fees and preferential '
              'treatment. We believe that the financial '
              'system should work for everyone!',
              maxLines: 6,
              style: sBodyText1Style,
            ),
          ),
          Baseline(
            baselineType: TextBaseline.alphabetic,
            baseline: 48,
            child: Text(
              'We’re building a product that reimagines '
              'what it means to invest, simplifies the '
              'access and breaks down these complex '
              'barriers and fees. Its an easy to use financial '
              'product that empowers you to see new '
              'possibilities for your money and puts your '
              'money in motion!',
              maxLines: 8,
              style: sBodyText1Style,
            ),
          ),
          Baseline(
            baseline: 48,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              'We will launch with simple but innovative '
              'cryptocurrency trading and while you are '
              'trading, our team will be working hard to put '
              'the finishing touches on our community '
              'driven trade-everything platform to offer '
              'you stocks, commodities, as well as social '
              'payments. All in one simple to use '
              'application. Its what we call, finance made '
              'SIMPLE.',
              maxLines: 10,
              style: sBodyText1Style,
            ),
          ),
          const SpaceH30(),
          Row(
            children: [
              SimpleAccountTermButton(
                name: 'General Terms and Conditions',
                onTap: () => launchURL(context, userAgreementLink),
              ),
            ],
          ),
          const SpaceH20(),
          Row(
            children: [
              SimpleAccountTermButton(
                name: 'Privacy Policy',
                onTap: () => launchURL(context, privacyPolicyLink),
              ),
            ],
          ),
          const SpaceH20(),
          Row(
            children: [
              SimpleAccountTermButton(
                name: 'Referral Policy',
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
