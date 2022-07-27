import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../simple_kit.dart';
import '../../shared.dart';

class SimplePrivacyPolicyExample extends HookWidget {
  const SimplePrivacyPolicyExample({Key? key}) : super(key: key);

  static const routeName = '/simple_privacy_policy_example';

  @override
  Widget build(BuildContext context) {
    final isChecked = useState(false);

    return SPageFrameWithPadding(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SPolicyCheckbox(
            firstText: 'By clicking Agree and Continue, '
                'I hereby agree and consent to the ',
            userAgreementText: 'Terms and conditions',
            betweenText: ' and the ',
            privacyPolicyText: 'Privacy Policy',
            isChecked: isChecked.value,
            onCheckboxTap: () => isChecked.value = !isChecked.value,
            onUserAgreementTap: () => showSnackBar(context),
            onPrivacyPolicyTap: () => showSnackBar(context),
          ),
          Stack(
            children: [
              ColoredBox(
                color: Colors.grey[200]!,
                child: SPolicyCheckbox(
                  firstText: 'By clicking Agree and Continue, '
                      'I hereby agree and consent to the ',
                  userAgreementText: 'Terms and conditions',
                  betweenText: ' and the ',
                  privacyPolicyText: 'Privacy Policy',
                  isChecked: isChecked.value,
                  onCheckboxTap: () => isChecked.value = !isChecked.value,
                  onUserAgreementTap: () => showSnackBar(context),
                  onPrivacyPolicyTap: () => showSnackBar(context),
                ),
              ),
              Container(
                width: 24.0,
                height: 20.0,
                color: Colors.blue.withOpacity(0.3),
              ),
              Container(
                height: 38.0,
                color: Colors.green.withOpacity(0.3),
              ),
            ],
          ),
          const SpaceH20(),
          SPolicyText(
            firstText: 'By logging in and Continue, '
                'I hereby agree and consent to the ',
            userAgreementText: 'Terms and conditions',
            betweenText: ' and the ',
            privacyPolicyText: 'Privacy Policy',
            onUserAgreementTap: () => showSnackBar(context),
            onPrivacyPolicyTap: () => showSnackBar(context),
          ),
          Stack(
            children: [
              ColoredBox(
                color: Colors.grey[200]!,
                child: SPolicyText(
                  firstText: 'By logging in and Continue, '
                      'I hereby agree and consent to the ',
                  userAgreementText: 'Terms and conditions',
                  betweenText: ' and the ',
                  privacyPolicyText: 'Privacy Policy',
                  onUserAgreementTap: () => showSnackBar(context),
                  onPrivacyPolicyTap: () => showSnackBar(context),
                ),
              ),
              Container(
                height: 24.0,
                color: Colors.green.withOpacity(0.3),
              )
            ],
          ),
        ],
      ),
    );
  }
}
