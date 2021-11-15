import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/launch_url.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';

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
        children: [
          Text(
            'At Simple, we see \n'
            'investing differently.',
            style: sTextH2Style,
          ),
          const SpaceH20(),
          Text(
            'Today’s financial system is complex, \n'
            'exclusive and expensive - making it hard to \n'
            'gain access, get lower fees and preferential \n'
            'treatment. We believe that the financial \n'
            'system should work for everyone!',
            style: sBodyText1Style,
          ),
          const SpaceH20(),
          Text(
            'We’re building a product that reimagines \n'
            'what it means to invest, simplifies the \n'
            'access and breaks down these complex \n'
            'barriers and fees. Its an easy to use financial \n'
            'product that empowers you to see new \n'
            'possibilities for your money and puts your \n'
            'money in motion!',
            style: sBodyText1Style,
          ),
          const SpaceH20(),
          Text(
            'We will launch with simple but innovative \n'
            'cryptocurrency trading and while you are \n'
            'trading, our team will be working hard to put \n'
            'the finishing touches on our community \n'
            'driven trade-everything platform to offer \n'
            'you stocks, commodities, as well as social \n'
            'payments. All in one simple to use \n'
            'application. Its what we call, finance made \n'
            'SIMPLE.',
            style: sBodyText1Style,
          ),
          const SpaceH30(),
          Row(
            children: [
              SimpleAccountTermButton(
                name: 'Terms of Use',
                onTap: () => launchURL(context, userAgreementLink),
              ),
              const Expanded(
                child: SizedBox(),
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
              const Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
