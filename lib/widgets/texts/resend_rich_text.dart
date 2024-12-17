import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class ResendRichText extends StatelessObserverWidget {
  const ResendRichText({
    super.key,
    required this.onTap,
    this.isPhone = false,
  });

  final Function() onTap;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Center(
      child: Column(
        children: <Widget>[
          Text(
            intl.resetRichText_didntReceiveTheCode,
            style: STStyles.captionMedium.copyWith(
              color: colors.gray8,
            ),
          ),
          const SpaceH18(),
          SButtonContext(
            type: isPhone ? SButtonContextType.iconedMediumInverted : SButtonContextType.basicInverted,
            icon: isPhone ? Assets.svg.medium.phone : null,
            text: isPhone ? intl.profileDetails_receiveCall : intl.resetRichText_resend,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
