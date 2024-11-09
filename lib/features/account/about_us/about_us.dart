import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

@RoutePage(name: 'AboutUsRouter')
class AboutUs extends StatelessObserverWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final isEarnAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
        .any((element) => element.id == AssetPaymentProductsEnum.earnProgram);

    final isJarAvaible = (sSignalRModules.assetProducts ?? <AssetPaymentProducts>[])
        .any((element) => element.id == AssetPaymentProductsEnum.jar);

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: GlobalBasicAppBar(
        title: intl.account_aboutUs,
        hasRightIcon: false,
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
          if (userAgreementLink.isNotEmpty) ...[
            Row(
              children: [
                SimpleAccountTermButton(
                  name: intl.aboutUs_termButton1,
                  onTap: () => launchURL(context, userAgreementLink),
                ),
              ],
            ),
            const SpaceH20(),
          ],
          if (privacyPolicyLink.isNotEmpty) ...[
            Row(
              children: [
                SimpleAccountTermButton(
                  name: intl.aboutUs_privacyPolicy,
                  onTap: () => launchURL(context, privacyPolicyLink),
                ),
              ],
            ),
            const SpaceH20(),
          ],
          if (referralPolicyLink.isNotEmpty) ...[
            Row(
              children: [
                SimpleAccountTermButton(
                  name: intl.aboutUs_termButton3,
                  onTap: () => launchURL(context, referralPolicyLink),
                ),
              ],
            ),
            const SpaceH20(),
          ],
          if (refundPolicyLink.isNotEmpty) ...[
            Row(
              children: [
                SimpleAccountTermButton(
                  name: intl.aboutUs_termButton5,
                  onTap: () => launchURL(context, refundPolicyLink),
                ),
              ],
            ),
            const SpaceH20(),
          ],
          if (amlKycPolicyLink.isNotEmpty) ...[
            Row(
              children: [
                SimpleAccountTermButton(
                  name: intl.aboutUs_termButton6,
                  onTap: () => launchURL(context, amlKycPolicyLink),
                ),
              ],
            ),
            const SpaceH20(),
          ],
          if (infoEarnLink.isNotEmpty && isEarnAvaible) ...[
            Row(
              children: [
                SimpleAccountTermButton(
                  name: intl.about_us_earn_program,
                  onTap: () => launchURL(context, infoEarnLink),
                ),
              ],
            ),
            const SpaceH20(),
          ],
          if (privacyEarnLink.isNotEmpty && isEarnAvaible) ...[
            Row(
              children: [
                SimpleAccountTermButton(
                  name: intl.about_us_smpl_global,
                  onTap: () => launchURL(context, privacyEarnLink),
                ),
              ],
            ),
            const SpaceH20(),
          ],
          if (privacyEarnLink.isNotEmpty && isJarAvaible) ...[
            Row(
              children: [
                SimpleAccountTermButton(
                  name: intl.about_us_jar,
                  onTap: () => launchURL(context, jarTerms),
                ),
              ],
            ),
            const SpaceH20(),
          ],
          const SpaceH40(),
        ],
      ),
    );
  }
}
