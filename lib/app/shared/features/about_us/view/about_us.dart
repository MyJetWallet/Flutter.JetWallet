import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../shared/components/security_divider.dart';
import '../../../../../shared/components/security_option.dart';
import '../../../../../shared/components/spacers.dart';
import '../../../../../shared/helpers/launch_url.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../provider/package_info_fpod.dart';

class AboutUs extends HookWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final packageInfo = useProvider(packageInfoFpod);

    return PageFrame(
      header: 'About us',
      onBackButton: () => Navigator.pop(context),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH20(),
                Text(
                  'Simple - ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40.sp,
                  ),
                ),
                Text(
                  'The easiest place to buy, sell and manage cryptocurrency '
                  'portfolio.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                  ),
                ),
                const SpaceH30(),
                Text(
                  'Why invest with Simple: \n',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• Simple investing for everyone'
                        '\n(Superb app experience)\n',
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        '• Regulated crypto exchange\n(Licensed and '
                        'regulated digital assets '
                        'institution)\n',
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        '• Best prices\n(Transperent fees and charges)\n',
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        '• 24\\7 support\n(Superior from human to human)\n',
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SecurityOption(
                  name: 'Terms of Use',
                  onTap: () => launchURL(context, userAgreementLink),
                ),
                const SecurityDivider(),
                SecurityOption(
                  name: 'Privacy Policy',
                  onTap: () => launchURL(context, privacyPolicyLink),
                ),
                const SecurityDivider(),
                const SpaceH30(),
                packageInfo.when(
                  data: (PackageInfo info) => SizedBox(
                    width: double.infinity,
                    child: Text(
                      'App version: '
                      '${info.version} (${info.buildNumber})',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
