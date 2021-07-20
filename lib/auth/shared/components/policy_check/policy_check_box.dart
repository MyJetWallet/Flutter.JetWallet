import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../shared/components/spacers.dart';
import '../../../../../shared/helpers/launch_url.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import 'policy_text_span.dart';

class PolicyCheckBox extends StatelessWidget {
  const PolicyCheckBox({
    Key? key,
    this.onTap,
    this.isChecked = true,
  }) : super(key: key);

  final Function()? onTap;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Icon(
            isChecked ? FontAwesomeIcons.checkSquare : FontAwesomeIcons.square,
            color: Colors.grey,
            size: 22.r,
          ),
        ),
        const SpaceW8(),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey,
              ),
              children: [
                const TextSpan(
                  text: 'I agree to ',
                ),
                policyTextSpan(
                  text: 'User Agreement ',
                  onTap: () => launchURL(context, userAgreementLink),
                ),
                const TextSpan(
                  text: 'and ',
                ),
                policyTextSpan(
                  text: 'Privacy Policy',
                  onTap: () => launchURL(context, privacyPolicyLink),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
