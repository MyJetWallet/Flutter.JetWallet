import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

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
          const SpaceH18(),
          STextButton2(
            icon: isPhone ? const SPhoneCallIcon() : null,
            addPadding: isPhone,
            active: true,
            autoSize: intl.localeName == 'es' || intl.localeName == 'uk' ,
            name: isPhone
                ? intl.profileDetails_receiveCall
                : intl.resetRichText_resend,
            onTap: onTap,
            
          ),
        ],
      ),
    );
  }
}
