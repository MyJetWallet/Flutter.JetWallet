import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class ResendRichText extends StatelessObserverWidget {
  const ResendRichText({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Center(
      child: Column(
        children: <Widget>[
          Text(
            intl.resetRichText_didntReceiveTheCode,
            style: sCaptionTextStyle.copyWith(
              color: colors.grey2,
            ),
          ),
          const SpaceH10(),
          STextButton1(
            active: true,
            name: intl.resetRichText_resend,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
