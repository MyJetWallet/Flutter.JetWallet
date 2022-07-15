import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/core/di.dart';
import 'package:simple_kit/simple_kit.dart';

class LoadingReferralCode extends StatelessWidget {
  const LoadingReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16.0,
          height: 16.0,
          child: CircularProgressIndicator(
            color: getIt.get<SimpleKit>().colors.black,
            strokeWidth: 2.0,
          ),
        ),
        const SpaceW10(),
        Text(
          intl.loadingReferralCode_checking,
          style: sCaptionTextStyle,
        ),
      ],
    );
  }
}
